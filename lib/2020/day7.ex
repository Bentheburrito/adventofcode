defmodule AOC.Day7 do
	def run(input) do
		rules = String.split(input, [" bags contain ", "\n"]) |> build_rules()

		num = AOC.time(&num_bags_containing/2, [rules, "shiny gold"])
		IO.puts "Num of bags containing shiny gold: #{num}"

		num2 = AOC.time(&num_bags_inside/2, [rules, "shiny gold"])
		IO.puts "Num of bags inside shiny gold: #{num2}"
	end

	# need increment counter for each level gone down
	def num_bags_containing(rules, bag_color) do
		{_sub_list, new_rules} = Map.pop!(rules, bag_color)
		do_num_bags_containing(new_rules, bag_color)
	end

	def do_num_bags_containing(rules, bag_color) do
		Enum.reduce(rules, %{}, fn ({bag, sub_bags}, remapped_rules) -> remap_by_color(bag, sub_bags, bag_color, rules, remapped_rules) |> elem(1) end)
		|> Map.values() |> Enum.sum()
	end

	def remap_by_color(bag, [], _bag_color, _rules, remapped_rules), do: {0, Map.put(remapped_rules, bag, 0)}
	def remap_by_color(bag, _sub_bags, _bag_color, _rules, remapped_rules) when is_map_key(remapped_rules, bag), do: {Map.get(remapped_rules, bag), remapped_rules}
	def remap_by_color(bag, sub_bags, bag_color, rules, remapped_rules) do
		if Enum.any?(sub_bags, &match?({_, ^bag_color}, &1)) do # check remapped_rules for a true value too?
			{1, Map.put(remapped_rules, bag, 1)}
		else
			{nested_contains, nested_remapped_rules} = Enum.map_reduce(sub_bags, remapped_rules, fn ({_amount, next_bag}, acc) ->
				next_sub_bags = Map.get(rules, next_bag)
				remap_by_color(next_bag, next_sub_bags, bag_color, rules, acc)
			end)
			contains = Enum.any?(nested_contains, &(&1 == 1)) && 1 || 0
			{contains, Map.put(nested_remapped_rules, bag, contains)}
		end
	end

	def num_bags_inside(_rules, []), do: 0
	def num_bags_inside(rules, target_bag) when not is_list(target_bag), do: num_bags_inside(rules, Map.get(rules, target_bag))
	def num_bags_inside(rules, target_sub_bags) do
		Enum.reduce(target_sub_bags, 0, fn ({amount, sub_bag}, count) -> amount + (num_bags_inside(rules, sub_bag) * amount) + count end)
	end

	def build_rules([], acc), do: acc
	def build_rules([bag, contents | rem_rules], acc) do
		sub_bags = for <<num::binary-size(1)>> <> " " <> sub_bag <- String.split(contents, [" bags, ", " bag, ", " bags.", " bag."], trim: true) do
			{String.to_integer(num), sub_bag}
		end
		build_rules(rem_rules, Map.put(acc, bag, sub_bags))
	end
	def build_rules(rule_list), do: build_rules(rule_list, %{})
end
