defmodule Aoc.Day7a do
  def run do
    input = load("input/day7.txt") |> Enum.sort()

    for move_to <- input do
      fuel_cost(input, move_to)
    end
    |> Enum.min()
  end

  defp fuel_cost(input, move_to) do
    Enum.reduce(input, 0, fn value, acc ->
      abs(value - move_to) + acc
    end)
  end

  def load(file) do
    file
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Aoc.Day7b do
  import Aoc.Day7a, only: [load: 1]

  def run do
    input = load("input/day7.txt") |> Enum.sort()

    for move_to <- input do
      fuel_cost(input, move_to)
    end
    |> Enum.min()
    |> trunc()
  end

  defp fuel_cost(input, move_to) do
    Enum.reduce(input, 0, fn value, acc ->
      move_cost(value, move_to) + acc
    end)
  end

  defp move_cost(from, to) when from > to do
    diff = from - to
    (diff * (diff + 1)) / 2
  end
  defp move_cost(from, to) do
    diff = to - from
    (diff * (diff + 1)) / 2
  end
end
