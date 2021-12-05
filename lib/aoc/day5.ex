defmodule Aoc.Day5a do
  def run do
    load("input/day5.txt")
    |> Enum.filter(&is_horizontal_or_vertical/1)
    |> Enum.reduce(%{}, &mark_line_on_field/2)
    |> count_overlaps()
  end

  def count_overlaps(field) do
    Enum.reduce(field, 0, fn {_pos, count}, acc ->
      if count > 1, do: acc + 1, else: acc
    end)
  end

  defp is_horizontal_or_vertical({{x1, y1}, {x2, y2}}) do
    x1 == x2 or y1 == y2
  end

  # horizontal and vertical
  def mark_line_on_field({{x1, y1}, {x2, y2}}, field) when x1 == x2 or y1 == y2 do
    (for x <- x1..x2, y <- y1..y2, do: {x, y})
    |> mark_points_on_field(field)
  end

  # diagonal
  def mark_line_on_field({{x1, y1}, {x2, y2}}, field) do
    [Enum.to_list(x1..x2), Enum.to_list(y1..y2)]
    |> List.zip
    |> mark_points_on_field(field)
  end

  defp mark_points_on_field(points, field) do
    Enum.reduce(points, field, fn coords, acc ->
      Map.update(acc, coords, 1, &(&1 + 1))
    end)
  end

  def load(file) do
    file
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(&parse_coordinates/1)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  defp parse_coordinates(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Aoc.Day5b do
  import Aoc.Day5a, only: [load: 1, mark_line_on_field: 2, count_overlaps: 1]

  def run do
    load("input/day5.txt")
    |> Enum.reduce(%{}, &mark_line_on_field/2)
    |> count_overlaps()
  end
end
