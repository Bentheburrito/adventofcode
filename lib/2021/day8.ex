defmodule AOC.Y2021.Day8 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day8.txt"
  end

  def parse_input(input) do
    input
    |> String.split([" | ", "\n"], trim: true)
    |> Stream.chunk_every(2)
    |> Stream.map(fn [segments, output_digits] ->
      {String.split(segments, " ", trim: true),
        String.split(output_digits, " ", trim: true)}
    end)
  end

  @unique_num_segments_lengths [2, 3, 4, 7]

  def star_1(lines) do
    Enum.reduce(lines, 0, fn {_segments, output_digits}, acc ->
      acc + Enum.count(output_digits, & String.length(&1) in @unique_num_segments_lengths)
    end)
	end

  def star_2(lines) do
    Enum.map(lines, fn {segments, output_digits} ->
      signal_mapper = map_digits(segments)
      Enum.map(output_digits, &parse_digit(&1, signal_mapper))
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  # I am not proud of this function.
  defp map_digits(segments) do
    # deduce top segment from 1 and 7 signals
    one_signal = Enum.find(segments, &String.length(&1) == 2)
    seven_signal = Enum.find(segments, &String.length(&1) == 3)
    one_segments = String.split(one_signal, "", trim: true)
    a = String.replace(seven_signal, one_segments, "")

    six_segment_nums = Enum.filter(segments, &String.length(&1) == 6)
    six_signal = Enum.find(six_segment_nums, fn num ->
      not Enum.all?(one_segments, &String.contains?(num, &1))
    end)
    c = Enum.find(one_segments, &not String.contains?(six_signal, &1))
    [f] = List.delete(one_segments, c)

    seven_segments = String.split(seven_signal, "", trim: true)
    five_segment_nums = Enum.filter(segments, &String.length(&1) == 5)
    three_signal =
      Enum.find(five_segment_nums, &Enum.all?(seven_segments, fn seg ->
        String.contains?(&1, seg)
      end)
      )
    four_signal = Enum.find(segments, &String.length(&1) == 4)
    b_and_d = String.replace(four_signal, one_segments, "") |> String.split("", trim: true)
    d = Enum.find(b_and_d, &String.contains?(three_signal, &1))
    [b] = List.delete(b_and_d, d)
    g = String.replace(three_signal, [d | seven_segments], "")

    eight_segment = Enum.find(segments, &String.length(&1) == 7)
    e = String.replace(eight_segment, [a, b, c, d, f, g], "")

    %{a => :a, b => :b, c => :c, d => :d, e => :e, f => :f, g => :g}
  end

  defp parse_digit(segment_str, signal_mapper) when is_binary(segment_str) do
    segment_str
    |> String.split("", trim: true)
    |> Stream.map(&Map.get(signal_mapper, &1))
    |> Enum.sort()
    |> parse_digit()
  end

  defp parse_digit([:a, :b, :c, :e, :f, :g]), do: 0
  defp parse_digit([:c, :f]), do: 1
  defp parse_digit([:a, :c, :d, :e, :g]), do: 2
  defp parse_digit([:a, :c, :d, :f, :g]), do: 3
  defp parse_digit([:b, :c, :d, :f]), do: 4
  defp parse_digit([:a, :b, :d, :f, :g]), do: 5
  defp parse_digit([:a, :b, :d, :e, :f, :g]), do: 6
  defp parse_digit([:a, :c, :f]), do: 7
  defp parse_digit([:a, :b, :c, :d, :e, :f, :g]), do: 8
  defp parse_digit([:a, :b, :c, :d, :f, :g]), do: 9
end
