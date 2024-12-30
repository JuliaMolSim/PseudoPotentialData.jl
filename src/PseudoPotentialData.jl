module PseudoPotentialData
using DocStringExtensions
using Artifacts
using Compat: @compat
using LazyArtifacts
using TOML

@template (FUNCTIONS, METHODS, MACROS) = 
    """
    $(TYPEDSIGNATURES)
    $(DOCSTRING)
    """

export PseudoFamily
export pseudofile, pseudometa, recommended_cutoff
@compat public families
@compat public family_identifiers

include("pseudofamily.jl")

"""Get the list of available pseudopotential family identifiers."""
family_identifiers() = sort(collect(keys(families)))

"""
Dictionary from pseudopotential identifiers to respective `PseudoLibrary` instances.
Note, that in the REPL typing `PseudoPotentialData.families["dojo. <Tab>` allows
to find the pseudofamily identifier by Tab completion.
"""
const families = let
    artifact_file = find_artifacts_toml(@__FILE__)
    @assert !isnothing(artifact_file)
    Dict(id => PseudoFamily(id)
         for id in keys(TOML.parsefile(artifact_file)))
end

end
