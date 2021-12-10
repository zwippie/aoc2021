defmodule Aoc.Day10a do
  def run do
    load("input/aoc-2021-day10-up4.txt")
    |> Enum.map(&evaluate/1)
    |> corrupt_score()
  end

  def evaluate(chunk, open_tags \\ [])
  def evaluate([], []), do: :valid
  def evaluate([], open_tags), do: {:incomplete, open_tags}
  def evaluate([current_tag | rest_of_chunk], open_tags) do
    cond do
      current_tag in '([{<' ->
        evaluate(rest_of_chunk, [current_tag | open_tags])

      true ->
        [last_open_tag | rest_of_open_tags] = open_tags
        if current_tag == expected_closing_tag(last_open_tag) do
          evaluate(rest_of_chunk, rest_of_open_tags)
        else
          {:corrupt, current_tag}
        end
    end
  end

  defp corrupt_score(results) do
    Enum.reduce(results, 0, fn
      :valid, acc -> acc
      {:incomplete, _}, acc -> acc
      {:corrupt, ?)}, acc -> acc + 3
      {:corrupt, ?]}, acc -> acc + 57
      {:corrupt, ?}}, acc -> acc + 1197
      {:corrupt, ?>}, acc -> acc + 25137
    end)
  end

  def expected_closing_tag(opening_tag) do
    case opening_tag do
      ?( -> ?)
      ?[ -> ?]
      ?{ -> ?}
      ?< -> ?>
    end
  end

  def load(file) do
    file
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&String.to_charlist/1)
  end
end

defmodule Aoc.Day10b do
  import Aoc.Day10a, except: [run: 0]

  def run do
    load("input/aoc-2021-day10-up4.txt")
    |> Enum.map(&evaluate/1)
    |> incomplete_scores()
    |> middle_score()
  end

  defp incomplete_scores(results) do
    Enum.flat_map(results, fn
      :valid -> [0]
      {:corrupt, _} -> []
      {:incomplete, open_tags} -> [incomplete_score(open_tags, 0)]
    end)
  end

  defp middle_score(scores) do
    middle = floor(length(scores) / 2)
    scores
    |> Enum.sort()
    |> IO.inspect(label: "scores")
    |> Enum.at(middle)
  end

  defp incomplete_score([], acc), do: acc
  defp incomplete_score([open_tag | rest_of_open_tags], acc) do
    incomplete_score(rest_of_open_tags, 5 * acc + tag_score(open_tag))
  end

  defp tag_score(tag) do
    case tag do
      ?( -> 1
      ?[ -> 2
      ?{ -> 3
      ?< -> 4
    end
  end
end
