defmodule Aoc.Day12a do
  defmodule Node do
    defstruct name: nil, connections: [], size: nil, visits: 0

    def new(name, connected_to) do
      %Node{name: name, size: size_of(name), connections: [connected_to]}
    end

    def add_connection(%Node{} = node, to) do
      %{node | connections: [to | node.connections]}
    end

    def visit(%Node{} = node) do
      %{node | visits: node.visits + 1}
    end

    defp size_of(name) do
      if String.upcase(name) == name, do: :large, else: :small
    end
  end

  def run do
    load("input/day12.txt")
    |> routes("start", &can_visit?/2)
    |> Enum.sum()
  end

  def routes(_, "end", _), do: [1]
  def routes(nodes, current_name, can_visit_fun) do
    current_node =
      nodes
      |> Map.get(current_name)
      |> Node.visit()

    nodes = Map.put(nodes, current_name, current_node)

    current_node.connections
    |> Enum.map(&Map.get(nodes, &1))
    |> Enum.filter(&can_visit_fun.(&1, nodes))
    |> Enum.flat_map(&routes(nodes, &1.name, can_visit_fun))
  end

  defp can_visit?(%Node{size: :large}, _), do: true
  defp can_visit?(%Node{visits: 0}, _), do: true
  defp can_visit?(%Node{}, _), do: false

  def load(input) do
    input
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
    |> Enum.reduce(%{}, &add_node_and_connection/2)
  end

  defp add_node_and_connection(line, nodes) do
    [from, to] = String.split(line, "-", limit: 2)

    nodes
    |> Map.update(from, Node.new(from, to), &Node.add_connection(&1, to))
    |> Map.update(to, Node.new(to, from), &Node.add_connection(&1, from))
  end
end

defmodule Aoc.Day12b do
  import Aoc.Day12a, only: [load: 1, routes: 3]
  alias Aoc.Day12a.Node

  def run do
    load("input/day12.txt")
    |> routes("start", &can_visit?/2)
    |> Enum.sum()
  end

  defp can_visit?(%Node{name: "start"}, _), do: false
  defp can_visit?(%Node{size: :large}, _), do: true
  defp can_visit?(%Node{visits: 0}, _), do: true
  defp can_visit?(%Node{}, nodes) do
    not Enum.any?(Map.values(nodes), &(&1.size == :small && &1.visits == 2))
  end
end
