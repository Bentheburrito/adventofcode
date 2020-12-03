defmodule AOC.Day2 do
	def run(input) do
		entries = input |> String.split("\n")

		count = AOC.time(&get_valid_count/1, [entries])
		IO.puts("There are #{count} vaild passwords")
		new_count = AOC.time(&get_valid_count_v2/1, [entries])
		IO.puts("There are #{new_count} v2 vaild passwords")
	end

	def get_valid_count(entries) do
		Enum.filter(entries, fn str_entry ->
			[min, max, <<codepoint>> <> ":", password] = String.split(str_entry, ["-", " "])
			(String.to_charlist(password) |> Enum.reduce(0, &(&1 == codepoint && &2 + 1 || &2))) in String.to_integer(min)..String.to_integer(max)
		end) |> Enum.count()
	end

	def get_valid_count_v2(entries) do
		Enum.filter(entries, fn str_entry ->
			[pos1, pos2, <<codepoint>> <> ":", password] = String.split(str_entry, ["-", " "])
			a = String.at(password, String.to_integer(pos1) - 1)
			b = String.at(password, String.to_integer(pos2) - 1)
			(a == <<codepoint>> and b != <<codepoint>>) or (a != <<codepoint>> and b == <<codepoint>>)
		end) |> Enum.count()
	end
end
