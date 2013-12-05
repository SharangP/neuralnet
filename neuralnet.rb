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

    # Prints Neural Network to file
    def print_to_file(fname)
        File.open(fname, 'w') do |f|
            f.puts [@nin, @nhidden, @nout].join(" ")
            for i in 1..@layers.length-1
                @layers[i].each_with_index do |n, nindex|
                    f.print "%.3f " % n.bias_weight
                    n.weights.each_with_index do |w, windex|
                        f.print "%.3f" % w
                        if windex != n.weights.length-1 then f.print " " end
                    end
                    if nindex != n.weights.length-1 then f.print "\n" end
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
                $stderr.puts "Lies! nin or nout are not the same as the init file"
                exit
            end

            f.readlines.each do |line|
                l = line.split(" ").map {|d| d.to_f}
                data << l[0...-1]
                outputs << l[-1].to_i
            end
        end

        return data, outputs
    end

    # Test the performance of the neural network on a set of data
    def test(fname, outfile)
        puts "Begin testing"

        data, outputs = parse_data(fname)

        #TODO: compute metrics
        results = []
        data.each do |d|
            results << forward_propagate(d)
        end
        puts results.count(0)
        puts results.count(1)
    end

    # Train neural network
    # Train with data in file 'fname' at a learning rate of 'lrate'
    # for 'nepochs' epochs
    def train(fname, lrate, nepochs)
        puts "Begin training"
        data, outputs = parse_data(fname)
        backprop_learn(nepochs, lrate, data, outputs)
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

        return @layers[-1][0].activation.round
    end

    # Learn optimal weights using back-propagation
    # Iterate for nepochs with a learning rate of lrate, adjusting the weights
    # of @layers to map training data 'data' to outputs 'outputs'
    def backprop_learn(nepochs, lrate, data, outputs)
        nepochs.times do |e|
            puts "Epoch #{e+1} of #{nepochs}"

            data.each do |example|
                # Propagate example through network
                forward_propagate(example)

                # Propagate error backwards
                # Find deltas of output layer
                @layers[-1].each_with_index do |n, nindex|
                    n.delta = delsig(n.inval)*(outputs[nindex] - n.activation)
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

    private :forward_propagate, :backprop_learn, :sig, :delsig
end  
