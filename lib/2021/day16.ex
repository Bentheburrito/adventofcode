defmodule AOC.Y2021.Day16 do
  defmodule Packet do
    @enforce_keys [:version, :type_id, :bit_size, :value]
    defstruct [:version, :type_id, :bit_size, :value]

    @type t() :: %Packet{
            version: integer(),
            type_id: integer(),
            bit_size: integer(),
            value: integer() | [t()]
          }
  end

  @behaviour AOC.Solution

  @header_bit_size 6

  def input_path() do
    "./lib/2021/input/day16.txt"
  end

  def parse_input(input) do
    bit_count = String.length(input) * 4

    input
    |> String.to_integer(16)
    |> Integer.to_string(2)
    |> String.pad_leading(bit_count, "0")
  end

  ## PART 1 ##
  def star_1(binary) do
    parse_message(binary)
    |> sum_versions()
  end

  def parse_message(binary) do
    {packet, _extra_bits} = parse_packet(binary)
    packet
  end

  # type_id 4 (100 in binary) is a packet with a literal value (number)
  defp parse_packet(<<version::binary-size(3), "100", rem::binary>>) do
    {value, literal_bit_count} = parse_literal(rem)
    packet_bit_count = @header_bit_size + literal_bit_count

    packet = %Packet{
      version: String.to_integer(version, 2),
      type_id: 4,
      bit_size: packet_bit_count,
      value: value
    }

    # Trim this packet's bits off the front of the binary
    <<_packet_bits::binary-size(literal_bit_count), remaining_binary::binary>> = rem

    {packet, remaining_binary}
  end

  # other type_ids indicate operator
  defp parse_packet(<<version::binary-size(3), type_id::binary-size(3), rem::binary>>) do
    {sub_packet_list, remaining_binary} = parse_operator(rem)
    packet_bit_count = @header_bit_size + String.length(rem) - String.length(remaining_binary)

    packet = %Packet{
      version: String.to_integer(version, 2),
      type_id: String.to_integer(type_id, 2),
      bit_size: packet_bit_count,
      value: sub_packet_list
    }

    {packet, remaining_binary}
  end

  defp parse_operator(<<"0", sub_packet_bits::binary-size(15), rem::binary>>) do
    sub_packet_bit_count = String.to_integer(sub_packet_bits, 2)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({sub_packet_bit_count, _sub_packets = [], rem}, fn
      _i, {0, packets, rem} ->
        {:halt, {Enum.reverse(packets), rem}}

      _i, {remaining_bits, packets, rem} ->
        {%Packet{bit_size: packet_bit_count} = packet, rem} = parse_packet(rem)

        acc = {remaining_bits - packet_bit_count, [packet | packets], rem}
        {:cont, acc}
    end)
  end

  defp parse_operator(<<"1", number_sub_packet_bits::binary-size(11), rem::binary>>) do
    number_sub_packets = String.to_integer(number_sub_packet_bits, 2)

    {packets, remaining_binary} =
      Enum.reduce(1..number_sub_packets, {_sub_packets = [], rem}, fn
        _i, {packets, rem} ->
          {%Packet{} = packet, rem} = parse_packet(rem)

          {[packet | packets], rem}
      end)

    {Enum.reverse(packets), remaining_binary}
  end

  defp parse_literal(<<"1", number_chunk::binary-size(4), rem::binary>>, number_bits) do
    parse_literal(rem, number_bits <> number_chunk)
  end

  defp parse_literal(<<"0", number_chunk::binary-size(4), _rem::binary>>, number_bits) do
    number = number_bits <> number_chunk
    number_len = String.length(number)

    literal_bit_count = number_len + div(number_len, 4)

    {String.to_integer(number, 2), literal_bit_count}
  end

  defp parse_literal(packet), do: parse_literal(packet, "")

  defp sum_versions(%Packet{version: version, value: number}, sum) when is_integer(number) do
    sum + version
  end

  defp sum_versions(%Packet{version: version, value: [%Packet{} | _rest] = sub_packets}, sum) do
    sub_sum =
      sub_packets
      |> Enum.map(&sum_versions(&1, 0))
      |> Enum.sum()

    sub_sum + sum + version
  end

  defp sum_versions(packet), do: sum_versions(packet, 0)

  ## PART 2 ##
  def star_2(binary) do
    parse_message(binary)
    |> eval_packet()
  end

  defp eval_packet(%Packet{type_id: 0, value: packets}) do
    packets
    |> Stream.map(&eval_packet/1)
    |> Enum.sum()
  end

  defp eval_packet(%Packet{type_id: 1, value: packets}) do
    packets
    |> Stream.map(&eval_packet/1)
    |> Enum.product()
  end

  defp eval_packet(%Packet{type_id: 2, value: packets}) do
    packets
    |> Enum.min_by(&eval_packet/1)
    |> eval_packet()
  end

  defp eval_packet(%Packet{type_id: 3, value: packets}) do
    packets
    |> Enum.max_by(&eval_packet/1)
    |> eval_packet()
  end

  defp eval_packet(%Packet{type_id: 4, value: value}), do: value

  defp eval_packet(%Packet{type_id: 5, value: [packet1, packet2]}) do
    (eval_packet(packet1) > eval_packet(packet2) && 1) || 0
  end

  defp eval_packet(%Packet{type_id: 6, value: [packet1, packet2]}) do
    (eval_packet(packet1) < eval_packet(packet2) && 1) || 0
  end

  defp eval_packet(%Packet{type_id: 7, value: [packet1, packet2]}) do
    (eval_packet(packet1) == eval_packet(packet2) && 1) || 0
  end
end
