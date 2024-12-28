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
function family_identifiers()
    artifact_file = find_artifacts_toml(@__FILE__)
    @assert !isnothing(artifact_file)
    sort(collect(keys(TOML.parsefile(artifact_file))))
end

"""The list of all known pseudopotential families."""
const families = map(PseudoFamily, family_identifiers())

end
