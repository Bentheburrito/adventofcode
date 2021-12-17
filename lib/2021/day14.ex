defmodule AOC.Y2021.Day14 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day14.txt"
  end

  def parse_input(input) do
    [template, pairs] = String.split(input, "\n\n", trim: true)

    pairs =
      for pair <- String.split(pairs, "\n", trim: true), into: %{} do
        [p, insertion] = String.split(pair, " -> ", trim: true)
        {p, insertion}
      end

    {template, pairs}
  end

  def star_1({template, pairs}) do
    get_polymer_after_steps(template, pairs, 10)
  end

  def star_2({template, pairs}) do
    get_polymer_after_steps(template, pairs, 40)
  end

  defp apply_pairs(template, frequencies, pairs) when is_binary(template) do
    template_map = build_template_map(template)

    apply_pairs(template_map, frequencies, pairs)
  end

  defp apply_pairs(template_map, frequencies, pairs) do
    Enum.reduce(template_map, {%{}, frequencies}, fn
      {<<first::binary-size(1), second::binary-size(1)>> = pair, count}, {map, freqs} ->
        to_insert = Map.fetch!(pairs, pair)

        new_map =
          map
          |> Map.update(first <> to_insert, count, &(&1 + count))
          |> Map.update(to_insert <> second, count, &(&1 + count))

        new_frequencies = Map.update(freqs, to_insert, count, &(&1 + count))

        {new_map, new_frequencies}
    end)
  end

  defp build_template_map(<<first::binary-size(1), second::binary-size(1), rest::binary>>, map) do
    map = Map.update(map, first <> second, 1, &(&1 + 1))
    build_template_map(second <> rest, map)
  end

  defp build_template_map(<<_only_one::binary-size(1)>>, map), do: map
  defp build_template_map(template), do: build_template_map(template, %{})

  defp get_polymer_after_steps(template, pairs, steps) do
    init_freqs =
      template
      |> String.split("", trim: true)
      |> Enum.frequencies()

    {{_min_key, min}, {_max_max, max}} =
      Enum.reduce(1..steps, {template, init_freqs}, fn _i, {template_acc, frequencies} ->
        apply_pairs(template_acc, frequencies, pairs)
      end)
      |> elem(1)
      |> Enum.min_max_by(fn {_key, val} -> val end)

    max - min
  end

  # Initial brute-force impl:
  # defp apply_pairs(<<first::binary-size(1), second::binary-size(1), rest::binary>>, pairs, new_template) do
  #   to_insert = Map.fetch!(pairs, first <> second)

  #   apply_pairs(second <> rest, pairs, new_template <> to_insert <> second)
  # end
  # defp apply_pairs(<<_only_one::binary-size(1)>>, _pairs, new_template), do: new_template
  # defp apply_pairs(template, pairs), do: apply_pairs(template, pairs, String.first(template))
end
