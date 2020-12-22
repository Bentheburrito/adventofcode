defmodule AOC.Day20 do
	def run(input) do
		tile_list = map_tiles(input)

		IO.inspect length(tile_list)
	end

	def match_tiles([], acc, _grid_size), do: acc
	def match_tiles([{tile_id, tile} | tile_list], acc, grid_size) do
		# Need to have an accumulative "tile" (or row) to build off of.
		case find_match(tile_list, tile) == nil do
			# {matching_id, matching_tile} ->
			nil -> find_match(tile_list, rotate(tile, 2))
		end
	end
	def match_tiles(tile_list) do
		grid_size = :math.sqrt(length(tile_list))
		match_tiles(tile_list, [], grid_size)
	end

	defp find_match(tile_list, tile_to_match) do
		Enum.find(tile_list, fn {id, pot_tile} ->
			case check_match(tile_to_match, pot_tile) do
				:none -> false
				{:ok, matching_tile} -> {id, matching_tile}
			end
		end)
	end

	defp check_match(_tile1_side, _tile2, _edge_distance, 4), do: :none
	defp check_match(tile1_side, tile2, edge_distance, sides_checked) do
		{side_filter_fun, side_sort_fun} = case sides_checked do
			0 -> {fn
				{{x, _y}, _pixel} when x == -edge_distance -> true
				_ -> false
			end, fn {{_x1, y1}, _pixel1}, {{_x2, y2}, _pixel2} -> y1 <= y2 end}
			1 -> {fn
				{{_x, ^edge_distance}, _pixel} -> true
				_ -> false
			end, fn {{x1, _y1}, _pixel1}, {{x2, _y2}, _pixel2} -> x1 <= x2 end}
			2 -> {fn
				{{^edge_distance, _y}, _pixel} -> true
				_ -> false
			end, fn {{_x1, y1}, _pixel1}, {{_x2, y2}, _pixel2} -> y1 <= y2 end}
			3 -> {fn
				{{_x, y}, _pixel} when y == -edge_distance -> true
				_ -> false
			end, fn {{x1, _y1}, _pixel1}, {{x2, _y2}, _pixel2} -> x1 <= x2 end}
		end
		tile2_side = Enum.filter(tile2, side_filter_fun) |> Enum.sort(side_sort_fun)

		if sides_equal?(tile1_side, tile2_side) do
			{:ok, rotate(tile2, sides_checked)}
		else
			check_match(tile1_side, tile2, edge_distance, sides_checked + 1)
		end
	end
	defp check_match(tile1, tile2) do
		edge_distance = div(map_size(tile1), 2)
		tile1_side = Enum.filter(tile1, fn
			{{edge_distance, _y}, pixel} -> true
			_ -> false
		end) |> Enum.sort(fn {{_x1, y1}, _pixel}, {{_x2, y2}, _pixel} -> y1 <= y2 end)
		check_match(tile1_side, tile2, edge_distance, 0)
	end

	defp sides_equal?([], []), do: true
	defp sides_equal?([pixel1 | side1], [pixel2 | side2]) do
		pixel1 == pixel2 && sides_equal?(side1, side2) || false
	end

	defp rotate(tile, ccw_steps)
	defp rotate(tile, 0), do: tile
	defp rotate(tile, 1) do
		for {{x, y}, pixel} <- tile, into: %{}, do: {{y, -x}, pixel}
	end
	defp rotate(tile, 2) do
		for {{x, y}, pixel} <- tile, into: %{}, do: {{-x, -y}, pixel}
	end
	defp rotate(tile, 3) do
		for {{x, y}, pixel} <- tile, into: %{}, do: {{-y, x}, pixel}
	end

	defp map_tiles(input) do
		input
		|> String.split("\n\n")
		|> Enum.map(fn raw_tile ->
			[header | rows] = String.split(raw_tile, "\n")
			starting_point = div(length(rows), 2)

			{mapped_tile, _y} = Enum.reduce(rows, {%{}, starting_point}, fn row, {tile, y} ->
				{updated_tile, _x} =
					row
					|> String.graphemes()
					|> Enum.reduce({tile, -starting_point}, fn
						pixel, {cur_tile, x} -> {Map.put(cur_tile, {x, y}, pixel), x + 1}
					end)
				{updated_tile, y + 1}
			end)
			{String.slice(header, 5..8), mapped_tile}
		end)
	end
end
