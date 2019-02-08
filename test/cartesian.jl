# This file is a part of Julia. License is MIT: https://julialang.org/license

@test Base.Cartesian.exprresolve(:(1 + 3)) == 4
ex = Base.Cartesian.exprresolve(:(if 5 > 4; :x; else :y; end))
@test ex.args[2] == QuoteNode(:x)

@test Base.Cartesian.lreplace!("val_col", Base.Cartesian.LReplace{String}(:col, "col", 1)) == "val_1"

# test conversions for CartesianIndex

@testset "CartesianIndex Conversions" begin
    @test convert(Int, CartesianIndex(42)) === 42
    @test convert(Float64, CartesianIndex(42)) === 42.0
    @test convert(Tuple, CartesianIndex(42, 1)) === (42, 1)
    # can't convert higher-dimensional indices to Int
    @test_throws MethodError convert(Int, CartesianIndex(42, 1))
end

@testset "CartesianIndices overflow" begin
    I = CartesianIndices((1:typemax(Int),))
    i = last(I)
    @test iterate(I, i) === nothing

    I = CartesianIndices((1:(typemax(Int)-1),))
    i = CartesianIndex(typemax(Int))
    @test iterate(I, i) === nothing

    I = CartesianIndices((1:typemax(Int), 1:typemax(Int)))
    i = last(I)
    @test iterate(I, i) === nothing

    i = CartesianIndex(typemax(Int), 1)
    @test iterate(I, i) === (CartesianIndex(1, 2), CartesianIndex(1,2))
end

@testset "CartesianRange iteration" begin
    I = CartesianIndices(map(Base.Slice, (2:4, 0:1, 1:1, 3:5)))
    indices = Vector{eltype(I)}()
    for i in I
        push!(indices, i)
    end
    @test length(I) == length(indices)
    @test vec(I) == indices
end
