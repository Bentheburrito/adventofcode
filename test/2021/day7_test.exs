defmodule AOCTest.Y2021.Day7Test do
  use ExUnit.Case

  alias AOC.Y2021.Day7

  setup do
    input = "16,1,2,0,4,2,7,1,2,14"
    |> Day7.parse_input()
    %{input: input}
  end

  test "Day7 part 1", %{input: input} do
    assert Day7.star_1(input) == 37
  end

  test "Day7 part 2", %{input: input} do
    assert Day7.star_2(input) == 168
  end

  AOC.run(Day7)
end
