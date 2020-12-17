defmodule AOC.Day16 do

	def run(input) do
		[string_fields, string_ticket, string_nearby_tickets] = String.split(input, "\n\n")

		err_rate = AOC.time(&scanning_error_rate/2, [string_fields, string_nearby_tickets])
		IO.puts "Scanning error rate: #{err_rate}"

		product = AOC.time(&departure_product/3, [string_fields, string_ticket, string_nearby_tickets])
		IO.puts "product of departure field values: #{product}"
	end

	def scanning_error_rate(string_fields, string_nearby_tickets) do
		all_field_values = parse_field_values(string_fields)
		nearby_ticket_values = string_nearby_tickets |> String.split([",", "\n"]) |> tl() |> Enum.map(&String.to_integer/1)

		Enum.filter(nearby_ticket_values, &(&1 not in all_field_values))
		|> Enum.sum()
	end

	def departure_product(string_fields, string_ticket, string_nearby_tickets) do
		parsed_fields = for f <- String.split(string_fields, "\n") do
			[f_name, lower1, upper1, lower2, upper2] = String.split(f, [": ", " or ", "-"])
			{f_name, {String.to_integer(lower1)..String.to_integer(upper1), String.to_integer(lower2)..String.to_integer(upper2)}}
		end
		my_ticket_values = string_ticket |> String.split(["\n", ","]) |> tl() |> Enum.map(&String.to_integer/1)

		valid_nearby_ticket_values = discard_invalid_tickets(string_nearby_tickets, string_fields, length(parsed_fields))
		nearby_ticket_columns = ticket_rows_to_columns(valid_nearby_ticket_values)

		mapped_ticket = map_ticket(parsed_fields, nearby_ticket_columns, my_ticket_values)

		IO.inspect(mapped_ticket, label: "mapped ticket")

		Enum.reduce(mapped_ticket, 1, fn {f_name, val}, product -> String.starts_with?(f_name, "departure") && val * product || product end)
	end

	def map_ticket(_parsed_fields, [], _my_ticket_values, mapped_ticket), do: mapped_ticket
	def map_ticket(parsed_fields, ticket_columns, my_ticket_values, mapped_ticket) do
		{new_mapped_ticket, remaining_ticket_columns} = Enum.reduce(parsed_fields, {mapped_ticket, ticket_columns}, fn {f_name, {allowed_range1, allowed_range2}}, {acc, remaining_columns} ->
			matches = Enum.filter(remaining_columns, fn
				nil -> false
				{column, _i} ->
					# IO.inspect(column, label: "column")
					Enum.all?(column, &(&1 in allowed_range1 or &1 in allowed_range2))
			end)
			case length(matches) do
				1 ->
					index = List.first(matches) |> elem(1)
					{Map.put(acc, f_name, Enum.at(my_ticket_values, index)), List.replace_at(remaining_columns, index, nil)}
				_ ->
					{acc, remaining_columns}
			end
		end)
		map_ticket(parsed_fields, Enum.all?(remaining_ticket_columns, & &1 == nil) && [] || remaining_ticket_columns, my_ticket_values, new_mapped_ticket)
	end
	def map_ticket(parsed_fields, ticket_columns, my_ticket_values), do: map_ticket(parsed_fields, Enum.with_index(ticket_columns), my_ticket_values, %{})

	def discard_invalid_tickets(tickets, fields, length) do
		field_values = parse_field_values(fields)
		String.split(tickets, ["\n", ","])
		|> tl()
		|> Enum.map(&String.to_integer/1)
		|> Enum.chunk_every(length)
		|> Enum.filter(fn ticket_values -> Enum.all?(ticket_values, &(&1 in field_values)) end)
	end

	defp ticket_rows_to_columns([], acc), do: Enum.reverse(acc)
	defp ticket_rows_to_columns(nearby_tickets, acc) do
		{field_vals, remaining} = Enum.reduce(nearby_tickets, {[], []},
		fn
			[head | []], {field_vals, remaining} -> {[head | field_vals], remaining}
			[head | tail], {field_vals, remaining} -> {[head | field_vals], [tail | remaining]}
		end)
		ticket_rows_to_columns(remaining, [field_vals | acc])
	end
	defp ticket_rows_to_columns(nearby_tickets), do: ticket_rows_to_columns(nearby_tickets, [])

	defp parse_field_values(fields) do
		fields |> String.split(["\n", ": ", " or "]) |> Enum.flat_map(fn elem ->
			case String.split(elem, "-") do
				[lower, upper] ->
					String.to_integer(lower)..String.to_integer(upper) |> Enum.to_list()
				_ ->
					[]
			end
		end) |> Enum.filter(&(&1 != nil))
	end
end
