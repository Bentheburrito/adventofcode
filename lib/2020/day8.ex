defmodule AOC.Day8 do
	def run(input) do
		program = input |> String.split("\n") |> Enum.map(&({String.slice(&1, 0..2), String.slice(&1, 4..10) |> String.to_integer(), false}))

		{:loop_hit, acc} = AOC.time(&run_till_loop/1, [program])
		IO.puts "The value of acc before the loop is: #{acc}"

		{:ok, acc_repaired} = AOC.time(&repair_program/1, [program])
		IO.puts "The value of acc after fixing the program is: #{acc_repaired}"
	end
	def run_till_loop(program, track \\ [], acc \\ 0)
	def run_till_loop([], _track, acc), do: {:normal_term, acc}
	def run_till_loop([{_op, _arg, true} | _rest], _track, acc), do: {:loop_hit, acc}
	def run_till_loop([{"acc", arg, false} = instruction | rest], track, acc) do
		run_till_loop(rest, [mark_as_read(instruction) | track], acc + arg)
	end
	def run_till_loop([{"jmp", offset, false} = instruction | rest], track, acc) when offset < 0 do
		{restored_track, new_track} = Enum.split(track, -offset)
		run_till_loop(restored_track |> Enum.reverse([mark_as_read(instruction) | rest]), new_track, acc)
	end
	def run_till_loop([{"jmp", offset, false} = instruction | rest], track, acc) when offset > 0 do
		{track_addition, new_rest} = Enum.split(rest, offset - 1)
		run_till_loop(new_rest, track_addition |> Enum.reverse([mark_as_read(instruction) | track]), acc)
	end
	def run_till_loop([{"nop", _, _} = instruction | rest], track, acc) do
		run_till_loop(rest, [mark_as_read(instruction) | track], acc)
	end

	def repair_program(program) do
		Enum.reduce_while(program, 0, fn
			({"acc", _, _}, index) -> {:cont, index + 1}
			(instruction, index) ->
				case run_till_loop(List.replace_at(program, index, flip_instruction(instruction))) do
					{:loop_hit, _acc} -> {:cont, index + 1}
					{:normal_term, acc} -> {:halt, {:ok, acc}}
				end
		end)
	end

	defp mark_as_read({op, arg, false} = _instruction), do: {op, arg, true}

	defp flip_instruction({"jmp", arg, false}), do: {"nop", arg, false}
	defp flip_instruction({"nop", arg, false}), do: {"jmp", arg, false}
end
