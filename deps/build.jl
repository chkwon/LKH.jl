
const LKH_VERSION = "LKH-2.0.9"
const LKH_SRC_URL = "http://webhotel4.ruc.dk/~keld/research/LKH/$(LKH_VERSION).tgz"

const LKH_WIN_EXE_URL = "http://webhotel4.ruc.dk/~keld/research/LKH/LKH-2.exe"

function download_win_exe()
    lkh_exe = joinpath(@__DIR__, "LKH.exe")
    download(LKH_WIN_EXE, lkh_exe)
    return lkh_exe
end

function build_LKH()
    src_tarball = joinpath(@__DIR__, "lkh_src.tgz")
    download(LKH_SRC_URL, src_tarball)
    src_dir = joinpath(@__DIR__, "src")
    run(`tar zxvf $(src_tarball)`)
    cd(LKH_VERSION)
    run(`make`)
    mv("LKH", joinpath(@__DIR__, "LKH"), force=true)

    lkh_exe = joinpath(@__DIR__, "LKH")
    return lkh_exe
end

function download_LKH()
    if Sys.islinux() && Sys.ARCH == :x86_64
        return build_LKH()
    elseif Sys.isapple()
        return build_LKH()
    elseif Sys.iswindows()
        return download_win_exe()
    end
    error("Unsupported operating system. Only 64-bit linux, macOS, and Windows are supported.")
end

function install_LKH()
    executable = get(ENV, "LKH_EXECUTABLE", nothing)
    if !haskey(ENV, "LKH_EXECUTABLE")
        executable = download_LKH()
        ENV["LKH_EXECUTABLE"] = executable
    end

    if executable === nothing
        error("Environment variable `LKH_EXECUTABLE` not found.")
    else
        # pr2392 = joinpath(@__DIR__, LKH_VERSION, "pr2392.par")
        # run(`$(executable) $(pr2392)`)
    end

    open(joinpath(@__DIR__, "deps.jl"), "w") do io
        write(io, "const LKH_EXECUTABLE = \"$(escape_string(executable))\"\n")
    end
end

install_LKH()