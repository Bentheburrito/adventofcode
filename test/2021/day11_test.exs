defmodule AOCTest.Y2021.Day11Test do
  use ExUnit.Case

  alias AOC.Y2021.Day11

  setup do
    input = """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """
    |> Day11.parse_input()
    %{input: input}
  end

  test "Day11 part 1", %{input: input} do
    assert Day11.star_1(input) == 1656
  end

  test "Day11 part 2", %{input: input} do
    assert Day11.star_2(input) == 195
  end

  AOC.run(Day11)
end
