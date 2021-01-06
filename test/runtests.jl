using Polytopes
using LightGraphs
using Test

@testset "Polytopes.jl" begin
    _edges = [[1, 2], [2, 3], [3, 1], [2, 3], [3, 4], [4, 2]]
    _faces = [[1, 2, 3], [4, 5, 6]]
    p = Polytope(_edges, _faces)
    @test rank(p) == 2
    @test nverts(p) == 4
    @test faces(p, 0).graph == SimpleDiGraph(nverts(p))
    @test faces(p, 1) == facets(p) == Polytope([_edges])
    @test faces(p, 2) === p
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
    @test string(p) == "2-polytope with 4 vertices, 6 edges, 2 faces"

    gp = GeometricPolytope(p, map(x -> Vertex(randn(3)), 1:nverts(p)))
    @test embeddim(gp) == 3
    @test gp.polytope == p
    @test string(gp) == "3-dimensional geometric 2-polytope with 4 vertices, 6 edges, 2 faces"
end
