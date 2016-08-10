defmodule ExLearn.NeuralNetwork.WorkerTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Worker

  setup do
    function   = fn(x) -> x + 1 end
    derivative = fn(_) -> 1     end
    objective  = fn(a, b, _c) ->
      Enum.zip(b, a) |> Enum.map(fn({x, y}) -> x - y end)
    end

    timestamp = :os.system_time(:micro_seconds) |> to_string
    path      = "test/temp/exlearn-neural_network-worker_test" <> timestamp

    network_state = %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[1, 2, 3]],
            weights:  [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[4, 5]],
            weights:  [[1, 2], [3, 4], [5, 6]]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[6, 7]],
            weights:  [[1, 2], [3, 4]]
          },
        ],
        objective: %{error: objective}
      }
    }

    name    = {:global, make_ref()}
    options = [name: name]

    {:ok, setup: %{
      name:          name,
      network_state: network_state,
      options:       options,
      path:          path
    }}
  end

  test "#start with data in file returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options,
      path:    path
    } = setup

    data   = [{[1, 2, 3], [1900, 2800]}, {[2, 3, 4], [2600, 3800]}]
    binary = :erlang.term_to_binary(data)
    :ok    = File.write(path, binary)

    args = %{
      batch_size:    1,
      data:          [path],
      learning_rate: 2
    }

    {:ok, worker_pid} = Worker.start(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference

    :ok = File.rm(path)
  end

  test "#start with data in memory returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    args = %{
      batch_size: 1,
      data: [
        {[1, 2, 3], [1900, 2800]},
        {[2, 3, 4], [2600, 3800]}
      ],
      learning_rate: 2
    }

    {:ok, worker_pid} = Worker.start(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#start with empty data returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    args = %{
      batch_size:    1,
      data:          [],
      learning_rate: 2
    }

    {:ok, worker_pid} = Worker.start(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#start_link with data in file returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options,
      path:    path
    } = setup

    data   = [{[1, 2, 3], [1900, 2800]}, {[2, 3, 4], [2600, 3800]}]
    binary = :erlang.term_to_binary(data)
    :ok    = File.write(path, binary)

    args = %{
      batch_size:    1,
      data:          [path],
      learning_rate: 2
    }

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference

    :ok = File.rm(path)
  end

  test "#start_link with data in memory returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    args = %{
      batch_size: 1,
      data: [
        {[1, 2, 3], [1900, 2800]},
        {[2, 3, 4], [2600, 3800]}
      ],
      learning_rate: 2
    }

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#work|:ask with data in file returns the ask data", %{setup: setup} do
    %{
      name:          worker,
      network_state: network_state,
      options:       options,
      path:          path
    } = setup

    data   = [[1, 2, 3]]
    binary = :erlang.term_to_binary(data)
    :ok    = File.write(path, binary)

    args = %{
      batch_size:    1,
      data:          [path],
      learning_rate: 2
    }

    {:ok, _pid} = Worker.start_link(args, options)

    expected = [[1897, 2784]]
    result   = Worker.work(:ask, network_state, worker)

    assert result == expected

    :ok = File.rm(path)
  end

  test "#work|:ask with data in memory returns the ask data", %{setup: setup} do
    %{
      name:          worker,
      network_state: network_state,
      options:       options
    } = setup

    args = %{
      batch_size:    1,
      data:          [[1, 2, 3]],
      learning_rate: :none
    }

    {:ok, _pid} = Worker.start_link(args, options)

    expected = [[1897, 2784]]
    result   = Worker.work(:ask, network_state, worker)

    assert result == expected
  end

  test "#work|:train with data in file returns the correction", %{setup: setup} do
    %{
      name:          worker = {:global, reference},
      network_state: network_state,
      options:       options,
      path:          path
    } = setup

    data   = [{[1, 2, 3], [1900, 2800]}, {[2, 3, 4], [2600, 3800]}]
    binary = :erlang.term_to_binary(data)
    :ok    = File.write(path, binary)

    args = %{
      batch_size:    1,
      data:          [path],
      learning_rate: 2
    }

    {:ok, worker_pid} = Worker.start_link(args, options)

    Worker.work(:train, network_state, worker)
    {:continue, first_correction } = Worker.get(worker)

    Worker.work(:train, network_state, worker)
    {:done, second_correction} = Worker.get(worker)

    first_expected_correction = {
      [
        [[-181, -397, -613]],
        [[-35,  -73]],
        [[-3,   -16]]
      ],
      [
        [
          [-181, -397,  -613 ],
          [-362, -794,  -1226],
          [-543, -1191, -1839]
        ],
        [
          [-1120, -2336],
          [-1365, -2847],
          [-1610, -3358]
        ],
        [
          [-1152, -6144],
          [-1506, -8032]
        ]
      ]
    }

    second_expected_correction = {
      [
        [[600, 1312, 2024]],
        [[112, 244]],
        [[20,  46]]
      ],
      [
        [
          [1200, 2624, 4048],
          [1800, 3936, 6072],
          [2400, 5248, 8096]
        ],
        [
          [4928, 10736],
          [6048, 13176],
          [7168, 15616]
        ],
        [
          [10620, 24426],
          [13880, 31924]
        ]
      ]
    }

    assert first_correction  == first_expected_correction
    assert second_correction == second_expected_correction

    assert Worker.get(worker) == :no_data

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference

    :ok = File.rm(path)
  end

  test "#work|:train with data in memory returns the correction", %{setup: setup} do
    %{
      name:          worker = {:global, reference},
      network_state: network_state,
      options:       options
    } = setup

    args = %{
      batch_size: 1,
      data: [
        {[1, 2, 3], [1900, 2800]},
        {[2, 3, 4], [2600, 3800]}
      ],
      learning_rate: 2
    }

    {:ok, worker_pid} = Worker.start_link(args, options)

    Worker.work(:train, network_state, worker)
    {:continue, first_correction } = Worker.get(worker)

    Worker.work(:train, network_state, worker)
    {:done, second_correction} = Worker.get(worker)

    first_expected_correction = {
      [
        [[-181, -397, -613]],
        [[-35,  -73]],
        [[-3,   -16]]
      ],
      [
        [
          [-181, -397,  -613 ],
          [-362, -794,  -1226],
          [-543, -1191, -1839]
        ],
        [
          [-1120, -2336],
          [-1365, -2847],
          [-1610, -3358]
        ],
        [
          [-1152, -6144],
          [-1506, -8032]
        ]
      ]
    }

    second_expected_correction = {
      [
        [[600, 1312, 2024]],
        [[112, 244]],
        [[20,  46]]
      ],
      [
        [
          [1200, 2624, 4048],
          [1800, 3936, 6072],
          [2400, 5248, 8096]
        ],
        [
          [4928, 10736],
          [6048, 13176],
          [7168, 15616]
        ],
        [
          [10620, 24426],
          [13880, 31924]
        ]
      ]
    }

    assert first_correction  == first_expected_correction
    assert second_correction == second_expected_correction

    assert Worker.get(worker) == :no_data

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end
end
