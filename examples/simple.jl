using Polytopes
using Colors
using GraphPlot
using LightGraphs

p = FullPolytope([[1, 2], [2, 3], [3, 1], [2, 3], [3, 4], [4, 2]], [[1, 2, 3], [4, 5, 6]])
g = p.graph
is = Polytopes.start_indices(p.connectivity)
colors = [colorant"red", colorant"turquoise", colorant"green"]
gplot(g, nodelabel=vertices(g), nodefillc=[colors[something(findfirst(x -> i ≤ x, is), 0) + 1] for i ∈ vertices(g)])
