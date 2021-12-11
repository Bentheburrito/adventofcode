defmodule AOCTest.Y2021.Day10Test do
  use ExUnit.Case

  alias AOC.Y2021.Day10

  setup do
    input = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """
    |> Day10.parse_input()
    %{input: input}
  end

  test "Day10 part 1", %{input: input} do
    assert Day10.star_1(input) == 26397
  end

  test "Day10 part 2", %{input: input} do
    assert Day10.star_2(input) == 288957
  end

  AOC.run(Day10)
end
