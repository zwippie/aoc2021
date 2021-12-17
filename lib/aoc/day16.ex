defmodule Aoc.Day16a do
  defmodule Packet do
    defstruct version: nil, type: nil, length_type: nil, length: nil, literal: nil, packets: []
  end

  def run do
    load("input/day16.txt")
    |> do_parse()
    |> version_sum()
  end

  def do_parse(input), do: parse(input, [])

  # done when all is left is a empty or zero value with less than 8 bits
  defp parse(<<>>, packets), do: packets
  defp parse(<<0::size(1)>>, packets), do: packets
  defp parse(<<0::size(2)>>, packets), do: packets
  defp parse(<<0::size(3)>>, packets), do: packets
  defp parse(<<0::size(4)>>, packets), do: packets
  defp parse(<<0::size(5)>>, packets), do: packets
  defp parse(<<0::size(6)>>, packets), do: packets
  defp parse(<<0::size(7)>>, packets), do: packets

  # literal
  defp parse(<<version::3, 4::3, rest::bitstring>>, packets) do
    {literal, rest} = parse_literal(rest, [], 4)
    parse(rest, [%Packet{version: version, type: 4, literal: literal} | packets])
  end

  # operator, length type 0
  defp parse(<<version::3, type::3, 0::1, sub_length::15, subpacketbits::size(sub_length), rest::bitstring>>, packets) do
    subpackets = parse(<<subpacketbits::size(sub_length)>>, []) |> Enum.reverse()
    parse(rest, [%Packet{version: version, type: type, length_type: 0, length: sub_length, packets: subpackets} | packets])
  end

  # operator, length type 1
  defp parse(<<version::3, type::3, 1::1, packet_count::11, rest::bitstring>>, packets) do
    {rest, packets3} =
      Enum.reduce(1..packet_count, {rest, []}, fn _, {rest2, packets2} ->
        parse_sub(rest2, packets2)
      end)
    packets3 = Enum.reverse(packets3)
    parse(rest, [%Packet{version: version, type: type, length_type: 1, length: packet_count, packets: packets3} | packets])
  end

  # sub literal
  defp parse_sub(<<version::3, 4::3, rest::bitstring>>, packets) do
    {literal, rest} = parse_literal(rest, [], 4)
    {rest, [%Packet{version: version, type: 4, literal: literal} | packets]}
  end

  # sub operator type 0
  defp parse_sub(<<version::3, type::3, 0::1, sub_length::15, subpacketbits::size(sub_length), rest::bitstring>>, packets) do
    subpackets = parse(<<subpacketbits::size(sub_length)>>, []) |> Enum.reverse()
    {rest, [%Packet{version: version, type: type, length_type: 0, length: sub_length, packets: subpackets} | packets]}
  end

  # operator, length type 1
  defp parse_sub(<<version::3, type::3, 1::1, packet_count::11, rest::bitstring>>, packets) do
    {rest2, packets2} =
      Enum.reduce(1..packet_count, {rest, []}, fn _, {rest3, packets3} ->
        parse_sub(rest3, packets3)
      end)
    packets2 = Enum.reverse(packets2)

    {rest2, [%Packet{version: version, type: type, length_type: 1, length: packet_count, packets: packets2} | packets]}
  end

  # literal and stop
  defp parse_literal(<<0::1, value::4, rest::bitstring>>, acc, len) do
    <<literal::size(len)>> =
      [value | acc]
      |> Enum.reverse()
      |> Enum.map(& <<&1::4>>)
      |> Enum.into(<<>>)

    {literal, rest}
  end

  # literal and continue
  defp parse_literal(<<1::1, value::4, rest::bitstring>>, acc, len) do
    parse_literal(rest, [value | acc], len + 4)
  end

  defp version_sum(packets, acc \\ 0) do
    Enum.reduce(packets, acc, fn packet, acc2 ->
      version_sum(packet.packets, acc2 + packet.version)
    end)
  end

  def load(input) do
    File.read!(input)
    |> String.split("", trim: true)
    |> Enum.map(& <<String.to_integer(&1, 16)::4>>)
    |> Enum.into(<<>>)
  end
end

defmodule Aoc.Day16b do
  import Aoc.Day16a, only: [load: 1, do_parse: 1]
  alias Aoc.Day16a.Packet

  def run do
    load("input/day16.txt")
    |> do_parse()
    |> do_reduce()
  end

  defp do_reduce([packet]) do
    reduce(packet)
  end

  defp reduce(%Packet{type: 0} = packet) do
    Enum.map(packet.packets, &reduce/1)
    |> Enum.sum()
  end

  defp reduce(%Packet{type: 1} = packet) do
    Enum.map(packet.packets, &reduce/1)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp reduce(%Packet{type: 2} = packet) do
    Enum.map(packet.packets, &reduce/1)
    |> Enum.min()
  end

  defp reduce(%Packet{type: 3} = packet) do
    Enum.map(packet.packets, &reduce/1)
    |> Enum.max()
  end

  defp reduce(%Packet{type: 4} = packet) do
    packet.literal
  end

  defp reduce(%Packet{type: 5} = packet) do
    [a, b] = Enum.map(packet.packets, &reduce/1)
    if a > b, do: 1, else: 0
  end

  defp reduce(%Packet{type: 6} = packet) do
    [a, b] = Enum.map(packet.packets, &reduce/1)
    if a < b, do: 1, else: 0
  end

  defp reduce(%Packet{type: 7} = packet) do
    [a, b] = Enum.map(packet.packets, &reduce/1)
    if a == b, do: 1, else: 0
  end
end
