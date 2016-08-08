# Using the data loading module defined in the same folder.
Code.require_file("data_loader.exs", __DIR__)

# Converts the raw data from archives to a format that the library expects.
# The parameter represent the number of files that will be created for each
# data set. The files will contain data distributed as evenly as possible.
# You only need to do this once. Comment the following line after runing it
# the first time.
DataLoader.convert(4)

# Aliasing the module name for brevity.
alias ExLearn.NeuralNetwork, as: NN

# Defines the network structure.
structure_parameters = %{
  layers: %{
    input:   %{size: 784},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 30}],
    output:  %{activity: :logistic, name: "Output",       size: 10}
  },
  objective: :quadratic
}

# Creates the neural network structure.
network = NN.create(structure_parameters)

# Next comes the network initialization. Skip this if you intend to load an
# already saved state.

# Defines the initialization parameters.
initialization_parameters = %{distribution: :uniform, range: {-1, 1}}

# Initializes the neural network.
NN.initialize(initialization_parameters)

# If you already have a saved state you can load it with the following:
# NN.load("samples/mnist-digits/saved_network.el1", network)

# Defines the learning parameters.
learning_parameters = %{
  training: %{
    batch_size:    100,
    data_path:     "samples/mnist-digits/data/training_data-*.eld",
    data_size:     50000,
    epochs:        1,
    learning_rate: 3,
  },
  validation: %{
    data_path: "samples/mnist-digits/data/validation_data-*.eld",
    data_size: 10000,
  },
  test: %{
    data_path: "samples/mnist-digits/data/test_data-*.eld",
    data_size: 10000,
  },
  workers: 4
}

# Starts the notifications stream which will output events to stdout without
# blocking execution or the prompt.
NN.notifications(:start, network)

# Trains the network. Blocks untill the training finishes.
NN.train(learning_parameters, network) |> Task.await(:infinity)

# Loading an image from the test data for preview.
[{first_image, first_label}|_] = DataLoader.load("samples/mnist-digits/data/test_data-0.eld")
DataLoader.preview_image(first_image)
IO.inspect first_label

ask_data = [first_image]

# Asks the network to clasify an image.
NN.ask(ask_data, network) |> Task.await(:infinity) |> IO.inspect

# Saves the network state so it can be loaded ack later.
NN.save("samples/mnist-digits/saved_network.el1", network)
