defmodule AOC.Day14 do
	require Integer, [:is_odd]

	def run(input) do
		instructions = input |> String.split("\n") |> Enum.map(fn
			"mask = " <> bitmask ->
				{:mask, bitmask}
			"mem[" <> rest ->
				{:mem, rest |> String.split("] = ") |> Enum.map(fn part ->
					binary = part |> String.to_integer() |> Integer.to_string(2)
					String.pad_leading(binary, 36, "0")
				end)}
		end)

		sum = AOC.time(&sum_mem_values/1, [instructions])
		IO.puts "The sum is: #{sum}"

		sum_v2 = AOC.time(&sum_mem_values_v2/1, [instructions])
		IO.puts "The sum with the V2 decoder is: #{sum_v2}"
	end

	def sum_mem_values([], mem, _bitmask), do: Enum.reduce(mem, 0, fn {_address, value}, acc -> value + acc end)
	def sum_mem_values([{:mem, [address, value]} | instructions], mem, bitmask) do
		masked_value = mask(value, bitmask) |> String.to_integer(2)
		sum_mem_values(instructions, Map.put(mem, address, masked_value), bitmask)
	end
	def sum_mem_values([{:mask, new_bitmask} | instructions], mem, _bitmask) do
		sum_mem_values(instructions, mem, new_bitmask)
	end
	def sum_mem_values(instructions), do: sum_mem_values(instructions, %{}, nil)

	def mask("", "", acc), do: acc
	def mask(<<val::binary-size(1), rest_val::binary()>>, "X" <> bitmask, acc), do: mask(rest_val, bitmask, acc <> val)
	def mask(<<_val::binary-size(1), rest_val::binary()>>, <<bit::binary-size(1), bitmask::binary()>>, acc), do: mask(rest_val, bitmask, acc <> bit)
	def mask(value, bitmask), do: mask(value, bitmask, <<>>)

	# v2
	def sum_mem_values_v2([], mem, _bitmask), do: Enum.reduce(mem, 0, fn {_address, value}, acc -> value + acc end)
	def sum_mem_values_v2([{:mem, [address, value]} | instructions], mem, bitmask) do
		addresses = mask_v2(address, bitmask)
		updated_mem = Enum.reduce(addresses, mem, &(Map.put(&2, &1, String.to_integer(value, 2))))
		sum_mem_values_v2(instructions, updated_mem, bitmask)
	end
	def sum_mem_values_v2([{:mask, new_bitmask} | instructions], mem, _bitmask) do
		sum_mem_values_v2(instructions, mem, new_bitmask)
	end
	def sum_mem_values_v2(instructions), do: sum_mem_values_v2(instructions, %{}, nil)

	def mask_v2("", "", addresses), do: addresses
	def mask_v2(<<_val::binary-size(1), rest_val::binary()>>, "X" <> bitmask, addresses) do
		{new_addresses, _} = Enum.concat(addresses, addresses) |> Enum.sort |> Enum.map_reduce(0, fn (address, acc) -> {address <> (Integer.is_odd(acc) && "0" || "1"), acc + 1} end)
		mask_v2(rest_val, bitmask, new_addresses)
	end
	def mask_v2(<<_val::binary-size(1), rest_val::binary()>>, "1" <> bitmask, addresses), do: mask_v2(rest_val, bitmask, Enum.map(addresses, & &1 <> "1"))
	def mask_v2(<<val::binary-size(1), rest_val::binary()>>, "0" <> bitmask, addresses), do: mask_v2(rest_val, bitmask, Enum.map(addresses, & &1 <> val))
	def mask_v2(value, bitmask), do: mask_v2(value, bitmask, [<<>>])
end
