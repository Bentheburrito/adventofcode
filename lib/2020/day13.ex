defmodule AOC.Day13 do
	def run(input) do
		[earliest_departure, buses] = String.split(input, "\n")
		bus_ids = buses |> String.split(",") |> Enum.filter(&(&1 != "x")) |> Enum.map(&String.to_integer/1)
		bus_schedule = buses |> String.split(",") |> Enum.with_index() |> Enum.filter(fn {bus, _index} -> bus != "x" end) |> Enum.map(fn {bus, index} -> {String.to_integer(bus), index} end)

		result = AOC.time(&solve1/2, [String.to_integer(earliest_departure), bus_ids])
		IO.puts "bus id * minutes to wait: #{result}"

		result2 = AOC.time(&solve2/1, [bus_schedule])
		IO.puts "earliest timestamp: #{result2}"
	end

	def solve1(earliest_departure, bus_ids) do
		bus = Enum.min_by(bus_ids, &(:math.ceil(earliest_departure / &1) * &1))
		(:math.ceil(earliest_departure / bus) * bus - earliest_departure) * bus
	end
#{List.delete(bus_schedule, {max_bus_id, max_bus_index}), max_bus_id - max_bus_index}
	def solve2(bus_schedule) do
		# {max_bus_id, max_bus_index} = Enum.max_by(bus_schedule, fn {bus, _index} -> bus end)
		Enum.reduce(bus_schedule, {1, 1},
			fn ({id, index}, {time, period}) ->
				# IO.puts "id: #{id}, index: #{index}, period: #{period}, time: #{time}"
				period_iterator = Stream.iterate(time, &(&1 + period))
				t = Enum.find(period_iterator, fn potential_t ->
					rem(potential_t + index, id) == 0
				end)
				{t, period * id}
			end
		) |> elem(0)
		# potential_solutions = Stream.iterate(max_bus_id - max_bus_index, &(&1 + max_bus_id))
		# Enum.find(potential_solutions, :none, fn t ->
		# 	Enum.all?(bus_schedule, fn {id, index} ->
		# 		rem(t + index, id) == 0
		# 	end)
		# end)
	end
end
