defmodule AOC.Solution do
  @moduledoc """
  Behaviour that defines some callbacks for solution modules.
  """
  @callback input_path() :: String.t()
  @callback parse_input(input :: String.t()) :: any()
  @callback star_1(parsed_input :: any()) :: solution_value :: any()
  @callback star_2(parsed_input :: any()) :: solution_value :: any()
end
