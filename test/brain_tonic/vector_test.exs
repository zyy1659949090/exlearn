defmodule VectorTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Vector

  test "#apply applies a function on each element of the vector" do
    function = &(&1 + 1)
    input    = [1, 2, 3, 4, 5, 6]
    expected = [2, 3, 4, 5, 6, 7]

    result = Vector.apply(input, function)

    assert result == expected
  end

  test "#dot_product computes the sum of element of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = [6, 5, 6]

    result = Vector.add(first, second)

    assert result == expected
  end

  test "#dot_product computes the sum of element product of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = 20

    result = Vector.dot_product(first, second)

    assert result == expected
  end

  test "#dot_square_difference computes the sum of squared difference of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = 17

    result = Vector.dot_square_difference(first, second)

    assert result == expected
  end

  test "#substract computes the element difference of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 1]
    expected = [-4, -1, 2]

    result = Vector.substract(first, second)

    assert result == expected
  end
end
