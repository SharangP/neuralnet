#!/usr/bin/ruby

####################
# Main Program
# Neural Network in Ruby
#
# Sharang Phadke
# 11/30/2013
####################

require_relative 'neuralnet'

#puts "Welcome to Sharang's Neural Net Program"
#print "Enter an initialization file name: "
#init = gets.chomp
#print "Enter a training file name: "
#train = gets.chomp
#print "Enter an output file name: "
#out = gets.chomp

init = 'data/sample.NNWDBC.init'
nn = NeuralNet.new(init)
nn.printToFile('test.out')
