defmodule AOC.Day5 do
	def run(input) do
		boarding_passes = String.split(input, "\n")

		max = AOC.time(&max_seat_id/1, [boarding_passes])
		IO.puts "Max seat ID is #{max}"
		my_seat_id = AOC.time(&find_my_seat/1, [boarding_passes])
		IO.puts "My seat ID is #{my_seat_id}"
	end

	def max_seat_id(boarding_passes) do
		Enum.max_by(boarding_passes, &get_seat_id/1) |> get_seat_id()
	end

	def find_my_seat(boarding_passes) do
		Enum.sort(boarding_passes) |> Enum.reduce_while(nil, fn (pass, prev_seat_id) ->
			case get_seat_id(pass) do
				id when id - 2 == prev_seat_id -> {:halt, id - 1}
				id -> {:cont, id}
			end
		end)
	end

	defp get_seat_id(<<front_backs::binary-size(7)>> <> <<left_rights::binary-size(3)>>) do
		eval_bsp(front_backs) * 8 + eval_bsp(left_rights)
	end

	defp eval_bsp(front_backs), do: eval_bsp(front_backs, 0..(:math.pow(2, byte_size(front_backs)) |> round) - 1)
	defp eval_bsp(char, lower.._upper) when char in ["F", "L"], do: lower
	defp eval_bsp(char, _lower..upper) when char in ["B", "R"], do: upper
	defp eval_bsp(<<char::binary-size(1)>> <> rest, lower..upper) when char in ["F", "L"], do: eval_bsp(rest, lower..div(lower + upper, 2))
	defp eval_bsp(<<char::binary-size(1)>> <> rest, lower..upper) when char in ["B", "R"], do: eval_bsp(rest, ceil((lower + upper) / 2)..upper)
end
