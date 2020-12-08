defmodule AOC.Day6 do
	def run(input) do
		groups = input |> String.split("\n\n")

		count = AOC.time(&sum_of_counts/1, [groups])
		IO.puts "Sum of questions answered 'yes': #{count}"

		count_corrected = AOC.time(&sum_of_counts_corrected/1, [groups])
		IO.puts "Corrected sum of questions answered 'yes': #{count_corrected}"
		end

	def sum_of_counts(groups) do
		Enum.reduce(groups, 0, fn (group, count) ->
			(group_answers(group) |> MapSet.size()) + count
		end)
	end

	def sum_of_counts_corrected(groups) do
		Enum.reduce(groups, 0, fn (group, count) ->
			(group_answers_corrected(group) |> MapSet.size()) + count
		end)
	end

	def group_answers(group) do
		String.split(group) |> Enum.reduce(%MapSet{}, fn (member_answers, mapset) ->
			MapSet.union(mapset, member_answers |> String.graphemes() |> MapSet.new())
		end)
	end

	def group_answers_corrected(group) do
		[first | rest] = String.split(group)
		Enum.reduce(rest, first |> String.graphemes() |> MapSet.new(), fn (member_answers, mapset) ->
			MapSet.intersection(mapset, member_answers |> String.graphemes() |> MapSet.new())
		end)
	end
end
