using PseudoLibraries
using Test

@testset "PseudoLibraries.jl" begin
    @testset "Test one library can be loaded" begin
        identifier = "pd_nc_sr_lda_stringent_0.4.1_upf"
        library = PseudoLibrary(identifier)
        @test library.identifier == identifier
        @test library.extension == "upf"
        @test library.functional == "lda"
        @test library.version == v"0.4.1"

        file = pseudofile("pd_nc_sr_lda_stringent_0.4.1_upf", :Si)
        @test basename(file) == "Si.upf"
        @test file == pseudofile(library, :Si)
        @test file == library[:Si]

        files = pseudofile.(library, [:Si, :Si])
        @test all(isequal(file), files)

        @test_throws KeyError library[:Uun]
        @test_throws KeyError pseudofile(library, :Uun)
        @test_throws KeyError pseudofile(library, :Uun)
    end

    @testset "Test all libraries can be loaded" begin
        for identifier in PseudoLibraries.available_identifiers()
            library = PseudoLibrary(identifier)
            @test library.identifier == identifier
        end
    end
end
