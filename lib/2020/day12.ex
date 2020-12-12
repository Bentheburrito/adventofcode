defmodule AOC.Day12 do
	defmodule Ferry do
		defstruct x: 0, y: 0, facing: "E", waypoint_x: 10, waypoint_y: 1

		@directions ["E", "S", "W", "N"]

		def forward_waypoint(%Ferry{x: x, y: y, waypoint_x: x_wp, waypoint_y: y_wp} = ferry, distance), do: %{ferry | x: x + x_wp * distance, y: y + y_wp * distance}

		def rotate_waypoint(%Ferry{waypoint_x: x, waypoint_y: y} = ferry, rot_dir, degrees) do
			angle = :math.atan2(y, x) - :math.atan2(0, 1)
			distance = :math.sqrt(x * x + y * y)
			radians = rot_dir == "R" && -degrees * :math.pi / 180 || degrees * :math.pi / 180
			%{ferry | waypoint_x: round(distance * :math.cos(angle + radians)), waypoint_y: round(distance * :math.sin(angle + radians))}
		end

		def forward(%Ferry{y: y, facing: "N"} = ferry, distance), do: %{ferry | y: y + distance}
		def forward(%Ferry{y: y, facing: "S"} = ferry, distance), do: %{ferry | y: y - distance}
		def forward(%Ferry{x: x, facing: "E"} = ferry, distance), do: %{ferry | x: x + distance}
		def forward(%Ferry{x: x, facing: "W"} = ferry, distance), do: %{ferry | x: x - distance}

		def rotate(%Ferry{facing: facing} = ferry, "R", degrees), do:
			%{ferry | facing: Enum.at(Stream.cycle(@directions), Enum.find_index(@directions, & &1 == facing) + div(degrees, 90) + 4)}
		def rotate(%Ferry{facing: facing} = ferry, "L", degrees), do:
			%{ferry | facing: Enum.at(Stream.cycle(@directions), Enum.find_index(@directions, & &1 == facing) - div(degrees, 90) + 4)}
	end

	def run(input) do
		instructions = input |> String.split("\n") |> Enum.map(fn <<action::binary-size(1)>> <> value -> {action, String.to_integer(value)} end)

		manhattan_dist = AOC.time(&instructions_to_manhattan/2, [instructions, &eval_action/2])
		IO.puts "Manhattan Distance after instructions: #{manhattan_dist}"

		manhattan_dist_p2 = AOC.time(&instructions_to_manhattan/2, [instructions, &eval_action_p2/2])
		IO.puts "Revised Manhattan Distance after instructions: #{manhattan_dist_p2}"
	end

	def instructions_to_manhattan(instructions, evaluator) do
		ferry = eval_instructions(instructions, evaluator)
		manhattan_distance(ferry)
	end

	def eval_instructions([], %Ferry{} = ferry, _evaluator), do: ferry
	def eval_instructions([action | instructions], %Ferry{} = ferry, evaluator) do
	 	new_ferry = evaluator.(ferry, action)
		eval_instructions(instructions, new_ferry, evaluator)
	end
	def eval_instructions(instructions, evaluator), do: eval_instructions(instructions, %Ferry{}, evaluator)

	def eval_action(%Ferry{y: y} = ferry, {"N", value}), do: %{ferry | y: y + value}
	def eval_action(%Ferry{y: y} = ferry, {"S", value}), do: %{ferry | y: y - value}
	def eval_action(%Ferry{x: x} = ferry, {"E", value}), do: %{ferry | x: x + value}
	def eval_action(%Ferry{x: x} = ferry, {"W", value}), do: %{ferry | x: x - value}
	def eval_action(%Ferry{} = ferry, {"F", value}), do: Ferry.forward(ferry, value)
	def eval_action(%Ferry{} = ferry, {direction, value}), do: Ferry.rotate(ferry, direction, value)

	def eval_action_p2(%Ferry{waypoint_y: y} = ferry, {"N", value}), do: %{ferry | waypoint_y: y + value}
	def eval_action_p2(%Ferry{waypoint_y: y} = ferry, {"S", value}), do: %{ferry | waypoint_y: y - value}
	def eval_action_p2(%Ferry{waypoint_x: x} = ferry, {"E", value}), do: %{ferry | waypoint_x: x + value}
	def eval_action_p2(%Ferry{waypoint_x: x} = ferry, {"W", value}), do: %{ferry | waypoint_x: x - value}
	def eval_action_p2(%Ferry{} = ferry, {"F", value}), do: Ferry.forward_waypoint(ferry, value)
	def eval_action_p2(%Ferry{} = ferry, {direction, value}), do: Ferry.rotate_waypoint(ferry, direction, value)

	def manhattan_distance(%Ferry{x: x, y: y}), do: abs(x) + abs(y)
end
