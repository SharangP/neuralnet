#########################
# Neural Net
#
# Sharang Phadke
# 11/30/2013
#########################

require_relative 'node'


class NeuralNet
    def initialize()
        @nodes = []
        @nin = nil
        @nhidden = nil
        @nout = nil
    end

    # Loads Neural Network from file
    # first line of input specifies # input nodes, # hidden nodes, and # output
    # nodes. The next nhidden lines specify the initial weights of hidden
    # nodes. The next line specifies the initial weights of output nodes.
    def load_from_file(fname)
        File.open(fname, 'r') do |file|
            #parse the number of nodes in each layer
            nnodes = file.gets.split(" ").map {|s| s.to_i}
            @nin = nnodes[0]
            @nhidden = nnodes[1]
            @nout = nnodes[2]

            @nodes = [Array.new(@nin) {Node.new},
                      Array.new(@nhidden) {Node.new},
                      Array.new(@nout) {Node.new}]
            
            for i in 1..@nodes.length-1
                @nodes[i].each do |n|
                    n.weights = file.gets.split(" ").map {|s| s.to_f}
                end
            end
            
            $stderr.puts "initializing a neural network with #{@nin} input nodes, #{@nhidden} hidden nodes, and #{@nout} output nodes"
        end
    end

    # Prints Neural Network to file
    def print_to_file(fname = nil)
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
        puts "train now."
    end

end
