defmodule AOCTest.Y2021.Day16Test do
  use ExUnit.Case

  alias AOC.Y2021.Day16
  alias Day16.Packet

  setup do
    inputs = ["D2FE28", "38006F45291200", "EE00D40C823060"]
    |> Enum.map(&Day16.parse_input(&1))
    %{inputs: inputs}
  end

  test "packet parsing", %{inputs: [input1, input2, input3]} do
    assert %Packet{bit_size: 21, type_id: 4, value: 2021, version: 6} == Day16.parse_message(input1)
    assert %Packet{
      bit_size: 49,
      type_id: 6,
      value: [
        %AOC.Y2021.Day16.Packet{bit_size: 11, type_id: 4, value: 10, version: 6},
        %AOC.Y2021.Day16.Packet{bit_size: 16, type_id: 4, value: 20, version: 2}
      ],
      version: 1
    } == Day16.parse_message(input2)
    assert %Packet{
      bit_size: 51,
      type_id: 3,
      value: [
        %AOC.Y2021.Day16.Packet{bit_size: 11, type_id: 4, value: 1, version: 2},
        %AOC.Y2021.Day16.Packet{bit_size: 11, type_id: 4, value: 2, version: 4},
        %AOC.Y2021.Day16.Packet{bit_size: 11, type_id: 4, value: 3, version: 1}
      ],
      version: 7
    } == Day16.parse_message(input3)
  end

  test "Day16 part 1", %{inputs: [input1, input2, input3]} do
    assert Day16.star_1(input1) == 6
    assert Day16.star_1(input2) == 1 + 2 + 6
    assert Day16.star_1(input3) == 7 + 1 + 4 + 2
  end

  test "Day16 part 2", %{inputs: [input1, input2, input3]} do
    assert Day16.star_2(input1) == 2021
    assert Day16.star_2(input2) == 1
    assert Day16.star_2(input3) == 3

    input4 = Day16.parse_input("9C0141080250320F1802104A08")
    assert Day16.star_2(input4) == 1

    input5 = Day16.parse_input("880086C3E88112")
    assert Day16.star_2(input5) == 7

    input6 = Day16.parse_input("D8005AC2A8F0")
    assert Day16.star_2(input6) == 1
  end

  AOC.run(Day16)
end
