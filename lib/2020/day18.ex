defmodule AOC.Day18 do
	def run(input) do
		expressions = String.split(input, "\n")

		sum_of_all = AOC.time(&sum_expression_list/2, [expressions, &eval_expression/1])
		IO.puts "The sum of all expressions is #{sum_of_all}"

		sum_of_all_v2 = AOC.time(&sum_expression_list/2, [expressions, &eval_expression_v2/1])
		IO.puts "The sum of all expressions with priority addition is #{sum_of_all_v2}"
	end

	def sum_expression_list(exp_list, fun) do
		Enum.reduce(exp_list, 0, &(&2 + fun.(&1)))
	end

	def eval_expression_v2(exp) when is_binary(exp) do
		exp
		|> parse()
		|> eval_addition()
	end

	def eval_expression(result, []), do: result
	def eval_expression(result, [op, second | rest]) do
		case {op, second} do
			{"+", second} when is_integer(second) -> result + second
			{"+", second} when is_list(second) -> result + eval_expression(second)
			{"*", second} when is_integer(second) -> result * second
			{"*", second} when is_list(second) -> result * eval_expression(second)
		end
		|> eval_expression(rest)
	end
	def eval_expression([first | rest]) when is_list(first), do: eval_expression(0, ["+", first | rest])
	def eval_expression([first | rest]), do: eval_expression(first, rest)
	def eval_expression(exp) when is_binary(exp) do
		parsed_exp = parse(exp)
		eval_expression(parsed_exp)
	end
	def eval_expression(num_or_op) when is_integer(num_or_op) or num_or_op == "*", do: num_or_op

	def eval_addition(num_or_op) when is_integer(num_or_op) or num_or_op == "*", do: num_or_op
	def eval_addition(exp) do
		exp
		|> Enum.with_index()
		|> Enum.reduce({[], nil}, fn
			_part, {acc, :skip} -> {acc, nil}
			{"+", index}, {[a | acc], _} ->	{[a + eval_addition(Enum.at(exp, index + 1)) | acc], :skip}
			{part, _i}, {acc, _} -> {[eval_addition(part) | acc], nil}
		end)
		|> elem(0)
		|> eval_expression()
		# |> Enum.reverse()
	end

	# End
	defp parse(part, [], acc), do: if String.ends_with?(part, ")"), do: {[Integer.parse(part) |> elem(0) | acc] |> Enum.reverse(), []}, else: [String.to_integer(part) | acc] |> Enum.reverse()
	# Body
	defp parse(part, [next | rest], acc) when part in ["+", "*"], do: parse(next, rest, [part | acc])
	defp parse("(" <> part, rest, acc) do
		case parse(part, rest, []) do
			{parsed_parens, []} -> Enum.reverse([parsed_parens | acc])
			{parsed_parens, [new_part | new_rest]} -> parse(new_part, new_rest, [parsed_parens | acc])
			res when is_list(res) -> Enum.reverse([res | acc])
		end
	end
	defp parse(part, [next | rest], acc) do
		case Integer.parse(part) do
			{num, "))"} -> {Enum.reverse([num | acc]), ["+", "0)", next | rest]}
			{num, ")"} -> {Enum.reverse([num | acc]), [next | rest]}
			{num, _} -> parse(next, rest, [num | acc])
		end
	end
	# Entry
	defp parse(exp) when is_binary(exp) do
		[first | rest] = String.split(exp, " ")
		parse(first, rest, [])
	end
end
