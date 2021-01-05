module Polytopes

using LightGraphs
using StaticArrays

include("polytope.jl")
include("show.jl")

export
        Polytope,
        Polygon,
        Polyhedron,
        paramdim,
        nverts,
        faces,
        facets,
        GeometricPolytope,
        Vertex,
        embeddim

end
