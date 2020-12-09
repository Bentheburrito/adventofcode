defmodule AOC.Day9 do
	def run(input) do
		xmas_data = input |> String.split("\n") |> Enum.map(&String.to_integer/1)

		weakness = AOC.time(&find_weakness/1, [xmas_data])
		IO.puts "Weakness is #{weakness}"

		exploit = AOC.time(&exploit_weakness/2, [xmas_data, weakness])
		IO.puts "The exploit is #{exploit}"
	end

	def find_weakness([]), do: nil
	def find_weakness(xmas_data) do
		[sum | sum_pool] = Enum.take(xmas_data, 26) |> Enum.reverse()
		if Enum.any?(sum_pool, &(sum - &1 in sum_pool)), do: find_weakness(tl(xmas_data)), else: sum
	end

	def exploit_weakness(xmas_data, weakness, acc \\ nil)
	def exploit_weakness(_xmas_data, weakness, {sum, list}) when sum == weakness do
		{min, max} = Enum.min_max(list)
		min + max
	end
	def exploit_weakness(xmas_data, weakness, _acc) do
		acc = Enum.reduce_while(xmas_data, {0, []}, fn
			(number, {sum, list}) when number + sum <= weakness -> {:cont, {number + sum, [number | list]}}
			(_number, acc) -> {:halt, acc}
		end)
		exploit_weakness(tl(xmas_data), weakness, acc)
	end
end
