module LKH

using Random 

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

function write_par(dist_mtx; runs=4)
    name, tsp_filepath = write_tsp(dist_mtx)

    par_filepath = filepath(name, "par")
    out_filepath = filepath(name, "out")

    open(par_filepath, "w") do io
        write(io, "PROBLEM_FILE = $(name).tsp\n")
        write(io, "RUNS = $runs\n")
        write(io, "TOUR_FILE = $(name).out\n")
    end

    return name
end

function read_output(name)
    output = readlines(filepath(name, "out"))
    idx1 = findfirst(x -> x=="TOUR_SECTION", output) + 1
    idx2 = findfirst(x -> x=="-1", output) - 1

    tour = parse.(Int, output[idx1:idx2])
    return tour
end

function cleanup(name)
    exts = ["par", "tsp", "out"]
    rm.(filepath.(name, exts))
end

function solve_tsp(dist_mtx::Matrix{Int})
    if dist_mtx != dist_mtx'
        error("The problem must be symmetric.")
    end

    name = write_par(dist_mtx)

    status = run(`$(LKH.LKH_EXECUTABLE) $(name).par`, wait=false)
    while !success(status)
        # 
    end

    opt_tour = read_output(name)
    opt_len = tour_length(opt_tour, dist_mtx)
    
    cleanup(name)

    return opt_tour, opt_len
end



export solve_tsp

end
