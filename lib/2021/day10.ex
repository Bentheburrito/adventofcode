defmodule AOC.Y2021.Day10 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day10.txt"
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist(&1))
  end

  @point_map %{
    ?) => 3,
    ?] => 57,
    ?} => 1197,
    ?> => 25137
  }

  def star_1(lines) do
    find_illegal_closing_in_corrupted(lines)
    |> Stream.map(&Map.get(@point_map, &1))
    |> Enum.sum()
	end

  defp find_illegal_closing_in_corrupted([], illegal_chars), do: illegal_chars
  defp find_illegal_closing_in_corrupted([line | rest], illegal_chars) do
    case parse(line) do
      {:corrupted, char} -> find_illegal_closing_in_corrupted(rest, [char | illegal_chars])
      {:incomplete, _compl_char} -> find_illegal_closing_in_corrupted(rest, illegal_chars)
      :ok -> find_illegal_closing_in_corrupted(rest, illegal_chars)
    end
  end
  defp find_illegal_closing_in_corrupted(lines), do: find_illegal_closing_in_corrupted(lines, [])

  defguardp is_matching_chunk(open, close) when open < close and open + 2 >= close

  @chunk_starters [?(, ?[, ?{, ?<]

  defp parse([], stack) when length(stack) > 0, do: {:incomplete, Enum.map(stack, &get_closing/1)}
  defp parse([], _stack), do: :ok
  defp parse([open | rest], stack) when open in @chunk_starters, do: parse(rest, [open | stack])
  defp parse([close | rest], [open | stack]) when is_matching_chunk(open, close), do: parse(rest, stack)
  defp parse([unmatching_close | _rest], _stack), do: {:corrupted, unmatching_close}
  defp parse(line), do: parse(line, [])

  defp get_closing(?(), do: ?)
  defp get_closing(open) when open in @chunk_starters, do: open + 2

  @point_map %{
    ?) => 1,
    ?] => 2,
    ?} => 3,
    ?> => 4
  }

  def star_2(lines) do
    find_closing_for_incomplete(lines)
    |> Stream.map(fn completion_char ->
      completion_char
      |> Enum.reduce(0, & (&2 * 5) + Map.get(@point_map, &1))
    end)
    |> Enum.sort()
    |> then(fn scores ->
      mid =
        scores
        |> length()
        |> div(2)

      Enum.at(scores, mid)
    end)
  end

  defp find_closing_for_incomplete([], completion_chars), do: completion_chars
  defp find_closing_for_incomplete([line | rest], completion_chars) do
    case parse(line) do
      {:incomplete, compl_char} -> find_closing_for_incomplete(rest, [compl_char | completion_chars])
      {:corrupted, _char} -> find_closing_for_incomplete(rest, completion_chars)
      :ok -> find_closing_for_incomplete(rest, completion_chars)
    end
  end
  defp find_closing_for_incomplete(lines), do: find_closing_for_incomplete(lines, [])
end
