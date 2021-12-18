defmodule Aoc.Day17a do
  def run do
    load("input/day17.txt")
    |> trajectories()
    |> find_max_height()
  end

  def trajectories([_x1..x2 = x_range, y1.._y2 = y_range]) do
    for vx <- min_vx(x_range)..x2, vy <- y1..-y1 do
      shoot({0, 0}, {vx, vy}, {x_range, y_range}, [{0, 0}])
    end
    |> Enum.filter(&(&1))
  end

  def shoot({x, y}, {vx, vy}, {_x1..x2 = x_range, y1.._y2 = y_range}, trajectory) do
    x = x + vx
    y = y + vy
    vx = if vx > 0, do: vx - 1, else: 0
    vy = vy - 1

    cond do
      x in x_range and y in y_range -> # hit
        [{x, y} | trajectory] |> Enum.reverse()

      x > x2 or y < y1 -> # overshot
        nil

      true -> # keep going
        shoot({x, y}, {vx, vy}, {x_range, y_range}, [{x, y} | trajectory])
    end
  end

  def min_vx(x_range, current \\ 1) do
    max_x = trunc((current * (current + 1)) / 2)
    if max_x in x_range do
      current
    else
      min_vx(x_range, current + 1)
    end
  end

  def find_max_height(trajectories) do
    Enum.max_by(trajectories, fn traject ->
      Enum.max_by(traject, fn {_x, y} -> y end)
    end)
    |> Enum.max_by(fn {_x, y} -> y end)
    |> elem(1)
  end

  def load(file) do
    file
    |> File.read!()
    |> String.splitter([", ", ": "])
    |> Enum.slice(1, 2)
    |> Enum.map(&parse_x_y/1)
  end

  defp parse_x_y(string) do
    [_x_y, from, to] =
      string
      |> String.splitter(["=", ".."])
      |> Enum.take(3)

    Range.new(String.to_integer(from), String.to_integer(to))
  end
end

defmodule Aoc.Day17b do
  import Aoc.Day17a, except: [run: 0]

  def run do
    load("input/day17.txt")
    |> trajectories()
    |> length()
  end
end
