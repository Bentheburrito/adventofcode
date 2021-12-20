defmodule AOC.Y2021.Day15 do
  @behaviour AOC.Solution

  @neighbor_offsets [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

  def input_path() do
    "./lib/2021/input/day15.txt"
  end

  def parse_input(input) do
    # Expand grid to 5x5 repeating tiles (we'll calc the risk increases dynamically)
    rows =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        String.duplicate(row, 5)
      end)
      |> List.duplicate(5)
      |> List.flatten()

    row_length = rows |> List.first() |> String.length()
    col_length = length(rows)

    # Build the directed graph, where the weight of an edge is the risk level of the incident vertex.
    graph =
      for {row, y} <- Enum.with_index(rows),
          {risk, x} <- Enum.with_index(String.split(row, "", trim: true)),
          # We have to provide a custom vertex id function, because the default would
          # cause overlap for a large # of vertices.
          reduce: Graph.new(vertex_identifier: & &1) do
        graph ->
          # Calculate risk depending on which 5x5 tile this point is.
          tile_risk_increase = div(x, div(row_length, 5)) + div(y, div(col_length, 5))
          risk = risk |> String.to_integer() |> Kernel.+(tile_risk_increase) |> wrap_to_one()

          Enum.reduce(@neighbor_offsets, graph, fn {x_offset, y_offset}, g ->
            to = {x, y}
            from = {x + x_offset, y + y_offset}

            Graph.add_edge(g, from, to, weight: risk)
          end)
      end

    graph
    |> Graph.edges()
    |> Enum.filter(fn %Graph.Edge{v1: {x1, y1}, v2: {x2, y2}} ->
      abs(x1 - x2) > 1 or abs(y1 - y2) > 1
    end)

    {graph, {row_length - 1, col_length - 1}}
  end

  defp wrap_to_one(risk), do: 1 + rem(risk - 1, 9)

  def star_1({graph, {end_x, end_y}}) do
    graph
    |> Graph.dijkstra({0, 0}, {div(end_x, 5), div(end_y, 5)})
    |> get_path_weight(graph)
  end

  defp get_path_weight([_only_one], _g, total_weight), do: total_weight

  defp get_path_weight([v1, v2 | path], %Graph{} = graph, total_weight) do
    %Graph.Edge{weight: weight} = Graph.edge(graph, v1, v2)
    get_path_weight([v2 | path], graph, total_weight + weight)
  end

  defp get_path_weight(path, %Graph{} = graph), do: get_path_weight(path, graph, 0)

  def star_2({graph, end_point}) do
    graph
    |> Graph.dijkstra({0, 0}, end_point)
    |> get_path_weight(graph)
  end
end
