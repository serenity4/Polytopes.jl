using Polytopes
using LightGraphs
using Test

@testset "Polytopes.jl" begin
    p = Polytope([[1, 2], [2, 3], [3, 1], [2, 3], [3, 4], [4, 2]], [[1, 2, 3], [4, 5, 6]])
    @test paramdim(p) == 2
    @test nverts(p) == 4
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
    @test string(p) == "2-polytope with 4 vertices, 6 edges"

    gp = GeometricPolytope(p, map(x -> Vertex(randn(3)), 1:nverts(p)))
    @test embeddim(gp) == 3
    @test gp.polytope == p
    @test string(gp) == "3-dimensional geometric 2-polytope with 4 vertices, 6 edges"
end
