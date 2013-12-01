#########################
# Neural Net
#
# Sharang Phadke
# 11/30/2013
#########################

require_relative 'node'


class NeuralNet

    # Constructor
    def initialize()
        @nodes = []
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

            @nodes = [Array.new(@nin) {Node.new},
                      Array.new(@nhidden) {Node.new},
                      Array.new(@nout) {Node.new}]
            
            for i in 1..@nodes.length-1
                @nodes[i].each do |n|
                    n.weights = f.gets.split(" ").map {|s| s.to_f}
                end
            end
            
            $stderr.puts "initializing a neural network with #{@nin} input nodes, #{@nhidden} hidden nodes, and #{@nout} output nodes"
        end
    end

    # Prints Neural Network to file
    # #TODO: add stdout printing if fname==nil
    def print_to_file(fname)
        File.open(fname, 'w') do |f|
            f.puts [@nin, @nhidden, @nout].join(" ")
            for i in 1..@nodes.length-1
                @nodes[i].each_with_index do |n, nindex|
                    n.weights.each_with_index do |w, windex|
                        f.print "%.3f" % w
                        if windex != n.weights.length-1 then f.print " " end
                    end
                    if nindex != n.weights.length-1 then f.print "\n" end
                end
            end
        end
    end

    # Train neural network
    # Train with data in file 'fname' at a learning rate of 'rate'
    # for 'nepochs' epochs
    def train(fname, rate, nepochs)
        puts "Begin training"
        File.open(fname, 'r') do |f|
            #parse the number of nodes in each layer
            nnodes = f.gets.split(" ").map {|s| s.to_i}
            @ntrain = nnodes[0]
            if nnodes[1] != @nin || nnodes[2] != @nout
                $stderr.puts "Lies! nin or nout are not the same as the init file"
                exit
            end

            data = []
            outputs = []
            f.readlines.each do |line|
                l = line.split(" ").map {|d| d.to_f}
                data << l[0...-1]
                outputs << l[-1].to_i
            end
            @nodes = backprop_learn(@nodes, data, outputs)
        end
    end

    # Learn optimal weights using backpropagation
    # Iterate for nepochs, adjusting the weights of the NN 'nn' to map training
    # data 'data' to outputs 'outputs'
    def backprop_learn(nn, data, outputs)
        return nn
    end

    private :backprop_learn
end
