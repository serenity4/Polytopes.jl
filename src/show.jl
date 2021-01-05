function Base.show(io::IO, p::Polytope)
    diff = 0
    print(io, paramdim(p), "-polytope with")
    for (i, j) ∈ enumerate(start_indices(p))
        n = j - diff
        k = i - 1
        noun = n == 1 && k == 0 ? "vertex" : n == 1 && k == 1 ? "edge" : n == 1 && k == 2 ? "face" : k == 0 ? "vertices" : k == 1 ? "edges" : k == 2 ? "faces" : n == 1 ? string(k, "-face") : string(k, "-faces")
        i ≠ 1 && print(io, ',')
        print(io, ' ', n, ' ', noun)
        diff = j
    end
end

Base.show(io::IO, gp::GeometricPolytope) = print(io, embeddim(gp), "-dimensional geometric ", string(gp.polytope))

