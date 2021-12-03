defmodule Aoc.Day2a do
  def run do
    {hor_pos, depth} =
      load("input/day2.txt")
      |> Enum.reduce({0, 0}, &move/2)

    hor_pos * depth
  end

  def load(file) do
    file
    |> File.read!
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp move({:forward, dist}, {hor_pos, depth}) do
    {hor_pos + dist, depth}
  end
  defp move({:down, dist}, {hor_pos, depth}) do
    {hor_pos, depth + dist}
  end
  defp move({:up, dist}, {hor_pos, depth}) do
    {hor_pos, depth - dist}
  end

  defp parse_line(line) do
    [direction, distance] = String.split(line, " ", trim: true, limit: 2)
    {String.to_atom(direction), String.to_integer(distance)}
  end
end

defmodule Aoc.Day2b do
  import Aoc.Day2a, only: [load: 1]

  def run do
    {hor_pos, depth, _aim} =
      load("input/day2.txt")
      |> Enum.reduce({0, 0, 0}, &move/2)

    hor_pos * depth
  end

  defp move({:forward, dist}, {hor_pos, depth, aim}) do
    {hor_pos + dist, depth + aim * dist, aim}
  end
  defp move({:down, dist}, {hor_pos, depth, aim}) do
    {hor_pos, depth, aim + dist}
  end
  defp move({:up, dist}, {hor_pos, depth, aim}) do
    {hor_pos, depth, aim - dist}
  end
end
