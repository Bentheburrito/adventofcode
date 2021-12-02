defmodule AOCTest do
  use ExUnit.Case

  alias AOC.Y2021.Day2
  @input_path "./lib/2021/input/day2.txt"

  setup do
    input = """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """
    |> Day2.parse_input()
    %{input: input}
  end

  test "evaluates path to correct destination", %{input: input} do
    assert Day2.star_1(input) == 150
  end

  test "evaluates path to correct destination with new instruction interpretation", %{input: input} do
    assert Day2.star_2(input) == 900
  end

  Day2.run(File.read!(@input_path))
end
