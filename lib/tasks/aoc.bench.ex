defmodule Mix.Tasks.Aoc.Bench do
  use Mix.Task

  @shortdoc "Benchmark excercise <argument> (ie. Day6b)"

  def run([excercise]) do
    Benchee.run(
      %{
        excercise => fn ->
          Module.safe_concat([Aoc, excercise])
          |> apply(:run, [])
        end
      }
    )
  end
end
