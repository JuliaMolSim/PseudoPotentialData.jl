using PseudoLibraries
using Test

@testset "PseudoLibraries.jl" begin
    @testset "Test one library can be loaded" begin
        pseudokey = "pd_nc_sr_lda_stringent_0.4.1_upf"
        library = PseudoLibrary(pseudokey)
        @test library.pseudokey == pseudokey
        @test library.extension == "upf"
        @test library.functional == "lda"
        @test library.version == v"0.4.1"

        file = pseudofile("pd_nc_sr_lda_stringent_0.4.1_upf", :Si)
        @test basename(file) == "Si.upf"
        @test file == pseudofile(library, :Si)
        @test file == library[:Si]

        @test_throws KeyError library[:Uun]
        @test_throws KeyError pseudofile(library, :Uun)
        @test_throws KeyError pseudofile(library, :Uun)
    end

    @testset "Test all libraries can be loaded" begin
        for pseudokey in PseudoLibraries.available_identifiers()
            library = PseudoLibrary(pseudokey)
            @test library.pseudokey == pseudokey
        end
    end
end
