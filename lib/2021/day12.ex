defmodule AOC.Y2021.Day12 do
  @behaviour AOC.Solution

  def input_path() do
    "./lib/2021/input/day12.txt"
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn edge, graph ->
      [node1, node2] = String.split(edge, "-")

      graph
      |> Map.update(node1, [node2], &[node2 | &1])
      |> Map.update(node2, [node1], &[node1 | &1])
    end)
  end

  def star_1(graph) do
    find_num_paths(graph)
  end

  defp find_num_paths(_graph, "end", _visited), do: 1
  defp find_num_paths(_graph, cur, %MapSet{map: map} = _visited) when is_map_key(map, cur), do: 0
  defp find_num_paths(graph, cur, visited) do
    visited =
      if small_cave?(cur) do
        MapSet.put(visited, cur)
      else
        visited
      end

    graph[cur]
    |> Stream.map(&find_num_paths(graph, &1, visited))
    |> Enum.sum()
  end

  defp find_num_paths(graph), do: find_num_paths(graph, "start", MapSet.new())

  defp small_cave?(node), do: String.downcase(node) == node

  def star_2(graph) do
    find_num_varied_paths(graph)
  end

  defp find_num_varied_paths(_graph, "end", _visited, cur_path, paths),
    do: [["end" | cur_path] | paths]

  defp find_num_varied_paths(graph, cur, visited, cur_path, paths)
       when is_map_key(visited, cur) do
    if can_traverse_second_time?(cur, visited) do
      visited = Map.put(visited, cur, 2)

      graph[cur]
      |> Stream.flat_map(&find_num_varied_paths(graph, &1, visited, [cur | cur_path], paths))
    else
      paths
    end
  end

  defp find_num_varied_paths(graph, cur, visited, cur_path, paths) do
    visited =
      if small_cave?(cur) do
        Map.update(visited, cur, 1, &(&1 + 1))
      else
        visited
      end

    graph[cur]
    |> Stream.flat_map(&find_num_varied_paths(graph, &1, visited, [cur | cur_path], paths))
  end

  defp find_num_varied_paths(graph) do
    find_num_varied_paths(graph, "start", Map.new(), [], [])
    |> Stream.uniq()
    |> Enum.to_list()
    |> length()
  end

  defp can_traverse_second_time?(node, visited) do
    small_cave?(node) and
      visited[node] == 1 and
      node != "start" and
      not Enum.any?(visited, fn {_node, count} -> count == 2 end)
  end
end
