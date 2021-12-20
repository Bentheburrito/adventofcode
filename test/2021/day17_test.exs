defmodule AOCTest.Y2021.Day17Test do
  use ExUnit.Case

  alias AOC.Y2021.Day17

  setup do
    input = "target area: x=20..30, y=-10..-5"
    |> Day17.parse_input()
    %{input: input}
  end

  test "Day17 part 1", %{input: input} do
    assert Day17.star_1(input) == 45
  end

  test "Day17 part 2", %{input: input} do
    assert Day17.star_2(input) == 112
  end

  AOC.run(Day17)
end
