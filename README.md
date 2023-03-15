# LKH.jl

[![Build Status](https://github.com/chkwon/LKH.jl/workflows/CI/badge.svg?branch=master)](https://github.com/chkwon/LKH.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/chkwon/LKH.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/chkwon/LKH.jl)

This package provides a Julia wrapper for the [LKH-3](http://webhotel4.ruc.dk/~keld/research/LKH-3/) library for solving Traveling Salesman Problems (TSP) and various Vehicle Routing Problems (VRPs). 

While this Julia package is under MIT License, the underlying LKH library comes in a different license. Check with the [LKH library homepage](http://webhotel4.ruc.dk/~keld/research/LKH-3/).

# Installation

```julia
] add LKH
```

# Usage for TSP

## Using a distance matrix

```julia
using LKH
M = [
    0  16   7  14
   16   0   3   5
    7   3   0  16
   14   5  16   0 
]
opt_tour, opt_len = solve_tsp(M)
```
The distance matrix `M` can be either symmetric or asymmetric, but must be integer-valued.


## Using coordinates

```julia
using LKH
n_nodes = 10
x = rand(n_nodes) .* 10000
y = rand(n_nodes) .* 10000
opt_tour, opt_len = solve_tsp(x, y; dist="EUC_2D")
opt_tour, opt_len = solve_tsp(x, y; dist="MAN_2D")
opt_tour, opt_len = solve_tsp(x, y; dist="MAX_2D")
opt_tour, opt_len = solve_tsp(x, y; dist="GEO")
```
Available `dist` functions are listed in [`TSPLIB_DOC.pdf`](http://webhotel4.ruc.dk/~keld/research/LKH/LKH-2.0/DOC/TSPLIB_DOC.pdf). (Some may not be implemented in this package.)

## Using a TSPLIB format file input

Using the [TSPLIB format](http://webhotel4.ruc.dk/~keld/research/LKH/LKH-2.0/DOC/TSPLIB_DOC.pdf):

```julia
using LKH
opt_tour, opt_len = solve_tsp("gr17.tsp")
```

## Passing solver parameters

In all cases, [solver parameters](http://webhotel4.ruc.dk/~keld/research/LKH-3/LKH-3.0/DOC/LKH-3_PARAMETERS.pdf) are passed as keyword arguments.

```julia
opt_tour, opt_len = solve_tsp(M; INITIAL_TOUR_ALGORITHM="GREEDY", RUNS=5, TIME_LIMIT=10.0)
```

# Usage for VRPs

For example, for the Capacitated Vehicle Routing Problem (CVRP):

```julia
using CVRPLIB, LKH
cvrp, vrp_file_path, solution_file_path = readCVRP("E-n101-k14")
@time opt_tour, opt_len = solve_tsp(vrp_file_path, TIME_LIMIT=1.0)
```


# Related Projects

- [Concorde.jl](https://github.com/chkwon/Concorde.jl): Julia wrapper of the [Concorde TSP Solver](http://www.math.uwaterloo.ca/tsp/concorde/index.html).
- [LKH.jl](https://github.com/chkwon/LKH.jl): Julia wrapper of the [LKH heuristic solver](http://webhotel4.ruc.dk/~keld/research/LKH/).
- [TSPLIB.jl](https://github.com/matago/TSPLIB.jl): Reads [TSPLIB-format](http://webhotel4.ruc.dk/~keld/research/LKH/LKH-2.0/DOC/TSPLIB_DOC.pdf) files (`*.tsp`)
- [CVRPLIB.jl](https://github.com/chkwon/CVRPLIB.jl): Reads TSPLIB-format files from [CVRPLIB](http://vrp.atd-lab.inf.puc-rio.br/index.php/en/)
- [TravelingSalesmanExact.jl](https://github.com/ericphanson/TravelingSalesmanExact.jl): Julia implementation of [Dantzig, Fulkerson, and Johnson's Cutting-Plane Method](https://doi.org/10.1287/opre.2.4.393).
