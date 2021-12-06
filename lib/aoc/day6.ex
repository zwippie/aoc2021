defmodule Aoc.Day6a do
  def run do
    load("input/day6.txt")
    |> Enum.frequencies()
    |> next_day(0, 80)
  end

  def next_day(timers, last_day, last_day) do
    timers
    |> Map.values()
    |> Enum.sum()
  end
  def next_day(timers, day, last_day) do
    timers
    |> Enum.reduce(%{}, fn {time, count}, acc ->
      cond do
        time == 0 -> Map.update(acc, 6, count, &(&1 + count)) |> Map.put(8, count)
        true -> Map.update(acc, time - 1, count, &(&1 + count))
      end
    end)
    |> next_day(day + 1, last_day)
  end

  def load(file) do
    file
    |> File.read!()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Aoc.Day6b do
  import Aoc.Day6a, except: [run: 0]

  def run do
    load("input/day6.txt")
    |> Enum.frequencies()
    |> next_day(0, 256)
  end
end
