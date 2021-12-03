defmodule AOCTest.Y2021.Day3Test do
  use ExUnit.Case

  alias AOC.Y2021.Day3

  setup do
    input = """
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """
    |> Day3.parse_input()
    %{input: input}
  end

  test "Day3 part 1", %{input: input} do
    assert Day3.star_1(input) == 198
  end

  test "Day3 part 2", %{input: input} do
    assert Day3.star_2(input) == 230
  end

  AOC.run(Day3)
end
