defmodule AOC.Y2021.Day3 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day3.txt"
  end

  def parse_input(input) do
    input |> String.split(["\n"], trim: true)
  end

  def star_1(report_lines) do
    bit_columns =
      report_lines
      |> Enum.reduce(%{}, fn line, col_map ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(col_map, fn {bit, index}, column_map ->
          Map.update(column_map, index, [bit], & [bit | &1])
        end)
      end)
      |> then(fn column_map ->
        (0..map_size(column_map) - 1)
        |> Enum.map(&Map.get(column_map, &1))
      end)
    bit_frequencies =
      bit_columns
      |> Enum.map(&Enum.frequencies(&1))
    {gamma_rate, epsilon_rate} =
      bit_frequencies
      |> Enum.reduce({"", ""}, fn frequencies, {gamma_rate, epsilon_rate} ->
        if Map.get(frequencies, "1") > Map.get(frequencies, "0") do
          {gamma_rate <> "1", epsilon_rate <> "0"}
        else
          {gamma_rate <> "0", epsilon_rate <> "1"}
        end
      end)
      |> then(& {Integer.parse(elem(&1, 0), 2) |> elem(0), Integer.parse(elem(&1, 1), 2) |> elem(0)})
    gamma_rate * epsilon_rate
	end

  def star_2(report_lines) do
    o2_rating = find_rating_num(report_lines, &oxygen_critera_fun/3)
    co2_rating = find_rating_num(report_lines, &co2_critera_fun/3)
    o2_rating * co2_rating
  end

  defp oxygen_critera_fun(num, col_num, frequencies) do
    bit = String.at(num, col_num)
    opposite_bit = bit == "1" && "0" || "1"
    if frequencies["1"] == frequencies["0"] do
      bit == "1"
    else
      frequencies[bit] > frequencies[opposite_bit]
    end
  end

  defp co2_critera_fun(num, col_num, frequencies) do
    bit = String.at(num, col_num)
    opposite_bit = bit == "1" && "0" || "1"
    if frequencies["1"] == frequencies["0"] do
      bit == "0"
    else
      frequencies[bit] < frequencies[opposite_bit]
    end
  end

  defp find_rating_num([line | _rest] = report_lines, critera_fun) do
    0..(String.length(line))
    |> IO.inspect()
    |> Enum.reduce_while(report_lines, fn
      _col_num, [num] ->
        {rating, _} = Integer.parse(num, 2)
        {:halt, rating}
      col_num, nums ->
        frequencies =
          nums
          |> Enum.map(&String.at(&1, col_num))
          |> Enum.frequencies()

        {:cont, Enum.filter(nums, &critera_fun.(&1, col_num, frequencies))}
    end)
  end
end
