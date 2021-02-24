using LKH
using Test


@testset "LKH.jl" begin
    M = [
        0  16   7  14
       16   0   3   5
        7   3   0  16
       14   5  16   0 
   ]
   opt_tour, opt_len = solve_tsp(M)
   @test opt_len == 29    


   M = rand(1:9, 100, 100)
   @test_throws ErrorException solve_tsp(M)
end