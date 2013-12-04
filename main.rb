#!/usr/bin/ruby

####################
# Main Program
# Neural Network in Ruby
#
# Sharang Phadke
# 11/30/2013
####################

require_relative 'neuralnet'


# Prompts user until valid filepath is entered
def file_prompt()
    fname = gets.chomp
    while !File.exists?(fname)
        print "Invalid file path please try again: "
        fname = gets.chomp
    end
    return fname
end


# MAIN PROGRAM
puts "Welcome to Sharang's Neural Net Program"
print "Training (0) or testing (1)?: "
isTest = gets.chomp.to_i
#TODO: make sure isTest is 0 or 1

print "Enter an initialization file name: "
#init = file_prompt()
print "Enter a training/testing file name: "
#data = file_prompt()
print "Enter an output file name: "
#out = gets.chomp

init = 'data/sample.NNWDBC.init' #remove

nn = NeuralNet.new
nn.load_from_file(init)

isTest = 0 #remove
case isTest
when 0
    data = 'data/wdbc.mini_train'
    #data = 'data/wdbc.train'
    out = 'my_wwbdc_mini.trained'

    print "Enter a learning rate: "
    learningRate = gets.chomp.to_f
    print "Enter a number of epochs to train for: "
    nepochs = gets.chomp.to_i

    learningRate = 0.1

    nn.train(data, learningRate, nepochs)
    nn.print_to_file(out)
when 1
    puts "This should probably test the NN."
end

