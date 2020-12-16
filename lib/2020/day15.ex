defmodule AOC.Day15 do
	def run(input) do
		starting_nums = String.split(input, ",") |> Enum.map(&String.to_integer/1)

		num = AOC.time(&find_nth/2, [starting_nums, 2020])
		IO.puts "The 2020th number is #{num}"

		num2 = AOC.time(&find_nth/2, [starting_nums, 30000000])
		IO.puts "The 30,000,000th number is #{num2}"
	end

	# {turn, prev_turn}
	def find_nth(_starting_nums, prev_num, turn, _history, n) when turn - 1 == n, do: prev_num
	def find_nth([], prev_num, turn, history, n) when is_map_key(history, prev_num) do
		num = turn - 1 - Map.get(history, prev_num)
		find_nth([], num, turn + 1, Map.put(history, prev_num, turn - 1), n)
	end
	def find_nth([], prev_num, turn, history, n) do
		find_nth([], 0, turn + 1, Map.put(history, prev_num, turn - 1), n)
	end
	def find_nth([num | starting_nums], prev_num, turn, history, n) do
		find_nth(starting_nums, num, turn + 1, Map.put(history, prev_num, turn - 1), n)
	end
	def find_nth([num | starting_nums], n), do: find_nth(starting_nums, num, 2, %{}, n)
end
