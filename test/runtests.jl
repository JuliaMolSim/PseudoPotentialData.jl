using PseudoPotentialData
using Test

@testset "PseudoPotentialData.jl" begin
    @testset "Test one family can be loaded" begin
        identifier = "dojo.nc.sr.lda.v0_4_1.oncvpsp3.stringent.upf"
        family = PseudoFamily(identifier)
        @test family.identifier == identifier
        @test family.extension  == "upf"
        @test family.functional == "lda"
        @test family.version == v"0.4.1"

        file = pseudofile(family, :Si)
        @test basename(file) == "Si.upf"
        @test file == family[:Si]

        files = pseudofile.(family, [:Si, :Si])
        @test all(isequal(file), files)

        @test_throws KeyError pseudofile(family, :Uun)
        @test_throws KeyError family[:Uun]
    end

    @testset "Test all libraries can be loaded" begin
        for identifier in PseudoPotentialData.family_identifiers()
            family = PseudoFamily(identifier)
            @test family.identifier == identifier
        end
    end

    @testset "Family objects have a pseudo for standard elements" begin
        for identifier in PseudoPotentialData.family_identifiers()
            family = PseudoFamily(identifier)
            @test isfile(family[:Si])
        end
    end

    @testset "Dict interface of PseudoFamily" begin
        family = PseudoFamily("dojo.nc.sr.pbe.v0_4_1.oncvpsp3.stringent.upf")
        @test length(family) == 72
        @test   :Si  in keys(family)
        @test !(:Uub in keys(family))
        @test  haskey(family, :Si)
        @test !haskey(family, :Uub)

        basedir = PseudoPotentialData.artifact_directory(family)
        @test joinpath(basedir, "Si.upf") in values(family)
        @test family[:Si] == joinpath(basedir, "Si.upf")
    end

    @testset "Printing of family objects" begin
        io = IOBuffer()
        show(io, PseudoFamily("dojo.nc.sr.pbe.v0_4_1.oncvpsp3.stringent.upf"))
        @test occursin("PseudoFamily", String(take!(io)))
    end
end
