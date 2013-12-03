#########################
# Node
#
# Sharang Phadke
# 11/30/2013
#########################

# Neural Network Node class

class Node
    @@bias_input = -1
    
    def self.bias_input
        @@bias_input
    end

    def initialize()
        @inputs = []
        @weights = []
        @inval = nil
        @activation = nil
        @delta = nil
    end

    attr_accessor :inputs, :weights, :inval, :activation, :delta
end
