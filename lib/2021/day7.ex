defmodule AOC.Y2021.Day7 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day7.txt"
  end

  def parse_input(input) do
    input
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def star_1(positions) do
    Enum.map(0..(length(positions) - 1), fn target_pos ->
      Enum.reduce(positions, 0, &abs(&1 - target_pos) + &2)
    end)
    |> Enum.min()
	end

  def star_2(positions) do
    Enum.map(0..(length(positions) - 1), fn target_pos ->
      Enum.reduce(positions, 0, fn pos, acc ->
        diff = abs(pos - target_pos)
        div(diff * (diff + 1), 2) + acc
      end)
    end)
    |> Enum.min()
  end
end
