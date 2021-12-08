defmodule Aoc.Day8a do
  def run do
    input = load("input/day8.txt")

    Enum.reduce(input, 0, fn {_, output}, acc ->
      Enum.reduce(output, 0, fn output_digit, acc2 ->
        cond do
          length(output_digit) in [2, 3, 4, 7] -> acc2 + 1
          true -> acc2
        end
      end) + acc
    end)
  end

  def load(file) do
    file
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [patterns, outputs] = String.split(line, " | ")
    {parse_input(patterns), parse_input(outputs)}
  end

  defp parse_input(input) do
    input
    |> String.split(" ", trim: true)
    |> Enum.map(&sort_string/1)
  end

  defp sort_string(string) do
    string
    |> String.split("", trim: true)
    |> Enum.sort()
  end
end

defmodule Aoc.Day8b do
  import Aoc.Day8a, only: [load: 1]

  def run do
    load("input/day8.txt")
    |> Enum.map(&find_output_number/1)
    |> Enum.sum()
  end

  defp find_output_number({patterns, output}) do
    digits =
      patterns
      |> find_digits()
      |> Enum.with_index()
      |> Map.new()

    Enum.map(output, fn output_digit ->
      Map.get(digits, output_digit)
    end)
    |> Integer.undigits()
  end

  defp find_digits(patterns) do
    one = Enum.find(patterns, &(length(&1) == 2))
    four = Enum.find(patterns, &(length(&1) == 4))
    seven = Enum.find(patterns, &(length(&1) == 3))
    eight = Enum.find(patterns, &(length(&1) == 7))

    six = Enum.find(patterns, fn pattern ->
      length(pattern) == 6 and length(pattern -- one) == 5
    end)

    [segment_c] = one -- six
    [segment_f] = one -- [segment_c]

    three = Enum.find(patterns, fn pattern ->
      length(pattern) == 5 and length(pattern -- one) == 3
    end)

    zero = Enum.find(patterns, fn pattern ->
      length(pattern) == 6 and length(pattern -- three) == 2 and pattern != six
    end)

    nine = Enum.find(patterns, fn pattern ->
      length(pattern) == 6 and pattern not in [zero, six]
    end)

    five = Enum.find(patterns, fn pattern ->
      length(pattern) == 5 and segment_c not in pattern
    end)

    two = Enum.find(patterns, fn pattern ->
      length(pattern) == 5 and segment_f not in pattern
    end)

    [zero, one, two, three, four, five, six, seven, eight, nine]
  end
end
