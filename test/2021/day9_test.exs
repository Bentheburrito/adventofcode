defmodule AOCTest.Y2021.Day9Test do
  use ExUnit.Case

  alias AOC.Y2021.Day9

  setup do
    input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
    |> Day9.parse_input()
    %{input: input}
  end

  test "Day9 part 1", %{input: input} do
    assert Day9.star_1(input) == 15
  end

  test "Day9 part 2", %{input: input} do
    assert Day9.star_2(input) == 1134
  end

  AOC.run(Day9)
end
