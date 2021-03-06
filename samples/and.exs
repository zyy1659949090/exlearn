alias ExLearn.Matrix
alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 2},
    hidden: [%{activity: :logistic, size: 2}],
    output:  %{activity: :tanh,     size: 1}
  },
  objective:    :quadratic,
  presentation: :round
}

initialization_parameters = %{
  distribution: :uniform,
  maximum:       1,
  minimum:      -1
}

training_data = [
  {Matrix.new(1, 2, [[0, 0]]), Matrix.new(1, 2, [[0]])},
  {Matrix.new(1, 2, [[0, 1]]), Matrix.new(1, 2, [[0]])},
  {Matrix.new(1, 2, [[1, 0]]), Matrix.new(1, 2, [[0]])},
  {Matrix.new(1, 2, [[1, 1]]), Matrix.new(1, 2, [[1]])}
]

prediction_data = [
  {0, Matrix.new(1, 2, [[0, 0]])},
  {1, Matrix.new(1, 2, [[0, 1]])},
  {2, Matrix.new(1, 2, [[1, 0]])},
  {3, Matrix.new(1, 2, [[1, 1]])}
]

data = %{
  train:   %{data: training_data,   size: 4},
  predict: %{data: prediction_data, size: 4}
}

parameters = %{
  batch_size:    2,
  epochs:        1000,
  learning_rate: 0.5,
  workers:       2
}

structure_parameters
|> NN.create
|> NN.initialize(initialization_parameters)
|> NN.process(data, parameters)
|> NN.result
|> Enum.map(fn({id, output}) ->
  IO.puts "------------------------------"
  IO.puts "Input ID: #{id}"
  IO.puts "Output: #{output}"
end)
