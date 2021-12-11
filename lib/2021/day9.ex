defmodule AOC.Y2021.Day9 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day9.txt"
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end

  def star_1(height_map) do
    row_length = elem(height_map, 0) |> tuple_size()
    col_length = tuple_size(height_map)

    for x <- 0..row_length, y <- 0..col_length, reduce: 0 do
      risk_level ->
        if low_point?(height_map, x, y) do
          risk_level + get(height_map, x, y) + 1
        else
          risk_level
        end
    end
  end

  @neighbors [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

  defp low_point?(height_map, x, y) do
    Enum.all?(@neighbors, fn {x_adjust, y_adjust} ->
      get(height_map, x, y) < get(height_map, x + x_adjust, y + y_adjust)
    end)
  end

  defp get(height_map, x, y) do
    height_map |> elem(y) |> elem(x)
  rescue
    # if {x, y} is an edge/corner square, return :infinity on neighbors that are the cave wall
    _ -> :infinity
  end

  def star_2(height_map) do
    height_map
    |> build_sets()
    |> join_to_basins()
    # |> debug(height_map)
    |> Stream.map(&MapSet.size(&1))
    |> Enum.sort(:desc)
    |> Stream.take(3)
    |> Enum.product()
  end

  def debug(sorted_basins, height_map) do
    colors = [
      IO.ANSI.blue(),
      IO.ANSI.yellow(),
      IO.ANSI.green(),
      IO.ANSI.red(),
      IO.ANSI.cyan(),
      IO.ANSI.magenta(),
      IO.ANSI.cyan_background(),
      IO.ANSI.blue_background(),
      IO.ANSI.green_background()
    ]

    row_length = (elem(height_map, 0) |> tuple_size()) - 1
    col_length = tuple_size(height_map) - 1

    for y <- 0..col_length, x <- 0..row_length do
      el = get(height_map, x, y)
      member? = Enum.find(sorted_basins, false, &MapSet.member?(&1, {x, y}))

      color =
        cond do
          member? && el == 9 -> IO.ANSI.blue()
          member? && el < 9 -> Enum.at(colors, rem(MapSet.size(member?), length(colors)))
          member? -> IO.ANSI.red()
          el < 9 -> IO.ANSI.yellow()
          true -> IO.ANSI.default_color()
        end

      IO.write("#{color}#{el}#{IO.ANSI.default_color()}#{IO.ANSI.default_background()}")

      # IO.write("#{color}#{String.pad_leading("#{MapSet.size(member? || MapSet.new)}", 3)}#{IO.ANSI.default_color()}")

      if x == row_length, do: IO.write("\n")
    end

    sorted_basins
  end

  defp build_sets(height_map) do
    row_length = (elem(height_map, 0) |> tuple_size()) - 1
    col_length = tuple_size(height_map) - 1

    for y <- 0..col_length, x <- 0..row_length, reduce: [] do
      sets ->
        if get(height_map, x, y) < 9 do
          neighbors = get_neighbor_positions(height_map, x, y)
          [MapSet.new([{x, y} | neighbors]) | sets]
        else
          sets
        end
    end
  end

  defp get_neighbor_positions(height_map, x, y) do
    Enum.reduce(@neighbors, [], fn {x_adjust, y_adjust}, valid_neighbors ->
      neighbor = get(height_map, x + x_adjust, y + y_adjust)

      if neighbor < 9 do
        [{x + x_adjust, y + y_adjust} | valid_neighbors]
      else
        valid_neighbors
      end
    end)
  end

  defp join_to_basins([], basins), do: basins

  defp join_to_basins([group | rest], basins) do
    {basin, remaining_sets, changes_made?} =
      Enum.reduce(rest, {group, _remaining = [], false}, fn set,
                                                            {basin, remaining_sets, changes_made?} ->
        if not MapSet.disjoint?(set, basin) do
          {MapSet.union(set, basin), remaining_sets, true}
        else
          {basin, [set | remaining_sets], changes_made?}
        end
      end)

    if changes_made? do
      join_to_basins([basin | remaining_sets], basins)
    else
      join_to_basins(remaining_sets, [basin | basins])
    end
  end

  defp join_to_basins(mapsets) do
    join_to_basins(mapsets, [])
  end
end
