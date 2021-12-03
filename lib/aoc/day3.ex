defmodule Aoc.Day3a do
  def run do
    gamma =
      load("input/day3.txt")
      |> transpose()
      |> Enum.map(&Enum.sum/1)
      |> Enum.map(&to_binary/1)

    epsilon = Enum.map(gamma, fn
      0 -> 1
      1 -> 0
    end)

    Integer.undigits(gamma, 2) * Integer.undigits(epsilon, 2)
  end

  defp to_binary(number) when number > 500, do: 1
  defp to_binary(_), do: 0

  def transpose(list) do
    list
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def load(file) do
    file
    |> File.read!
    |> String.split(~r/\s/, trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Aoc.Day3b do
  import Aoc.Day3a, only: [load: 1, transpose: 1]

  def run do
    input = load("input/day3.txt")

    rating(input, 0, :>=) * rating(input, 0, :<)
  end

  def rating(input, 12, _), do: Integer.undigits(hd(input), 2)
  def rating(input, _, _) when length(input) == 1, do: Integer.undigits(hd(input), 2)
  def rating(input, pos, sign) do
    sum = input |> transpose |> Enum.map(&Enum.sum/1) |> Enum.at(pos)
    if apply(Kernel, sign, [sum, length(input) / 2]) do
      Enum.filter(input, fn digits -> Enum.at(digits, pos) == 1 end)
    else
      Enum.filter(input, fn digits -> Enum.at(digits, pos) == 0 end)
    end
    |> rating(pos + 1, sign)
  end
end
