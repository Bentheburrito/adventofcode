defmodule BingoBoard do
  @doc """
  %BingoBoard{
    squares: %{{0, 0} => 24, {0, 1} => 82, ...}
    numbers: %{24 => true, 82 => false, ...}
  }
  """
  defstruct squares: %{}, numbers: %{}
end

defmodule AOC.Y2021.Day4 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day4.txt"
  end

  def parse_input(input) do
    [calls | boards] = String.split(input, "\n\n", trim: true)

    calls =
      calls
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      boards
      |> Enum.map(fn raw_board ->
        board_values =
          raw_board
          |> String.split([" ", "\n"], trim: true)
          |> Enum.map(&String.to_integer/1)

        {board, _} = for x <- 0..4, y <- 0..4, reduce: {%BingoBoard{}, board_values} do
          {%BingoBoard{} = board, [val | rest]} ->
            {%BingoBoard{
               squares: Map.put(board.squares, {x, y}, val),
               numbers: Map.put(board.numbers, val, false)
             }, rest}
        end
        board
      end)

      {calls, boards}
  end

  def star_1({calls, boards}) do
    find_bingo_board_score(calls, boards, fn b ->
      if winning_board?(b) do
        {:halt, b}
      else
        false
      end
    end)
  end

  defp find_bingo_board_score(calls, boards, find_fun) do
    {%BingoBoard{} = winner, last_call} =
      Enum.reduce_while(calls, boards, fn call_val, boards ->
        boards
        |> Stream.map(fn %BingoBoard{} = b ->
          %BingoBoard{b | numbers: Map.put(b.numbers, call_val, true)}
        end)
        |> then(&Enum.find_value(&1, {:cont, &1}, find_fun))
        |> then(& if match?({:halt, _}, &1), do: {:halt, {elem(&1, 1), call_val}}, else: &1)
      end)

    unmarked_sum =
      winner.numbers
      |> Stream.filter(fn {_number, marked} -> not marked end)
      |> Stream.map(fn {number, _marked} -> number end)
      |> Enum.sum()

    unmarked_sum * last_call
  end

  defp winning_board?(board) do
    # check rows and cols for 5 trues in a row
    Enum.any?(0..4, fn y ->
      Enum.all?(0..4, &marked_square?(board, &1, y))
      or
      Enum.all?(0..4, &marked_square?(board, y, &1))
    end)
  end

  defp marked_square?(%BingoBoard{} = board, x, y) do
    number = Map.get(board.squares, {x, y})
    Map.get(board.numbers, number)
  end

  def star_2({calls, boards}) do
    num_boards = length(boards)
    {:ok, pid} = Agent.start(fn -> {0, %{}} end)

    find_bingo_board_score(calls, boards, fn b ->
      with true <- winning_board?(b),
           nil  <- Agent.get(pid, fn {_num_winners, winners} -> Map.get(winners, b.squares) end),
           Agent.update(pid, fn {num_winners, winners} -> {num_winners + 1, Map.put(winners, b.squares, true)} end),
           ^num_boards <- Agent.get(pid, &elem(&1, 0)) do
        {:halt, b}
      else
        _ -> false
      end
    end)
  end
end
