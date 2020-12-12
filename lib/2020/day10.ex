defmodule AOC.Day10 do
	def run(input) do
		adapters = input |> String.split("\n") |> Enum.map(&String.to_integer/1) |> Enum.sort()

		number = AOC.time(&solve_p1/1, [adapters])
		IO.puts "The number is #{number}"

		total_arrangements = AOC.time(&arrangements/1, [adapters])
		IO.puts "The total number of possible arrangements is #{total_arrangements}"
	end

	def solve_p1(adapters) do
		differences = differences(adapters)
		diff_count = Enum.frequencies(differences)
		Map.get(diff_count, 3) * Map.get(diff_count, 1)
	end

	def arrangements(adapters) do
		num_adapters = length(adapters)
		List.insert_at(adapters, num_adapters, Enum.at(adapters, num_adapters - 1) + 3)
		|> Enum.reduce({0, 1, 1}, fn adapter, {last_adapter, num_consecutives, product} ->
			adapter - 1 == last_adapter && {adapter, num_consecutives + 1, product} || {adapter, 1, product * possible_arrangements(num_consecutives)}
		end)
		|> elem(2)
	end

	defp differences(adapters), do: differences([0 | adapters], [3])
	defp differences([_last_elem], acc), do: acc
	defp differences([subtrahend, minuend | rest], acc) do
		differences([minuend | rest], [minuend - subtrahend | acc])
	end

	def possible_arrangements(1), do: 1
	def possible_arrangements(num_adapters) when num_adapters <= 3, do: num_adapters - 1
	def possible_arrangements(num_adapters), do: round(:math.pow(2, (num_adapters - 2))) - (num_adapters - 4)
end
