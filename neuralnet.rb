#########################
# Neural Net
#
# Sharang Phadke
# 11/30/2013
#########################

require_relative 'node'


# Neural Network class
class NeuralNet

    # Constructor
    def initialize()
        @layers = []
        @nin = nil
        @nhidden = nil
        @nout = nil
        @ntrain = nil
    end

    # Loads Neural Network from file
    # first line of input specifies # input nodes, # hidden nodes, and # output
    # nodes. The next nhidden lines specify the initial weights of hidden
    # nodes. The next line specifies the initial weights of output nodes.
    def load_from_file(fname)
        File.open(fname, 'r') do |f|
            #parse the number of nodes in each layer
            nnodes = f.gets.split(" ").map {|s| s.to_i}
            @nin = nnodes[0]
            @nhidden = nnodes[1]
            @nout = nnodes[2]

            @layers = [Array.new(@nin) {Node.new},
                      Array.new(@nhidden) {Node.new},
                      Array.new(@nout) {Node.new}]

            for i in 1..@layers.length-1 #TODO:use each instead
                @layers[i].each do |n|
                    line = f.gets.split(" ").map {|s| s.to_f}
                    n.bias_weight = line[0]
                    n.weights = line[1..-1]
                    n.inputs = @layers[i-1]
                end
            end
            
            $stderr.puts "initializing a neural network with #{@nin} input nodes, #{@nhidden} hidden nodes, and #{@nout} output nodes"
        end
    end

    # Print Neural Network to file
    def print_to_file(fname)
        File.open(fname, 'w') do |f|
            f.puts [@nin, @nhidden, @nout].join(" ")
            @layers[1..-1].each do |l|
                l.each_with_index do |n, nindex|
                    f.print "%.3f " % n.bias_weight
                    n.weights.each_with_index do |w, windex|
                        f.print "%.3f" % w
                        endchar = (windex == n.weights.length-1) ? "\n" : " "
                        f.print endchar
                    end
                end
            end
        end
    end

    # Parse data from training/testing data file
    def parse_data(fname)
        data = []
        outputs = []

        File.open(fname, 'r') do |f|
            nnodes = f.gets.split(" ").map {|s| s.to_i}
            @ntrain = nnodes[0]
            if nnodes[1] != @nin || nnodes[2] != @nout
                abort("Lies! nin or nout are not the same as the init file")
            end

            f.readlines.each do |line|
                l = line.split(" ").map {|d| d.to_f}
                data << l.first(@nin)
                outputs << l.last(@nout).map! {|o| o.to_i}
            end
        end

        return data, outputs
    end

    # Train neural network
    # Train with data in file 'fname' at a learning rate of 'lrate'
    # for 'nepochs' epochs
    def train(fname, lrate, nepochs)
        puts "Begin training"
        data, outputs = parse_data(fname)
        learn(nepochs, lrate, data, outputs)
    end

    # Test the performance of the neural network
    # Propagate each example in the file 'fname' through the network
    # and compute a confusion matrix, precision, recall, and f-measure.
    def test(fname, outfile)
        puts "Begin testing"

        data, outputs = parse_data(fname)
        outputs = outputs.transpose

        results = []
        data.each_with_index do |d, dindex|
            results << forward_propagate(d)
        end

        a,b,c,d = [],[],[],[]
        macro_accuracy = macro_precision = macro_recall = 0.0

        File.open(outfile, 'w') do |f|
            results.transpose.each_with_index do |result, rindex|
                z = outputs[rindex].zip(result)

                # Compute confusion matrix
                a[rindex] = a_tmp = z.count {|o,r| (o==1)&(r==1)}
                b[rindex] = b_tmp = z.count {|o,r| (o==0)&(r==1)}
                c[rindex] = c_tmp = z.count {|o,r| (o==1)&(r==0)}
                d[rindex] = d_tmp = z.count {|o,r| (o==0)&(r==0)}

                # Compute metrics
                accuracy = (a_tmp + d_tmp)/(a_tmp.to_f + b_tmp + c_tmp + d_tmp)
                precision = a_tmp/(a_tmp.to_f + b_tmp)
                recall = a_tmp/(a_tmp.to_f + c_tmp)

                # Check for NaNs
                accuracy = accuracy.nan? ? 0.0 : accuracy
                precision = precision.nan? ? 0.0 : precision
                recall = recall.nan? ? 0.0 : recall
                
                f1 = 2*precision*recall/(precision + recall)

                # Aggregate metrics
                macro_accuracy += accuracy
                macro_precision += precision
                macro_recall += recall

                f.print "%d %d %d %d %.3f %.3f %.3f %.3f\n" % [a_tmp, b_tmp, c_tmp, d_tmp, accuracy, precision, recall, f1]
            end

            global_a = a.reduce(:+).to_f
            global_b = b.reduce(:+).to_f
            global_c = c.reduce(:+).to_f
            global_d = d.reduce(:+).to_f

            # Micro-average metrics
            micro_accuracy = (global_a + global_d)/(global_a + global_b + global_c + global_d)
            micro_precision = global_a/(global_a + global_b)
            micro_recall = global_a/(global_a + global_c)
            micro_f1 = 2*micro_precision*micro_recall/(micro_precision + micro_recall)

            # Macro-average metrics
            macro_accuracy /= @nout
            macro_precision /= @nout
            macro_recall /= @nout            
            macro_f1 = 2*macro_precision*macro_recall/(macro_precision + macro_recall)
            
            f.print "%.3f %.3f %.3f %.3f\n" % [micro_accuracy, micro_precision, micro_recall, micro_f1]
            f.print "%.3f %.3f %.3f %.3f\n" % [macro_accuracy, macro_precision, macro_recall, macro_f1]
        end
    end

    # Propagate input data forward through network
    def forward_propagate(example) 
        example.each_with_index {|d, dindex| @layers[0][dindex].activation = d}

        @layers[1..-1].each do |l|
            l.each do |n|
                n.inval = n.bias_weight*Node.bias_input
                n.inputs.each_with_index {|i, iindex| n.inval += n.weights[iindex]*i.activation}
                n.activation = sig(n.inval)
            end
        end

        results = []
        @layers[-1].each {|output| results << output.activation.round}
        return results
    end

    # Learn optimal weights using back-propagation
    # Iterate for nepochs with a learning rate of lrate, adjusting the weights
    # of @layers to map training data 'data' to outputs 'outputs'
    def learn(nepochs, lrate, data, outputs)
        nepochs.times do |e|
            puts "Epoch #{e+1} of #{nepochs}"

            data.zip(outputs).each do |example|
                # Propagate example through network
                forward_propagate(example[0])

                # Propagate error backwards
                # Find deltas of output layer
                @layers[-1].each_with_index do |n, nindex|
                    n.delta = delsig(n.inval)*(example[1][nindex] - n.activation)
                end

                # Find deltas of each hidden layer
                (1..1).each do |l| #TODO: make more general
                    @layers[l].each_with_index do |n, nindex|
                        error = 0
                        @layers[l+1].each {|j| error += j.weights[nindex]*j.delta}
                        n.delta = delsig(n.inval)*error
                    end
                end

                # Adjust all weights
                @layers[1..-1].reverse.each do |l|
                    l.each do |n|
                        n.bias_weight += lrate*Node.bias_input*n.delta
                        n.inputs.each_with_index {|i, iindex| n.weights[iindex] += lrate*i.activation*n.delta}
                    end
                end
            end
        end
    end

    # Sigmoid activation function
    def sig(x)
        return 1/(1+Math.exp(-x))
    end

    # Derivative of sigmoid function
    def delsig(x)
        return sig(x)*(1-sig(x))
    end

    private :forward_propagate, :learn, :sig, :delsig
end  
