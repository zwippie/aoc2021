defmodule Aoc.Day4a do
  def run do
    {numbers, boards} = load("input/day4.txt")

    next_turn(boards, numbers)
    |> calculate_score()
  end

  defp next_turn(boards, [number | numbers]) do
    boards = mark_boards(boards, number)

    case Enum.find(boards, &bingo?/1) do
      nil -> next_turn(boards, numbers)
      board -> {board, number}
    end
  end

  def mark_boards(boards, number) do
    Enum.map(boards, fn board -> mark_board(board, number) end)
  end

  defp mark_board(board, number) do
    for row <- board do
      for col <- row do
        if col == number, do: :marked, else: col
      end
    end
  end

  def bingo?(board) do
    Enum.any?(board, &full_row?/1) or Enum.any?(transpose(board), &full_row?/1)
  end

  defp full_row?(row) do
    Enum.all?(row, fn number -> number == :marked end)
  end

  defp transpose(list) do
    list
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def calculate_score({board, number}) do
    (for row <- board, col <- row, col != :marked, do: col)
    |> Enum.sum()
    |> Kernel.*(number)
  end

  def load(file) do
    [numbers | boards] =
      file
      |> File.read!()
      |> String.split(~r/\n\n/)

    {parse_numbers(numbers), parse_boards(boards)}
  end

  defp parse_numbers(line) do
    line
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_boards(lines) do
    Enum.map(lines, &parse_board/1)
  end

  defp parse_board(line) do
    line
    |> String.split(~r/\n/)
    |> Enum.map(&parse_board_row/1)
  end

  defp parse_board_row(row) do
    row
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Aoc.Day4b do
  import Aoc.Day4a, only: [load: 1, calculate_score: 1, mark_boards: 2, bingo?: 1]

  def run do
    {numbers, boards} = load("input/day4.txt")

    next_turn(boards, numbers)
    |> calculate_score()
  end

  def next_turn(boards, [number | numbers]) do
    {bingo_boards, boards} =
      boards
      |> mark_boards(number)
      |> Enum.split_with(&bingo?/1)

    if Enum.empty?(boards) do
      {hd(bingo_boards), number}
    else
      next_turn(boards, numbers)
    end
  end
end
