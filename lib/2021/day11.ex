defmodule AOC.Y2021.Day11 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day11.txt"
  end

  def parse_input(input) do
    rows = String.split(input, "\n", trim: true)

    for {row, x} <- Enum.with_index(rows),
        {energy, y} <- Enum.with_index(String.to_charlist(row)),
        into: %{} do
      {{x, y}, {energy - ?0, _flashed? = false}}
    end
  end

  def star_1(octopuses) do
    get_tot_flashes_after_steps(octopuses, 100)
  end

  defp get_tot_flashes_after_steps(_octopuses, 0, total_flashes), do: total_flashes

  defp get_tot_flashes_after_steps(octopuses, steps, total_flashes) do
    {new_octos, flashes} = step(octopuses)
    get_tot_flashes_after_steps(new_octos, steps - 1, total_flashes + flashes)
  end

  defp get_tot_flashes_after_steps(octopuses, steps),
    do: get_tot_flashes_after_steps(octopuses, steps, 0)

  defp step(octopuses) do
    octopuses
    |> increment_all()
    |> check_flashes()
    |> zero_flashed()
  end

  defp increment_all(octopuses) do
    for {{x, y}, {energy, flashed?}} <- octopuses, into: %{} do
      {{x, y}, {energy + 1, flashed?}}
    end
  end

  defp check_flashes(octopuses) do
    for x <- 0..9, y <- 0..9, reduce: octopuses do
      octos ->
        {energy, flashed?} = Map.get(octos, {x, y})

        if energy > 9 and not flashed? do
          flash(octos, x, y)
        else
          octos
        end
    end
  end

  defp flash(octopuses, x, y) do
    octopuses = Map.update!(octopuses, {x, y}, fn {energy, _flashed?} -> {energy, true} end)

    for x_offset <- -1..1, y_offset <- -1..1, reduce: octopuses do
      acc_octos when x_offset == 0 and y_offset == 0 ->
        acc_octos

      acc_octos when is_map_key(acc_octos, {x + x_offset, y + y_offset}) ->
        pos = {x + x_offset, y + y_offset}

        {{cur_energy, flashed?}, octos} =
          Map.get_and_update!(acc_octos, pos, fn
            {energy, flashed?} -> {{energy + 1, flashed?}, {energy + 1, flashed?}}
          end)

        if cur_energy > 9 and not flashed? do
          flash(octos, x + x_offset, y + y_offset)
        else
          octos
        end

      acc_octos ->
        acc_octos
    end
  end

  defp zero_flashed(octopuses) do
    Enum.reduce(octopuses, {%{}, _flash_count = 0}, fn
      {pos, {_energy, _flashed? = true}}, {new_octos, flash_count} ->
        {Map.put(new_octos, pos, {0, false}), flash_count + 1}

      {pos, octo}, {new_octos, flash_count} ->
        {Map.put(new_octos, pos, octo), flash_count}
    end)
  end

  def star_2(octopuses) do
    find_step_all_flash(octopuses)
  end

  defp find_step_all_flash(octopuses, cur_step) do
    {new_octos, flashes} = step(octopuses)

    if flashes == 100 do
      cur_step
    else
      find_step_all_flash(new_octos, cur_step + 1)
    end
  end

  defp find_step_all_flash(octopuses), do: find_step_all_flash(octopuses, 1)
end
