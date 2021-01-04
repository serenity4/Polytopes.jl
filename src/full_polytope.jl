abstract type AbstractPolytope{N} end

struct FullPolytope{N,V<:AbstractVector{<:AbstractVector{<:AbstractVector{Int}}}} <: AbstractPolytope{N}
    graph::SimpleDiGraph{Int}
    connectivity::V
end

FullPolytope(g::SimpleDiGraph, connectivity::AbstractVector{<:AbstractVector{<:AbstractVector{<:Integer}}}) = FullPolytope{length(connectivity),typeof(connectivity)}(g, connectivity)

"""
Build a `FullPolytope` from the structure provided in `indices`.
The nth argument passed as `indices` describes connectivity from the (n-1)th face to the nth face.

## Example

```julia
julia> FullPolytope(4,
    [(1, 2), (2, 3), (3, 1), (2, 3), (3, 4), (4, 2)], # edges (segments)
    [(1, 2, 3), (4, 5, 6)] # 2 triangle faces from edges 1, 2, 3 and 4, 5, 6 respectively
)

julia> FullPolytope(4,
    [(1, 2, 3, 1), (2, 3, 4, 2)], # edges (closed chains)
    [(1,), (2,)]) # faces (made from a closed chain -> PolySurface with no inner chains)
```
"""
function FullPolytope(connectivity::AbstractVector{<:AbstractVector{<:AbstractVector{Int}}})
    faces_starts = start_indices(connectivity)
    g = SimpleDiGraph(last(faces_starts) + length(last(connectivity)))
    add_faces!.(Ref(g), faces_starts, vcat(0, faces_starts[1:end-1]), connectivity)
    FullPolytope(g, connectivity)
end

FullPolytope(connectivity::AbstractVector{<:AbstractVector{Int}}...) = FullPolytope(collect(connectivity))

function add_faces!(g::SimpleDiGraph, src_start::Integer, dst_start::Integer, faces)
    for (src, dst_edge) ∈ enumerate(faces)
        for dst ∈ dst_edge
            add_edge!(g, src + src_start, dst + dst_start)
        end
    end
    g
end

start_indices(connectivity) = cumsum(maximum(maximum.(faces)) for faces ∈ connectivity)

paramdim(::Type{<:FullPolytope{N}}) where {N} = N
paramdim(p::FullPolytope) = paramdim(typeof(p))

function faces(p::FullPolytope, k)
    faces_starts = start_indices(p.connectivity)
    all_start_indices = vcat(0, faces_starts, last(faces_starts) + length(last(p.connectivity)))
    (all_start_indices[k + 1] + 1):all_start_indices[k + 2]
end

facets(p::FullPolytope) = faces(p, paramdim(p) - 1)
