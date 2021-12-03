defmodule Mix.Tasks.Aoc.Solve do
  use Mix.Task

  @shortdoc "Solve the problem of excercise <argument> (ie. Day6b) and show the result"

  def run([excercise]) do
    Module.safe_concat([Aoc, excercise])
    |> apply(:run, [])
    |> IO.inspect
  end
end
