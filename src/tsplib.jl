function write_tsp(x::Vector{Float64}, y::Vector{Float64}; dist="EUC_2D")
    n_nodes = length(x)
    @assert length(x) == length(y)

    name = randstring(10)
    filepath = joinpath(pwd(), name * ".tsp")

    open(filepath, "w") do io
        write(io, "NAME: $(name)\n")
        write(io, "TYPE: TSP\n")
        write(io, "COMMENT: $(name)\n")
        write(io, "DIMENSION: $(n_nodes)\n")
        write(io, "EDGE_WEIGHT_TYPE: $(dist)\n")
        write(io, "EDGE_WEIGHT_FORMAT: FUNCTION \n")
        write(io, "NODE_COORD_TYPE: TWOD_COORDS \n")
        write(io, "NODE_COORD_SECTION\n")
        for i in 1:n_nodes
            write(io, "$i $(x[i]) $(y[i])\n")
        end
        write(io, "EOF\n")
    end

    return name, filepath
end





function write_tsp(dist_mtx::Matrix{Int})
    n_nodes = size(dist_mtx, 1)

    name = randstring(10)
    filepath = joinpath(pwd(), name * ".tsp")

    lower_diag_row = Int[]
    for i in 1:n_nodes
        for j in 1:i
            push!(lower_diag_row, dist_mtx[i, j])
        end
    end
    buf = 10
    n_rows = length(lower_diag_row) / buf |> ceil |> Int
    rows = String[]
    for i in 1:n_rows
        s = buf * (i-1) + 1
        t = min(buf * i, length(lower_diag_row))
        push!(rows, join(lower_diag_row[s:t], " "))
    end

    open(filepath, "w") do io
        write(io, "NAME: $(name)\n")
        write(io, "TYPE: TSP\n")
        write(io, "COMMENT: $(name)\n")
        write(io, "DIMENSION: $(n_nodes)\n")
        write(io, "EDGE_WEIGHT_TYPE: EXPLICIT\n")
        write(io, "EDGE_WEIGHT_FORMAT: LOWER_DIAG_ROW \n")
        write(io, "EDGE_WEIGHT_SECTION\n")
        for r in rows
            write(io, "$r\n")
        end
        write(io, "EOF\n")
    end

    return name, filepath
end




function write_atsp(dist_mtx::Matrix{Int})
    n_nodes = size(dist_mtx, 1)

    name = randstring(10)
    filepath = joinpath(pwd(), name * ".tsp")

    rows = String[]
    for i in 1:n_nodes
        push!(rows, join(dist_mtx[i, :], " "))
    end

    open(filepath, "w") do io
        write(io, "NAME: $(name)\n")
        write(io, "TYPE: ATSP\n")
        write(io, "COMMENT: $(name)\n")
        write(io, "DIMENSION: $(n_nodes)\n")
        write(io, "EDGE_WEIGHT_TYPE: EXPLICIT\n")
        write(io, "EDGE_WEIGHT_FORMAT: FULL_MATRIX \n")
        write(io, "EDGE_WEIGHT_SECTION\n")
        for r in rows
            write(io, "$r\n")
        end
        write(io, "EOF\n")
    end

    return name, filepath
end