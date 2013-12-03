#########################
# Node
#
# Sharang Phadke
# 11/30/2013
#########################

# Neural Network Node class

class Node
    def initialize()
        @@bias_input = -1
        @inputs = []
        @weights = []
        @inval = nil
        @activation = nil
        @delta = nil
    end

#    attr_reader :bias_input
    attr_accessor :inputs, :weights, :inval, :activation, :delta
end
