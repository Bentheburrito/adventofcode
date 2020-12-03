defmodule AOC.Day3 do
	def run(input) do
		map = input |> String.split("\n")

		trees1 = AOC.time(&tree_count/3, [map, 3, 1])
		IO.puts "Number of trees hit (3, 1): #{trees1}"
		trees2 = AOC.time(&tree_count/3, [map, 1, 1])
		IO.puts "Number of trees hit (1, 1): #{trees2}"
		trees3 = AOC.time(&tree_count/3, [map, 5, 1])
		IO.puts "Number of trees hit (5, 1): #{trees3}"
		trees4 = AOC.time(&tree_count/3, [map, 7, 1])
		IO.puts "Number of trees hit (7, 1): #{trees4}"
		trees5 = AOC.time(&tree_count/3, [map, 1, 2])
		IO.puts "Number of trees hit (1, 2): #{trees5}"

		IO.puts "Multipied together: #{trees1 * trees2 * trees3 * trees4 * trees5}"
	end

	def tree_count(map, travel_right, travel_down) when travel_down > 1, do: tree_count(Enum.take_every(map, travel_down), travel_right, 1)
	def tree_count(map, travel_right, _travel_down) do
		map_width = List.first(map) |> String.length()
		Enum.reduce(map, %{trees: 0, column: 0}, fn (map_row, %{trees: trees, column: col}) ->
			square = String.at(map_row, col)
			new_col = col + travel_right
			%{
				trees: square == "#" && trees + 1 || trees,
				column: new_col >= map_width && new_col - map_width || new_col
			}
		end) |> Map.get(:trees)
	end
end
