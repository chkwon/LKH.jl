# LKH.jl

[![Build Status](https://github.com/chkwon/LKH.jl/workflows/CI/badge.svg?branch=master)](https://github.com/chkwon/LKH.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/chkwon/LKH.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/chkwon/LKH.jl)

This package provides a Julia wrapper for the [LKH solver](http://webhotel4.ruc.dk/~keld/research/LKH/) for solving Traveling Salesman Problems (TSP).  LKH is Keld Helsgaun's efficient implemtation of the Lin-Kernighan heuristic.


# Usage

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
Available `dist` functions are listed in [`TSPLIB_DOC.pdf`](http://webhotel4.ruc.dk/~keld/research/LKH/LKH-2.0/DOC/TSPLIB_DOC.pdf). (Some may have not been implemented in this package.)

## Using a TSPLIB format file input

Using the [TSPLIB format](http://webhotel4.ruc.dk/~keld/research/LKH/LKH-2.0/DOC/TSPLIB_DOC.pdf):

```julia
using LKH
opt_tour, opt_len = solve_tsp("gr17.tsp")
```

## Passing solver parameters

In all cases, [solver parameters](http://webhotel4.ruc.dk/~keld/research/LKH/LKH-2.0/DOC/LKH-2.0_PARAMETERS.pdf) are passed as keyword arguments.

```julia
opt_tour, opt_len = solve_tsp(M; INITIAL_TOUR_ALGORITHM="GREEDY", RUNS=5)
```
