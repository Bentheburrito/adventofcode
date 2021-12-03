defmodule AOC.Y2021.Day1 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day1.txt"
  end

  def parse_input(input) do
    input |> String.trim() |> String.split("\n") |> Enum.map(&String.to_integer/1)
  end

  def star_1(nums) do
    Enum.reduce(nums, {:none, 0}, fn num, {prev, num_increases} ->
      case num > prev do
        true -> {num, num_increases + 1}
        false -> {num, num_increases}
      end
    end)
    |> elem(1)
	end

  def star_2(nums) when nums != [] do
    sum = nums |> Enum.take(2) |> Enum.sum()
    star_2(tl(nums), {sum, 0})
  end

  def star_2([_one, _two], {_prev_sum, num_inc}) do
    num_inc
  end

  def star_2(nums, {prev_sum, num_inc}) do
    sum = nums |> Enum.take(3) |> Enum.sum()
    if sum > prev_sum do
      star_2(tl(nums), {sum, num_inc + 1})
    else
      star_2(tl(nums), {sum, num_inc})
    end
  end
end
