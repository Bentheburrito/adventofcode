defmodule AOC.Day1 do
	def run(input) do
		numbers = input |> String.split("\n") |> Enum.map(&String.to_integer/1)

		{entry1, entry2} = AOC.time(&find_two_entries/2, [numbers, 2020])
		IO.puts "Found! #{entry1} * #{entry2} = #{entry1 * entry2}"
		{entry1, entry2, entry3} = AOC.time(&find_three_entries/1, [numbers])
		IO.puts "Found! #{entry1} * #{entry2} * #{entry3} = #{entry1 * entry2 * entry3}"
	end

	def find_two_entries([entry | tail], sum) do
		case Enum.find(tail, &(entry + &1 == sum)) do
			other_entry when not is_nil(other_entry) -> {entry, other_entry}
			_ -> find_two_entries(tail, sum)
		end
	end
	def find_two_entries([], _sum), do: nil

	def find_three_entries([entry1 | tail]) do
		case find_two_entries(tail, 2020 - entry1) do
			{entry2, entry3} -> {entry1, entry2, entry3}
			_ -> find_three_entries(tail)
		end
	end
end
