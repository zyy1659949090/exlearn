alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 1},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 2}],
    output:  %{activity: :tanh,     name: "Output",       size: 1}
  },
  objective: :quadratic,
  random:    %{distribution: :uniform, range: {-1, 1}}
}

network = NN.initialize(structure_parameters)

training_data = [
  {[0], [1]},
  {[1], [0]}
]

configuration = %{
  batch_size:     2,
  data_size:      4,
  epochs:         1000,
  dropout:        0.5,
  learning_rate:  0.5,
  regularization: :L2
}

NN.feed(training_data, configuration, network)

ask_data = [[0], [1]]

result = NN.ask(ask_data, network)

IO.inspect result
