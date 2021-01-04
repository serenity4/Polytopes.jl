using Polytopes
using LightGraphs
using Test

@testset "Polytopes.jl" begin
    p = FullPolytope([[1, 2], [2, 3], [3, 1], [2, 3], [3, 4], [4, 2]], [[1, 2, 3], [4, 5, 6]])
    @test faces(p, 0) == 1:4
    @test faces(p, 1) == facets(p) == 5:10
    @test faces(p, 2) == 11:12
    @test p.graph == SimpleDiGraph([
        Edge(5, 1),
        Edge(5, 2),
        Edge(6, 2),
        Edge(6, 3),
        Edge(7, 3),
        Edge(7, 1),
        Edge(8, 2),
        Edge(8, 3),
        Edge(9, 3),
        Edge(9, 4),
        Edge(10, 4),
        Edge(10, 2),
        Edge(11, 5),
        Edge(11, 6),
        Edge(11, 7),
        Edge(12, 8),
        Edge(12, 9),
        Edge(12, 10),
    ])
end
