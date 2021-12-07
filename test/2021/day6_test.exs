defmodule AOCTest.Y2021.Day6Test do
  use ExUnit.Case

  alias AOC.Y2021.Day6

  setup do
    input = "3,4,3,1,2"
    |> Day6.parse_input()
    %{input: input}
  end

  test "Day6 part 1", %{input: input} do
    assert Day6.star_1(input) == 5934
  end

  test "Day6 part 2", %{input: input} do
    assert Day6.star_2(input) == 26984457539
  end

  AOC.run(Day6)
end
