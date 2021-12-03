defmodule Aoc.Day1a do
  def run do
    load("input/day1.txt")
    |> count_increasing()
  end

  def count_increasing(numbers) do
    numbers
    |> Enum.reduce({10_000, 0}, fn num, {prev, acc} ->
      if num > prev, do: {num, acc + 1}, else: {num, acc}
    end)
    |> elem(1)
  end

  def load(file) do
    file
    |> File.read!
    |> String.split(~r/\s/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Aoc.Day1b do
  import Aoc.Day1a, except: [run: 0]

  def run do
    load("input/day1.txt")
    |> sliding_windows()
    |> count_increasing()
  end

  defp sliding_windows(numbers) do
    len = length(numbers) - 3
    for i <- 0..len do
      Enum.slice(numbers, i, 3) |> Enum.sum()
    end
  end
end
