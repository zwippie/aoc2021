defmodule Aoc.Day15a do
  def run do
    grid = load("input/day15.txt")
    max_row = grid |> Map.keys() |> Enum.map(fn {row, _} -> row end) |> Enum.max
    max_col = grid |> Map.keys() |> Enum.map(fn {_, col} -> col end) |> Enum.max
    end_pos = {max_row, max_col} |> IO.inspect(label: "end_pos")

    find_path(grid, end_pos)
  end

  def find_path(grid, end_pos) do
    Enum.reduce(grid, Graph.new(type: :directed), fn {pos, _risk}, graph ->
      edges =
        pos
        |> surrounding(grid)
        |> Enum.map(fn {pos2, risk2} ->
          Graph.Edge.new(pos, pos2, weight: risk2)
        end)

      Graph.add_edges(graph, edges)
    end)
    |> Graph.a_star({0, 0}, end_pos, fn pos2 ->
      manhattan_distance(pos2, end_pos)
    end)
    |> tl() # skip start
    # |> IO.inspect(label: "route")
    |> Enum.reduce(0, fn pos, acc ->
      acc + Map.get(grid, pos)
    end)
  end

  defp manhattan_distance({a, b}, {c, d}) do
    abs(a - c) + abs(b - d)
  end

  defp distance({a, b}, {c, d}) do
    :math.sqrt(:math.pow(a - c, 2) + :math.pow(b - d, 2))
  end

  defp surrounding({row, col}, grid) do
    Map.take(grid,[
      {row, col + 1},
      {row + 1, col},
      {row - 1, col},
      {row, col - 1}
    ])
  end

  def print(grid, {max_row, max_col}) do
    for x <- 0..max_row do
      for y <- 0..max_col do
        Map.get(grid, {x, y}) |> IO.write
      end
      IO.puts("")
    end
    IO.puts("")

    grid
  end

  def load(file) do
    file
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_idx}, acc ->
      Enum.reduce(row, acc, fn {col, col_idx}, acc2 ->
        Map.put(acc2, {row_idx, col_idx}, col)
      end)
    end)
  end

  defp parse_line(line) do
    line
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end
end

defmodule Aoc.Day15b do
  import Aoc.Day15a, except: [run: 0]

  # 1514/1515/1520 too low
  def run do
    grid = load("input/day15.txt")
    max_row = grid |> Map.keys() |> Enum.map(fn {row, _} -> row end) |> Enum.max
    max_col = grid |> Map.keys() |> Enum.map(fn {_, col} -> col end) |> Enum.max
    end_pos = {5 * max_row + 4, 5 * max_col + 4} |> IO.inspect(label: "end_pos")


    for x <- 0..4, y <- 0..4 do
      Enum.map(grid, fn {{row, col}, risk} ->
        {{x * (max_row + 1) + row, y * (max_col + 1) + col}, increment(risk, x + y)}
      end)
    end
    |> List.flatten()
    |> Map.new()
    # |> print(end_pos)
    |> find_path(end_pos)
  end

  defp increment(risk, count) do
    risk = risk + count
    if risk > 9, do: increment(risk - 9, 0), else: risk
  end
end
