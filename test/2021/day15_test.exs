defmodule AOCTest.Y2021.Day15Test do
  use ExUnit.Case

  alias AOC.Y2021.Day15

  setup do
    input = """
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    """
    |> Day15.parse_input()
    %{input: input}
  end

  test "Day15 part 1", %{input: input} do
    assert Day15.star_1(input) == 40
  end

  test "Day15 part 2", %{input: input} do
    assert Day15.star_2(input) == 315
  end

  AOC.run(Day15) # 3638 too high, 1345 too low
end
