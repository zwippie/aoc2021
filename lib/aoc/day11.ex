defmodule Aoc.Day11a do
  def run do
    load("input/day11.txt")
    |> next_step(1, 0)
  end

  defp next_step(_, 101, flash_count), do: flash_count
  defp next_step(grid, step_count, flash_count) do
    grid =
      grid
      |> increment_all()
      |> flashes()

    flash_count = flash_count + Enum.count(grid, fn {_pos, energy} -> energy == 0 end)

    next_step(grid, step_count + 1, flash_count)
  end

  def flashes(grid) do
    grid =
      Enum.reduce(grid, grid, fn {pos, energy}, acc ->
        if energy > 9 do
          surrounding(pos)
          |> Enum.reduce(acc, fn pos2, acc2 ->
            if Map.has_key?(acc2, pos2) and Map.get(acc2, pos2) != 0 do
              Map.update!(acc2, pos2, &(&1 + 1))
            else
              acc2
            end
          end)
          |> Map.put(pos, 0)
        else
          acc
        end
      end)

    if Enum.any?(grid, fn {_pos, energy} -> energy > 9 end) do
      flashes(grid)
    else
      grid
    end
  end

  defp surrounding({row, col}) do
    [
      {row - 1, col - 1}, {row - 1, col}, {row - 1, col + 1},
      {row, col - 1}, {row, col + 1},
      {row + 1, col - 1}, {row + 1, col}, {row + 1, col + 1}
    ]
  end

  def increment_all(grid) do
    Enum.map(grid, fn {pos, energy} ->
      {pos, energy + 1}
    end) |> Map.new()
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

defmodule Aoc.Day11b do
  import Aoc.Day11a, except: [run: 0]

  def run do
    load("input/day11.txt")
    |> next_step(1)
  end

  def next_step(grid, step_count) do
    grid =
      grid
      |> increment_all()
      |> flashes()

    if Enum.all?(grid, fn {_pos, energy} -> energy == 0 end) do
      step_count
    else
      next_step(grid, step_count + 1)
    end
  end
end
