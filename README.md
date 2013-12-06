NeuralNet
=========

A Neural Network implementation in Ruby

This implementation of a neural network in ruby allows for training and testing using text files in a specified format. Training consists of loading the initial weights for the neural network from a file, and adjusting the weights using the examples provided in the data file. Weights are adjusted using back-propagation. Testing consists of propagating each example provided in a data file through the network and computing a confusion matrix, accuracy, precision, recall, and f-measure for each output node, as well as micro and macro averages of each metric.
