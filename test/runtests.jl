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

   M = rand(1:9, 300, 300)
   M = M + M'
   for i in 1:300
    M[i, i] = 0
   end
   solve_tsp(M)

   M = rand(1:9, 100, 100)
   @test_throws ErrorException solve_tsp(M)
end