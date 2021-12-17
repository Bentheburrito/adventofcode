defmodule AOCTest.Y2021.Day14Test do
  use ExUnit.Case

  alias AOC.Y2021.Day14

  setup do
    input = """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """
    |> Day14.parse_input()
    %{input: input}
  end

  test "Day14 part 1", %{input: input} do
    assert Day14.star_1(input) == 1588
  end

  test "Day14 part 2", %{input: input} do
    assert Day14.star_2(input) == 2188189693529
  end

  AOC.run(Day14)
end
