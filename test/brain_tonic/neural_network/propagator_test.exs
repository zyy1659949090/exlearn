defmodule PropagatorTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork.{Builder, Propagator}

  @hidden_sizes [10]
  @input        [0, 1, 2, 3, 4]
  @input_size   5
  @output_size  1

  setup do
    parameters = %{
      layers: %{
        hidden: [
          %{
            activity: :identity,
            size: Enum.at(@hidden_sizes, 0)
          }
        ],
        input: %{
          size: @input_size
        },
        output: %{
          activity: :identity,
          size: @output_size
        }
      },
      learning_rate: 0.5,
      objective: :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    result = Builder.initialize(parameters)

    {:ok, result: result}
  end

  test "#feed_forward_for_output returns a list of numbers", %{result: result} do
    output = Propagator.feed_forward_for_output(@input, result)

    assert output |> is_list
    assert length(output) == @output_size

    Enum.each(output, fn (element) ->
      assert element |> is_number
    end)
  end

  test "#feed_forward_for_activity returns a map", %{result: result} do
    activities = Propagator.feed_forward_for_activity(@input, result)

    assert activities |> is_map

    %{activity: activity, output: output} = activities

    assert length(output)     == length(@hidden_sizes)
    assert length(activity) == length(@hidden_sizes) + 1

    Enum.each(activity, fn (element) ->
      assert element |> is_map
    end)

    Enum.each(output, fn (element) ->
      assert element |> is_number
    end)
  end

  test "#back_propagate returns a map", %{result: result} do
    activities = Propagator.feed_forward_for_activity(@input, result)

    %{activity: activity, output: output} = activities

    new_state = Propagator.back_propagate(result, activity, [123])

    assert new_state |> is_map
  end
end
