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

        file = pseudofile("pd_nc_sr_lda_stringent_0.4.1_upf", :Si)
        @test basename(file) == "Si.upf"
        @test file == pseudofile(family, :Si)
        @test file == family[:Si]

        files = pseudofile.(family, [:Si, :Si])
        @test all(isequal(file), files)

        @test_throws KeyError pseudofile(family, :Uun)
        @test_throws KeyError family[:Uun]
        @test_throws KeyError pseudofile(identifier, :Uub)
    end

    @testset "Test all libraries can be loaded" begin
        for identifier in PseudoPotentialData.family_identifiers()
            family = PseudoFamily(identifier)
            @test family.identifier == identifier
        end
    end
end
