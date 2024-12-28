using PseudoPotentialData
using Test

@testset "PseudoPotentialData.jl" begin
    @testset "Test one family can be loaded" begin
        identifier = "dojo.nc.sr.lda.v0_4_1.stringent.upf"
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
        family = PseudoFamily("dojo.nc.sr.pbe.v0_4_1.stringent.upf")
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
        family = PseudoFamily("dojo.nc.sr.pbe.v0_4_1.stringent.upf")
        io = IOBuffer()
        show(io, family)
        @test occursin("PseudoFamily", String(take!(io)))

        io = IOBuffer()
        show(io, MIME("text/plain"), family)
        @test occursin("PseudoFamily", String(take!(io)))
    end

    @testset "Pseudometa on families" begin
        family = PseudoFamily("dojo.nc.sr.lda.v0_4_1.stringent.upf")
        meta = pseudometa(family)

        @test meta["functional"]   == "lda"
        @test meta["relativistic"] == "sr"
        @test meta["program"]      == "oncvpsp3"
        @test meta["version"]      == v"0.4.1"
        @test meta["extra"]        == ["stringent"]
        @test meta["extension"]    == "upf"
        @test meta["type"]         == "nc"
        @test meta["collection"]   == "dojo"
        @test meta["pseudodojo_handle"] == "nc-sr-04_pw_stringent_upf"
        @test haskey(meta, "elements")
        @test haskey(meta, "extracted_on")
    end

    @testset "Pseudometa on pseudodojo element" begin
        family = PseudoFamily("dojo.nc.sr.lda.v0_4_1.standard.upf")
        meta = pseudometa(family, :Si)

        @test haskey(meta, "rcut")
        @test meta["Ecut"] == 18.0
        @test meta["supersamping"] == 2.0
        @test meta["cutoffs_low"   ]["Ecut"] == 14.0
        @test meta["cutoffs_normal"]["Ecut"] == 18.0
        @test meta["cutoffs_high"  ]["Ecut"] == 24.0
        @test meta["cutoffs_low"   ]["supersampling"] == 2.0
        @test meta["cutoffs_normal"]["supersampling"] == 2.0
        @test meta["cutoffs_high"  ]["supersampling"] == 2.0

        cutoffs = recommended_cutoff(family, :Si)
        @test cutoff.Ecut == 18.0
        @test cutoff.supersampling == 2.0
        @test cutoff.Ecut_density == 72.0
    end

    @testset "Pseudometa on cp2k element" begin
        family = PseudoFamily("cp2k.nc.sr.lda.v0_1.semicore.gth")
        meta = pseudometa(family, :Si)
        @test meta["cp2k_filename"] == "Si-q4"
        @test meta["n_valence_electrons"] == 4
        @test haskey(meta, "Ecut")
        @test haskey(meta, "supersampling")
    end

    @testset "Test pseudofiles for all claimed elements exist" begin
        for identifier in PseudoPotentialData.family_identifiers()
            family = PseudoFamily(identifier)
            for element in keys(family)
                @test isfile(family[element])
                @test pseudometa(family, element) isa AbstractDict
            end
        end
    end
end
