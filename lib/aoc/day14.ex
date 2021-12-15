defmodule Aoc.Day14a do
  def run do
    {template, rules} = load("input/day14example.txt")

    step(template, rules, 0)
    |> score()
  end

  def step(template, _rules, 10), do: template
  def step(template, rules, step_count) do
    [first | _] = transformed =
      template
      |> Stream.chunk_every(2, 1, :discard)
      |> Stream.flat_map(fn chunk -> Enum.intersperse(chunk, Map.get(rules, chunk)) end)
      |> Enum.to_list()

    step([first] ++ Enum.drop_every(transformed, 3), rules, step_count + 1)
  end

  def score(template) do
    {min, max} =
      template
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.min_max()

    max - min
  end

  def load(input) do
    [template, rules] =
      input
      |> File.read!()
      |> String.split(~r/\n\n/, parts: 2)

    {String.to_charlist(template), parse_rules(rules)}
  end

  defp parse_rules(lines) do
    lines
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse_rule/1)
    |> Map.new()
  end

  defp parse_rule(line) do
    [key, value] = String.split(line, " -> ")
    [value] = String.to_charlist(value)
    {String.to_charlist(key), value}
  end
end

defmodule Aoc.Day14b do
  import Aoc.Day14a, only: [load: 1]

  def run do
    {template, rules} = load("input/day14example.txt")

    template
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.reduce(%{}, fn chunk, acc -> step(chunk, rules, acc, 0) end)
  end

  def step(_chunk, _rules, acc, 10), do: acc
  def step(chunk, rules, acc, step_count) do

  end
end
