defmodule AOCTest.Y2021.Day5Test do
  use ExUnit.Case

  alias AOC.Y2021.Day5

  setup do
    input = """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """
    |> Day5.parse_input()
    %{input: input}
  end

  test "Day5 part 1", %{input: input} do
    assert Day5.star_1(input) == 5
  end

  test "Day5 part 2", %{input: input} do
    assert Day5.star_2(input) == 12
  end

  AOC.run(Day5)
end
