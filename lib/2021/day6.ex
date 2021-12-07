defmodule AOC.Y2021.Day6 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day6.txt"
  end

  def parse_input(input) do
    input
    |> String.split([",", "\n"], trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

  def star_1(fish_list) do
    get_fish_after_days(fish_list, 80)
	end

  # initial brute-force impl...obviously didn't work for part 2 :)
  defp tick(fish_list) do
    Enum.reduce(fish_list, [], fn
      0, list ->
        [6, 8 | list]
      fish, list ->
        [fish - 1 | list]
    end)
  end

  def star_2(fish_list) do
    get_fish_after_days(fish_list, 256)
  end

  defp get_fish_after_days(initial_fish, days) when is_list(initial_fish) do
    initial_spawns = Enum.reduce(initial_fish, %{1 => length(initial_fish)}, fn fish_next_spawn, acc ->
      Enum.reduce((fish_next_spawn + 1)..days//7, acc, &add_fish(&2, &1, 1))
    end)
    get_fish_after_days(2..days, initial_spawns)
  end

  defp get_fish_after_days(last_day..last_day, spawn_map) do
    spawn_map
    |> Map.values()
    |> Enum.sum()
  end

  defp get_fish_after_days(cur_day..last_day, spawn_map) do
    new_spawn_map = case Map.get(spawn_map, cur_day, 0) do
      0 ->
        spawn_map
      cur_day_fish_count ->
        Enum.reduce((cur_day + 9)..last_day//7, spawn_map, &add_fish(&2, &1, cur_day_fish_count))
    end
    get_fish_after_days((cur_day + 1)..last_day, new_spawn_map)
  end

  defp add_fish(spawn_map, day, amount) do
    Map.update(spawn_map, day, amount, & &1 + amount)
  end

  # div(num_days, 7) + (rem(num_days, 7) - init_state > 0 && 1 || 0)
  # 1..day//7, => update map %{day => fish_spawned}
end
