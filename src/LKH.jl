module LKH

using Random, LinearAlgebra

# Write your package code here.
include("../deps/deps.jl") # const LKH_EXECUTABLE
include("tsplib.jl")


function tour_length(tour, M)
    n_nodes = length(tour)
    len = 0
    for i in 1:n_nodes
        j = i + 1
        if i == n_nodes
            j = 1
        end

        len += M[tour[i], tour[j]]
    end

    return len
end

function filepath(name, ext)
    return joinpath(pwd(), "$(name).$(ext)")
end


function write_par(name; kwargs...)
    par_filepath = filepath(name, "par")
    out_filepath = filepath(name, "out")

    open(par_filepath, "w") do io
        write(io, "PROBLEM_FILE = $(name).tsp\n")
        write(io, "TOUR_FILE = $(name).out\n")
        if length(kwargs) > 0
            for (key, val) in kwargs
                write(io, key, " = ", string(val), "\n")
            end
        end            
    end

    return name
end

function read_output(name)
    output = readlines(filepath(name, "out"))
    idx1 = findfirst(x -> x=="TOUR_SECTION", output) + 1
    idx2 = findfirst(x -> x=="-1", output) - 1
    tour = parse.(Int, output[idx1:idx2])

    len = parse(Int, split(output[2])[end])

    return tour, len
end

function cleanup(name)
    exts = ["par", "tsp", "out"]
    rm.(filepath.(name, exts))
end

function _solve_tsp(name; log="off", kwargs...)
    if log == "off" || Sys.iswindows()
        status = run(`$(LKH.LKH_EXECUTABLE) $(name).par`, wait=false)
        while !success(status)
            # Wait until it finishes
            # In Windows, it stops with "Press any key to continue . . . "
        end
    else        
        run(`$(LKH.LKH_EXECUTABLE) $(name).par`)
    end

    opt_tour, opt_len = read_output(name)
    
    cleanup(name)

    return opt_tour, opt_len
end

function solve_tsp(dist_mtx::Matrix{Int}; log="off", kwargs...)
    if issymmetric(dist_mtx)
        name, tsp_filepath = write_tsp(dist_mtx)
    else 
        name, tsp_filepath = write_atsp(dist_mtx)
    end

    write_par(name; kwargs...)
    return _solve_tsp(name; log=log, kwargs...)
end

function solve_tsp(x::Vector{Float64}, y::Vector{Float64}; dist="EUC_2D", log="off", kwargs...)
    name, tsp_filepath = write_tsp(x, y; dist=dist)
    write_par(name; kwargs...)
    return _solve_tsp(name; log=log, kwargs...)
end

export solve_tsp

end
