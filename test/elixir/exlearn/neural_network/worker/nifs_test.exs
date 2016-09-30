[
  "test/elixir/test_util.exs",
  "test/elixir/fixtures/file_fixtures.exs",
]
|> Enum.map(&Code.require_file/1)

defmodule ExLearn.NeuralNetwork.Worker.NifsTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Worker

  alias ExLearn.TestUtil
  alias ExLearn.FileFixtures

  test "#create_worker_data can be called" do
    first_data  = FileFixtures.first_data_bundle
    second_data = FileFixtures.second_data_bundle

    first_path  = TestUtil.temp_file_path("exlearn-neural_network-worker-nifs_test_1")
    second_path = TestUtil.temp_file_path("exlearn-neural_network-worker-nifs_test_2")

    :ok  = File.write(first_path,  first_data )
    :ok  = File.write(second_path, second_data)

    assert Worker.create_worker_data([first_path, second_path]) != []

    :ok = File.rm(first_path )
    :ok = File.rm(second_path)
  end
end
