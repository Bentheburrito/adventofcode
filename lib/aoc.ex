defmodule AOC do
	@type function_result :: any

	def run2020(day_num) do
		IO.puts("Running solution...")
		input = get_input(2020, day_num)
		apply(String.to_existing_atom("Elixir.AOC.Day#{day_num}"), :run, [input])
	end

	@spec get_input(String.t | number, String.t | number) :: String.t
	def get_input(year, day_num) do
		File.read!("./lib/#{year}/input/day#{day_num}.txt")
	end

	@spec time(function, list) :: function_result
	def time(function, args) do
		{time, res} = :timer.tc(function, args)
		IO.puts("---\nFinished in #{time / 1000}ms:")
		res
	end
end
