defmodule AOC do
  def run(module) do
    IO.puts("Running solution(s) for #{module}")
    input = File.read!(module.input_path())
    {parse_time_us, parsed_input} = :timer.tc(module, :parse_input, [input])
    {first_time_us, first_solution_val} = :timer.tc(module, :star_1, [parsed_input])
    {second_time_us, second_solution_val} = :timer.tc(module, :star_2, [parsed_input])
    IO.puts("""
    Input parse time: #{parse_time_us / 1000}ms
    Star 1 (#{first_time_us / 1000}ms): #{first_solution_val}
    Star 2 (#{second_time_us / 1000}ms): #{second_solution_val}
    """)
  end

  @deprecated "Use AOC.run/1 instead"
	@spec time(function, list) :: any()
	def time(function, args) do
		{time, res} = :timer.tc(function, args)
		IO.puts("---\nFinished in #{time / 1000}ms:")
		res
  end
end
