defmodule AOC.Y2021.Day2 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day2.txt"
  end

  def parse_input(input) do
    input |> String.trim() |> String.split("\n")
  end

  def star_1(instructions) do
    {end_x, end_y} = Enum.reduce(instructions, {0, 0}, fn
      "forward " <> num_str, {x, y} -> {x + String.to_integer(num_str), y}
      "up " <> num_str, {x, y} -> {x, y - String.to_integer(num_str)}
      "down " <> num_str, {x, y} -> {x, y + String.to_integer(num_str)}
    end)
  end_x * end_y
	end

  def star_2(instructions) do
    {end_x, end_y, _aim} = Enum.reduce(instructions, {0, 0, 0}, fn
      "forward " <> num_str, {x, y, aim} -> {x + String.to_integer(num_str), y + String.to_integer(num_str) * aim, aim}
      "up " <> num_str, {x, y, aim} -> {x, y, aim - String.to_integer(num_str)}
      "down " <> num_str, {x, y, aim} -> {x, y, aim + String.to_integer(num_str)}
    end)
  end_x * end_y
  end
end
