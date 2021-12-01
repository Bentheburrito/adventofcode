defmodule AOC.Day21 do
	def run(input) do
		foods = parse_input(input)


	end

	def parse_input(input) do
		input
		|> String.split("\n")
		|> Enum.reduce([], fn line, acc ->
			[ingredients, allergens] = String.split(line, " (contains ")
			[{String.split(ingredients, " "), allergens |> String.trim_trailing(")") |> String.split(", ")} | acc]
		end)
	end
end
