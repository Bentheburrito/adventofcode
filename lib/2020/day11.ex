defmodule AOC.Day11 do
	# This solution is horrifically slow. If I refactored this I'd probably make one map with all the rows, and multiply the y coord by the row width to find a point.
	def run(input) do
		seating_area = build_seating_area(input)

		seats_occupied = AOC.time(&ultimate_occupied_seats/1, [seating_area])
		IO.puts "Final seats occupied: #{seats_occupied}"

		seats_occupied2 = AOC.time(&ultimate_occupied_seats_p2/1, [seating_area])
		IO.puts "Revised final seats occupied: #{seats_occupied2}"
	end

	def ultimate_occupied_seats(seating_area) do
		updated_seating = run_cycle(seating_area)
		if seating_area == updated_seating do
			count_seats(updated_seating)["#"]
		else
			ultimate_occupied_seats(updated_seating)
		end
	end

	def ultimate_occupied_seats_p2(seating_area) do
		updated_seating = run_cycle_p2(seating_area)
		if seating_area == updated_seating do
			count_seats(updated_seating)["#"]
		else
			ultimate_occupied_seats_p2(updated_seating)
		end
	end

	def run_cycle(seating_area) do
		Enum.reduce(seating_area, %{}, fn ({row_num, row}, acc) ->
			Map.put(acc, row_num, Enum.map(row, fn {col_num, _state} = point ->
				occupied = adjacent_occupied(seating_area, col_num, row_num)
				case point do
					{col_num, "L"} when occupied == 0 -> {col_num, "#"}
					{col_num, "#"} when occupied >= 4 -> {col_num, "L"}
					{col_num, state} -> {col_num, state}
				end
			end) |> Enum.into(%{}))
		end)
	end

	def run_cycle_p2(seating_area) do
		Enum.reduce(seating_area, %{}, fn ({row_num, row}, acc) ->
			Map.put(acc, row_num, Enum.map(row, fn {col_num, _state} = point ->
				occupied = visible_occupied(seating_area, col_num, row_num)
				case point do
					{col_num, "L"} when occupied == 0 -> {col_num, "#"}
					{col_num, "#"} when occupied >= 5 -> {col_num, "L"}
					{col_num, state} -> {col_num, state}
				end
			end) |> Enum.into(%{}))
		end)
	end

	defp adjacent_occupied(seating_area, x, y) do
		for offset_x <- -1..1, offset_y <- -1..1, offset_x != 0 or offset_y != 0 do
			seating_area[y - offset_y][x - offset_x]
		end |> Enum.count(&(&1 == "#"))
	end

	defp visible_occupied(seating_area, x, y) do
		for offset_x <- -1..1, offset_y <- -1..1, offset_x != 0 or offset_y != 0 do
			find_seat_in_dir(seating_area, x, y, offset_x, offset_y)
		end |> Enum.count(&(&1 == "#"))
	end

	defp find_seat_in_dir(seating_area, x, y, offset_x, offset_y) do
		case seating_area[y - offset_y][x - offset_x] do
			"." -> find_seat_in_dir(seating_area, x, y, increment_offset(offset_x), increment_offset(offset_y))
			state -> state
		end
	end

	defp increment_offset(0), do: 0
	defp increment_offset(offset) when offset < 0, do: offset - 1
	defp increment_offset(offset) when offset > 0, do: offset + 1

	defp count_seats(seating_area) do
		Enum.flat_map(seating_area, fn
			{_row_num, row} -> Enum.map(row, fn {_col_num, state} -> state end)
		end) |> Enum.frequencies()
	end

	defp build_seating_area(input) do
		for {row, index} <- String.split(input, "\n") |> Enum.with_index(), into: %{} do
			points = String.split(row, "", trim: true)
			{index, Stream.iterate(0, &(&1+1)) |> Stream.zip(points) |> Enum.into(%{})}
		end
	end
end
