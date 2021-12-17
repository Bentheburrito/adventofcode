defmodule AOC.Y2021.Day13 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day13.txt"
  end

  def parse_input(input) do
    [points, folds] = String.split(input, "\n\n", trim: true)

    points =
      for pair <- String.split(points, "\n", trim: true), into: %{} do
        [x, y] =
          pair
          |> String.split(",", trim: true)
          |> Enum.map(&String.to_integer/1)

        {{x, y}, "#"}
      end

    folds =
      for "fold along " <> line <- String.split(folds, "\n", trim: true) do
        [axis, val] = String.split(line, "=", trim: true)

        {String.to_atom(axis), String.to_integer(val)}
      end

    IO.inspect folds
    {points, folds}
  end

  def star_1({points, [{axis, val} | _folds]}) do
    points
    |> fold(axis, val)
    |> map_size()
	end

  defp fold(points, axis, val) do
    Enum.reduce(points, %{}, fn
      {pos, _}, points_acc -> Map.put(points_acc, fold_point(pos, axis, val), "#")
    end)
  end

  defp fold_point({x, y}, :x, val) when x < val, do: {x, y}
  defp fold_point({x, y}, :x, val) when x > val, do: {val - abs(val - x), y}
  defp fold_point({x, y}, :y, val) when y < val, do: {x, y}
  defp fold_point({x, y}, :y, val) when y > val, do: {x, val - abs(val - y)}

  def star_2({points, folds}) do
    fold_all(points, folds)
    |> print()
  end

  defp fold_all(points, []), do: points
  defp fold_all(points, [{axis, val} | folds]) do
    fold_all(fold(points, axis, val), folds)
  end

  defp print(points) do
    IO.inspect points, limit: :infinity
    IO.puts("")
    for y <- 0..6, x <- 0..200 do
      IO.write(Map.get(points, {x, y}, "."))
      if x == 200, do: IO.write("\n")
    end
    :ok
  end
end
