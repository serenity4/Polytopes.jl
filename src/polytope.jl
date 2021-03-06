"""
A (abstract) `Polytope` describes the combinatorial structure used to discretize a surface from a set of given points (vertices)
linked together with edges, faces, 3D cells and so on. It does not include any location information, and therefore cannot
be represented as geometry. It is usually represented with a Hasse diagram, which provides a way to read off the structure
of a polytope as a partially ordered set.
Only when a polytope is associated with vertex data can we visually represent a possible _realization_ of this particular
polytope. Such a realization is called a geometric polytope.
"""
struct Polytope{N}
    graph::SimpleDiGraph{Int}
    nverts::Int
    start_indices::Vector{Int}
end

const Polygon = Polytope{2}
const Polyhedron = Polytope{3}

Polytope(g::SimpleDiGraph, k::Integer, nverts::Integer, start_indices::AbstractVector{<:Integer}) = Polytope{k}(g, nverts, start_indices)

"""
Build a `Polytope` from the structure provided in `indices`.
The nth argument passed as `indices` describes connectivity from the (n-1)th face to the nth face.

## Example

```julia
julia> Polytope(4,
    [(1, 2), (2, 3), (3, 1), (2, 3), (3, 4), (4, 2)], # edges (segments)
    [(1, 2, 3), (4, 5, 6)] # 2 triangle faces from edges 1, 2, 3 and 4, 5, 6 respectively
)

julia> Polytope(4,
    [(1, 2, 3, 1), (2, 3, 4, 2)], # edges (closed chains)
    [(1,), (2,)]) # faces (made from a closed chain -> PolySurface with no inner chains)
```
"""
function Polytope(connectivity::Vector{<:AbstractVector})
    faces_starts = start_indices(connectivity)
    nnodes = last(faces_starts) + length(last(connectivity))
    g = SimpleDiGraph(nnodes)
    add_faces!.(Ref(g), faces_starts, vcat(0, faces_starts[1:end-1]), connectivity)
    Polytope(g, length(connectivity), first(faces_starts), faces_starts)
end

Polytope(connectivity::AbstractVector...) = Polytope(collect(connectivity))

Base.:(==)(x::Polytope{K1}, y::Polytope{K2}) where {K1,K2} = false
Base.:(==)(x::Polytope{K}, y::Polytope{K}) where {K} = x.graph == y.graph && nverts(x) == nverts(y) && start_indices(x) == start_indices(y)

function add_faces!(g::SimpleDiGraph, src_start::Integer, dst_start::Integer, faces)
    for (src, dst_edge) ∈ enumerate(faces)
        for dst ∈ dst_edge
            add_edge!(g, src + src_start, dst + dst_start)
        end
    end
    g
end

start_indices(connectivity) = cumsum(maximum(maximum.(faces)) for faces ∈ connectivity)
start_indices(p::Polytope) = p.start_indices

nverts(p::Polytope) = p.nverts

rank(::Type{<:Polytope{N}}) where {N} = N
rank(p::Polytope) = rank(typeof(p))

function polytope_range(p::Polytope, k::Integer)
    @assert k ≠ rank(p)
    1:(start_indices(p)[k+1])
end

faces(p::Polytope, k) = k == rank(p) ? p : Polytope(p.graph[polytope_range(p, k)], k, nverts(p), start_indices(p)[1:k])

facets(p::Polytope) = faces(p, rank(p) - 1)

"""
Vertex associated with a specific position in space.
"""
struct Vertex{D,T}
    location::SVector{D,T}
end

Vertex(location::AbstractVector) = Vertex(SVector{length(location)}(location))
Vertex(coords::Number...) = Vertex(collect(coords))

Base.length(::Type{<:Vertex{D}}) where {D} = D

struct GeometricPolytope{D,P<:Polytope,V<:AbstractVector{<:Vertex{D}}}
    polytope::P
    vertices::V
    function GeometricPolytope(p::Polytope, vertices::AbstractVector{<:Vertex})
        @assert nverts(p) == length(vertices) "$(nverts(p)) vertices required for $p, found $(length(vertices))"
        new{length(eltype(vertices)),typeof(p),typeof(vertices)}(p, vertices)
    end
end

embeddim(::Type{<:GeometricPolytope{D}}) where {D} = D
embeddim(gp::GeometricPolytope) = embeddim(typeof(gp))
