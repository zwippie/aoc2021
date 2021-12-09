defmodule Aoc.Day9a do
  def run do
    load("input/day9.txt")
    |> low_points()
    |> risk_levels()
    |> Enum.sum()
  end

  def low_points(floor) do
    Enum.filter(floor, fn {{row, col}, height} ->
      height < Enum.min(adjacent_heights(floor, {row, col}))
    end)
  end

  defp adjacent_heights(floor, {row, col}) do
    [
      Map.get(floor, {row - 1, col}),
      Map.get(floor, {row + 1, col}),
      Map.get(floor, {row, col - 1}),
      Map.get(floor, {row, col + 1})
    ]
    |> Enum.filter(&(&1))
  end

  defp risk_levels(points) do
    Enum.map(points, fn {_pos, height} -> height + 1 end)
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

defmodule Aoc.Day9b do
  import Aoc.Day9a, only: [load: 1]

  @marker "X"

  def run do
    load("input/day9.txt")
    |> Enum.reject(fn {_, height} -> height == 9 end)
    |> Map.new()
    |> area_sizes()
    |> get_score()
  end

  defp area_sizes(floor) do
    Enum.reduce_while(floor, {floor, []}, fn {{row, col}, _height}, {acc, sizes} ->
      cond do
        Enum.empty?(acc) ->
          {:halt, sizes}

        is_nil(Map.get(acc, {row, col})) ->
          {:cont, {acc, sizes}}

        true ->
          new_floor = mark_area(acc, {row, col})
          new_count = Enum.count(new_floor, fn {_, height} -> height == @marker end)
          new_floor = Enum.reject(new_floor, fn {_, height} -> height == @marker end) |> Map.new()
          {:cont, {new_floor, [new_count | sizes]}}
      end
    end)
  end

  defp mark_area(floor, {row, col}) do
    if Map.get(floor, {row, col}) in 0..8 do
      floor = Map.put(floor, {row, col}, @marker)

      [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
      |> Enum.reduce(floor, fn {row2, col2}, floor_acc ->
        mark_area(floor_acc, {row2, col2})
      end)
    else
      floor
    end
  end

  defp get_score(sizes) do
    sizes
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&(&1 * &2))
  end
end
