defmodule AOCTest.Y2021.Day1Test do
  use ExUnit.Case

  alias AOC.Y2021.Day1

  setup do
    input = """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """
    |> Day1.parse_input()
    %{input: input}
  end

  test "number of times the a depth measurement increases", %{input: input} do
    assert Day1.star_1(input) == 7
  end

  test "number of increasing window measurements", %{input: input} do
    assert Day1.star_2(input) == 5
  end

  AOC.run(Day1)
end
