using LKH
using Test

@testset "LKH.jl" begin
    @testset "Symmetric TSP" begin
        M = [
            0  16   7  14
            16   0   3   5
            7   3   0  16
            14   5  16   0 
        ]
        opt_tour, opt_len = solve_tsp(M)
        @test opt_len == 29    

        opt_tour, opt_len = solve_tsp(M; INITIAL_TOUR_ALGORITHM="GREEDY", RUNS=5)
        @test opt_len == 29    

        M = rand(1:9, 300, 300)
        M = M + M'
        for i in 1:300
            M[i, i] = 0
        end
        solve_tsp(M)
    end

    @testset "Asymmetric TSP" begin
        M = rand(1:9, 100, 100)
        solve_tsp(M)
    end

    @testset "Coordinates" begin
        n_nodes = 10
        x = rand(n_nodes) .* 10000
        y = rand(n_nodes) .* 10000
        opt_tour, opt_len = solve_tsp(x, y; dist="EUC_2D")
        opt_tour, opt_len = solve_tsp(x, y; dist="MAN_2D")
        opt_tour, opt_len = solve_tsp(x, y; dist="MAX_2D")
        opt_tour, opt_len = solve_tsp(x, y; dist="GEO")
    end    

    @testset "TSP Input File" begin
        opt_tour, opt_len = solve_tsp("gr17.tsp")
        @test opt_len == 2085
    end

    @testset "CVRP Input File" begin
        opt_tour, opt_len = solve_tsp("P-n16-k8.vrp")
        @test opt_len == 450
        @show opt_tour

        opt_tour, opt_len = solve_tsp("P-n19-k2.vrp")
        @test opt_len == 212
        @show opt_tour        

        opt_tour, opt_len = solve_tsp("P-n101-k4.vrp", TIME_LIMIT=1)
        @test opt_len >= 681
        @show opt_tour             
    end    
end
