defmodule AOC.Y2021.Day18 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day18.txt"
  end

  # sfn = snailfish number
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_pair/1)
  end

  defp parse_pair(pair) do
    {sfn, _} = Code.eval_string(pair)
    sfn
  end

  def star_1(sf_numbers) do
    Enum.reduce(sf_numbers, &add_sf_numbers(&2, &1))
    # |> IO.inspect(charlists: :as_lists)
    |> magnitude()
  end

  defguardp is_splitable(element) when is_integer(element) and element >= 10

  # regular number
  defp reduce_explode(regular_number, _cur_level) when is_integer(regular_number),
    do: {:no_explode, regular_number, 0, 0}

  # explode
  defp reduce_explode([l_regular_number, r_regular_number], cur_level) when cur_level > 4 do
    {:explode, 0, l_regular_number, r_regular_number}
  end

  # catch-all, keep reducing to deeper levels
  defp reduce_explode([left, right], cur_level) do
    with {:left, {:no_explode, left_pair, _, _}} <- {:left, reduce_explode(left, cur_level + 1)},
         {:right, {:no_explode, right_pair, _, _}} <- {:right, reduce_explode(right, cur_level + 1)} do
      {:no_explode, [left_pair, right_pair], 0, 0}
    else
      {:left, {:explode, left_pair, left_carry, right_add}} ->
        right_pair = (is_integer(right) && right + right_add) || add_left(right, right_add)

        {:explode, [left_pair, right_pair], left_carry, 0}

      {:right, {:explode, right_pair, left_add, right_carry}} ->
        left_pair = (is_integer(left) && left + left_add) || add_right(left, left_add)

        {:explode, [left_pair, right_pair], 0, right_carry}
    end
  end

  # split numbers >= 10
  defp reduce_split(splitable) when is_splitable(splitable),
    do: {:split, [div(splitable, 2), ceil(splitable / 2)]}

  # regular number
  defp reduce_split(regular_number) when is_integer(regular_number),
    do: {:no_split, regular_number}

  # catch-all, keep reducing to deeper levels
  defp reduce_split([left, right]) do
    with {:left, {:no_split, left_pair}} <- {:left, reduce_split(left)},
         {:right, {:no_split, right_pair}} <- {:right, reduce_split(right)} do
      {:no_split, [left_pair, right_pair]}
    else
      {:left, {:split, left_pair}} -> {:split, [left_pair, right]}
      {:right, {:split, right_pair}} -> {:split, [left, right_pair]}
    end
  end

  # entry
  def reduce(sfn) do
    with {:no_explode, ^sfn, _, _} <- reduce_explode(sfn, _cur_level = 1),
         {:no_split, ^sfn} <- reduce_split(sfn) do
      sfn
    else
      reduced ->
        reduced = (is_tuple(reduced) && elem(reduced, 1)) || reduced
        # IO.inspect(reduced, label: "one iter", charlists: :as_lists)
        reduce(reduced)
    end
  end

  defp add_left([l, r], to_add) when is_integer(l), do: [l + to_add, r]
  defp add_left([l, r], to_add), do: [add_left(l, to_add), r]

  defp add_right([l, r], to_add) when is_integer(r), do: [l, r + to_add]
  defp add_right([l, r], to_add), do: [l, add_right(r, to_add)]

  def add_sf_numbers(sfn1, sfn2), do: reduce([sfn1, sfn2])

  def magnitude(regular_number) when is_integer(regular_number), do: regular_number
  def magnitude([left, right] = _sfn), do: magnitude(left) * 3 + magnitude(right) * 2

  def star_2(numbers) do
    get_highest_sum_magnitude(numbers)
  end

  defp get_highest_sum_magnitude(_old_number, [], [], max), do: max

  defp get_highest_sum_magnitude(_old_number, [], [number | next_acc], max),
    do: get_highest_sum_magnitude(number, next_acc, next_acc, max)

  defp get_highest_sum_magnitude(number, [other | rest], next_acc, max) do
    magnitude1 =
      number
      |> add_sf_numbers(other)
      |> magnitude()

    magnitude2 =
      other
      |> add_sf_numbers(number)
      |> magnitude()

    max = Enum.max([magnitude1, magnitude2, max])

    get_highest_sum_magnitude(number, rest, next_acc, max)
  end

  defp get_highest_sum_magnitude([first | sf_numbers]),
    do: get_highest_sum_magnitude(first, sf_numbers, sf_numbers, -1)
end
