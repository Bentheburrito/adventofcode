defmodule AOC.Day19 do
	def run(input) do
		[rules_input | [messages]] = input |> String.split("\n\n") |> Enum.map(&String.split(&1, "\n"))
		rules = build_rules(rules_input)

		num_valid_msgs = AOC.time(&num_match_rule/3, [rules, "0", messages])
		IO.puts "There are #{num_valid_msgs} valid messages."

		updated_rules = Map.merge(rules, %{"+" => "+", "11" => ["42 31", "42 11 31"], "8" => ["42", "42 8"]})

		num_valid_msgs_loops = AOC.time(&num_match_rule/3, [updated_rules, "0", messages])
		IO.puts "There are #{num_valid_msgs_loops} valid messages."
	end

	def num_match_rule(rules, rule, messages) do
		r = expand_rule(rules, rule)
		Enum.filter(messages, &Regex.match?(r, &1))
		|> length()
	end

	def build_rules(rules_input) do
		Enum.reduce(rules_input, %{}, fn
			line, acc ->
				case String.split(line, ": ")do
					[key | [<<34, char::binary-size(1), 34>>]] -> Map.put(acc, key, char)
					[key | [subrules]] -> Map.put(acc, key, String.split(subrules, " | "))
				end
		end)
	end

	def expand_rule(rules, rule) do
		~r/^#{join_parts(rules, Map.get(rules, rule))}$/ |> IO.inspect()
	end

	def join_parts(rules, subrules) when is_list(subrules) do
		"(#{subrules |> Enum.map_join("|", fn r -> r |> String.split(" ") |> Enum.map_join(&join_parts(rules, Map.get(rules, &1))) end)})"
	end
	def join_parts(_rules, char), do: char
end
