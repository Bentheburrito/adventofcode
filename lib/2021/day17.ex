defmodule AOC.Y2021.Day17 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day17.txt"
  end

  def parse_input("target area: " <> ranges) do
    [x1, x2, y1, y2] =
      ranges
      |> String.split(["..", "x=", ", y="], trim: true)
      |> Enum.map(&String.to_integer/1)

    {x1..x2, y1..y2}
  end

  def star_1({_x_range, y1.._y2}) do
    init_y = -y1 - 1
    div(init_y * (init_y + 1), 2)
  end

  def star_2({_x1..x2 = x_range, y1.._y2 = y_range}) do
    potential_first_x =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.find(&(div(&1 * (&1 + 1), 2) in x_range))

    potential_xs = potential_first_x..x2

    potential_ys = y1..(-y1 - 1)

    for x <- potential_xs, y <- potential_ys, reduce: [] do
      valid_init_velocities ->
        init_velocity = {x, y}

        if hits_target?(init_velocity, x_range, y_range) do
          [init_velocity | valid_init_velocities]
        else
          valid_init_velocities
        end
    end
    |> length()
  end

  defp hits_target?({vel_x, vel_y}, {cur_x, cur_y}, _x1..max_x, min_y.._y2)
       when cur_x + vel_x > max_x or cur_y + vel_y < min_y,
       do: false

  defp hits_target?({vel_x, vel_y}, {cur_x, cur_y}, x_range, y_range) do
    x = cur_x + vel_x
    y = cur_y + vel_y

    cond do
      x in x_range and y in y_range -> true
      vel_x == 0 -> hits_target?({0, vel_y - 1}, {x, y}, x_range, y_range)
      :else -> hits_target?({vel_x - 1, vel_y - 1}, {x, y}, x_range, y_range)
    end
  end

  defp hits_target?(init_vel, x_range, y_range),
    do: hits_target?(init_vel, {0, 0}, x_range, y_range)
end
