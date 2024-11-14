using PseudoPotentialData
using Test

@testset "PseudoPotentialData.jl" begin
    @testset "Test one family can be loaded" begin
        identifier = "pd_nc_sr_lda_stringent_0.4.1_upf"
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

    @testset "Dict interface of PseudoFamily" begin
        identifier = "pd_nc_sr_pbe_stringent_0.4.1_upf"
        family = PseudoFamily(identifier)
        @test length(family) == 72
        @test   :Si  in keys(family)
        @test !(:Uub in keys(family))
        @test  haskey(family, :Si)
        @test !haskey(family, :Uub)

        basedir = PseudoPotentialData.artifact_directory(family)
        @test joinpath(basedir, "Si.upf") in values(family)
        @test family[:Si] == joinpath(basedir, "Si.upf")
    end
end
