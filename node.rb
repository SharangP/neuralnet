#########################
# Node
#
# Sharang Phadke
# 11/30/2013
#########################

class Node
    def initialize()
        @ninputs = 0
        @inputs = []
        @weights = []
        @activation = nil
    end

    attr_accessor :ninputs, :inputs, :weights, :activation
end
