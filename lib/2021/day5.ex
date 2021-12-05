defmodule AOC.Y2021.Day5 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day5.txt"
  end

  def parse_input(input) do
    input
    |> String.split([",", " -> ", "\n"], trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(4)
    |> Stream.map(fn [x1, y1, x2, y2] -> {{x1, y1}, {x2, y2}} end)
  end

  def star_1(lines) do
    lines
    |> Stream.filter(fn {{x1, y1}, {x2, y2}} -> x1 == x2 or y1 == y2 end)
    |> Enum.reduce(%{}, &place_line/2)
    |> Enum.count(fn {_points, point_val} -> point_val >= 2 end)
	end

  def star_2(lines) do
    Enum.reduce(lines, %{}, &place_line/2)
    |> Enum.count(fn {_points, point_val} -> point_val >= 2 end)
  end

  defp place_line({{x1, y1}, {x2, y2}}, point_values) when x1 == x2 do
    for y <- y1..y2, reduce: point_values do
      acc -> Map.update(acc, {x1, y}, 1, & &1 + 1)
    end
  end

  defp place_line({{x1, y1}, {x2, y2}}, point_values) when y1 == y2 do
    for x <- x1..x2, reduce: point_values do
      acc -> Map.update(acc, {x, y1}, 1, & &1 + 1)
    end
  end

  defp place_line({{x1, y1}, {x2, y2}}, point_values) do
    Stream.zip(x1..x2, y1..y2)
    |> Enum.reduce(point_values, &Map.update(&2, &1, 1, fn count -> count + 1 end))
  end
end
