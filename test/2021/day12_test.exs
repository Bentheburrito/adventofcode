defmodule AOCTest.Y2021.Day12Test do
  use ExUnit.Case

  alias AOC.Y2021.Day12

  setup do
    input = """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """
    |> Day12.parse_input()
    %{input: input}
  end

  test "Day12 part 1", %{input: input} do
    assert Day12.star_1(input) == 19
  end

  test "Day12 part 2", %{input: input} do
    assert Day12.star_2(input) == 103
  end

  AOC.run(Day12)
end
