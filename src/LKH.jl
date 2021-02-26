module LKH

using Random, LinearAlgebra

# Write your package code here.
include("../deps/deps.jl") # const LKH_EXECUTABLE
include("utils.jl")
include("solver.jl")


export solve_tsp

end
