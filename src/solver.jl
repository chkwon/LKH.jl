

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

function solve_tsp(tsp_file::String; log="off", kwargs...)
    if !isfile(tsp_file)
        error("$(tsp_file) is not a file.")
    end

    name = randstring(10)
    filepath = name * ".tsp"
    cp(tsp_file, filepath)

    write_par(name; kwargs...)
    return _solve_tsp(name; log=log, kwargs...)
end