defmodule AOCTest.Y2021.Day13Test do
  use ExUnit.Case

  alias AOC.Y2021.Day13

  setup do
    input = """
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    """
    |> Day13.parse_input()
    %{input: input}
  end

  test "Day13 part 1", %{input: input} do
    assert Day13.star_1(input) == 17
  end

  test "Day13 part 2", %{input: input} do
    assert Day13.star_2(input) == :ok
  end

  AOC.run(Day13)
end
