#########################
# Neural Net
#
# Sharang Phadke
# 11/30/2013
#########################

require_relative 'node'


class NeuralNet
    def initialize(fname = nil)
        @nodes = []
        if File.exists?(fname)
            loadFromFile(fname)
        end
    end

    def loadFromFile(fname)
        File.open(fname, "r") do |file|
            #parse the number of nodes in each layer
            nnodes = file.gets.split(" ").map {|s| s.to_i}
            @nin = nnodes[0]
            @nhidden = nnodes[1]
            @nout = nnodes[2]

            @nodes = [Array.new(@nin) {Node.new},
                      Array.new(@nhidden) {Node.new},
                      Array.new(@nout) {Node.new}]
            
            @nodes[1].each do |n|
                n.weights = file.gets.split(" ").map {|s| s.to_f}
            end

            @nodes[2].each do |n|
                n.weights = file.gets.split(" ").map {|s| s.to_f}
            end

            #puts "initializing a neural network with #{@nin} input nodes, #{@nhidden} hidden nodes, and #{@nout} output nodes"
        end
    end

    # Prints Neural Network to file
    # TODO: make modular for L layers
    def printToFile(fname = nil)
        puts [@nin, @nhidden, @nout].join(" ")
        @nodes[1].each do |n|
            puts n.weights.join(" ")
        end
        @nodes[2].each do |n|
            puts n.weights.join(" ")
        end
    end

    private :loadFromFile
end
