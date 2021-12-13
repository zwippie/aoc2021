defmodule Aoc.Day13a do
  def run do
    {points, [fold | _folds]} = load("input/day13example.txt")

    do_fold(points, fold)
    |> print()
    |> length()
  end

  def do_fold(points, {:x, fold_at}) do
    {left, right} = Enum.split_with(points, fn {x, _y} -> x < fold_at end)

    right = Enum.map(right, fn {x, y} -> {2 * fold_at - x, y} end)

    Enum.uniq(left ++ right)
  end

  def do_fold(points, {:y, fold_at}) do
    {upper, lower} = Enum.split_with(points, fn {_x, y} -> y < fold_at end)

    lower = Enum.map(lower, fn {x, y} -> {x, 2 * fold_at - y} end)

    Enum.uniq(upper ++ lower)
  end

  def get_dimensions(points) do
    {
      Enum.max_by(points, fn {x, _} -> x end) |> elem(0),
      Enum.max_by(points, fn {_, y} -> y end) |> elem(1)
    }
  end

  def print(points) do
    {width, height} = get_dimensions(points)
    grid = Map.new(points, fn point -> {point, "#"} end)

    for y <- 0..height do
      for x <- 0..width do
        Map.get(grid, {x, y}, " ") |> IO.write
      end
      IO.puts("")
    end
    IO.puts("")

    points
  end

  def load(file) do
    [points, folds] =
      file
      |> File.read!()
      |> String.split(~r/\n\n/, limit: 2)

    {parse_points(points), parse_folds(folds)}
  end

  defp parse_points(points) do
    points
    |> String.split(~r/\n/)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp parse_folds(folds) do
    folds
    |> String.split(~r/\n/)
    |> Enum.map(&parse_fold/1)
  end

  defp parse_fold(fold) do
    [axis, point] =
      fold
      |> String.replace("fold along ", "")
      |> String.split("=", limit: 2)

    {String.to_atom(axis), String.to_integer(point)}
  end
end

defmodule Aoc.Day13b do
  import Aoc.Day13a, except: [run: 0]

  def run do
    {points, folds} = load("input/day13.txt")

    Enum.reduce(folds, points, fn fold, acc ->
      do_fold(acc, fold)
    end)
    |> print()
    |> length()
  end
end
