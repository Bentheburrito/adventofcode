defmodule AOC.Day17 do
	def run(input) do
		initial_state = parse_input(input)

		six_cycles_3d = AOC.time(&run_cycles/3, [initial_state, 6, 3])
		IO.puts "The number of active cubes after 6 cycles in 3D is #{six_cycles_3d}" # actual answer 348, broke after 4D impl

		six_cycles_4d = AOC.time(&run_cycles/3, [initial_state, 6, 4])
		IO.puts "The number of active cubes after 6 cycles in 4D is #{six_cycles_4d}"
	end

	def run_cycles(state, cycle_count, current_cycle, 3) when cycle_count == current_cycle, do: Enum.count(state, fn
		{{_x, _y, _z, 0}, :active} -> true
		{_keys, _state} -> false
	end)
	def run_cycles(state, cycle_count, current_cycle, 4) when cycle_count == current_cycle, do: Enum.count(state, fn
		{_keys, :active} -> true
		{_keys, _state} -> false
	end)
	def run_cycles(state, cycle_count, current_cycle, dimensions) do
		new_state = cycle(state)
		run_cycles(new_state, cycle_count, current_cycle + 1, dimensions)
	end
	def run_cycles(init_state, cycle_count, dimensions), do: run_cycles(init_state, cycle_count, 0, dimensions)

	# Need maxes/mins?
	defp cycle(state) do
		{max_x, max_y, max_z, max_w} = Map.get(state, "max")
		cycled_state = for x <- (-max_x - 1)..(max_x + 1), y <- (-max_y - 1)..(max_y + 1), z <- (-max_z - 1)..(max_z + 1), w <- (-max_w - 1)..(max_w + 1), into: %{} do
			case {Map.get(state, {x, y, z, w}, :inactive), get_active_neighbors(state, x, y, z, w)} do
				{:active, active_neighbors} when active_neighbors not in 2..3 -> {{x, y, z, w}, :inactive}
				{:inactive, 3} -> {{x, y, z, w}, :active}
				{state, _active_neighbors} -> {{x, y, z, w}, state}
			end
		end
		Map.put(cycled_state, "max", {max_x + 1, max_y + 1, max_z + 1, max_w + 1})
	end

	defp get_active_neighbors(state, x, y, z, w) do
		for offset_x <- -1..1, offset_y <- -1..1, offset_z <- -1..1, offset_w <- -1..1, offset_x != 0 or offset_y != 0 or offset_z != 0 or offset_w != 0 do
			Map.get(state, {x + offset_x, y + offset_y, z + offset_z, w + offset_w}, :inactive)
		end
		|> Enum.count(&(&1 == :active))
	end

	defp parse_input(input) do
		z = w = 0
		rows = input |> String.split("\n")
		grid_start = -div(length(rows), 2)
		{initial_state, max_x, max_y} = Enum.reduce(rows, {%{}, grid_start, grid_start}, fn row, {space, _max_x, y} ->
			{new_space, max_x} =
				row
				|> String.graphemes()
				|> Enum.reduce({space, 0}, fn
					"#", {cur_space, x} -> {Map.put(cur_space, {x, y, z, w}, :active), x + 1}
					_cube, {cur_space, x} -> {cur_space, x + 1}
				end)
			{new_space, max_x, y + 1}
		end)
		Map.put(initial_state, "max", {max_x, max_y, 0, 0})
	end
end
