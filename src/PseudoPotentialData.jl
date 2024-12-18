module PseudoPotentialData
using Artifacts
using Compat: @compat
using LazyArtifacts
using TOML

export PseudoFamily, pseudofile
@compat public families
@compat public family_identifiers

export available_elements, has_element

include("pseudofamily.jl")

"""Get the list of available pseudopotential family identifiers."""
function family_identifiers()
    artifact_file = find_artifacts_toml(@__FILE__)
    @assert !isnothing(artifact_file)

    # TODO For compatibility already use new keys
    artifactmap_inv = Dict(v => k for (k, v) in artifactmap)
    map(collect(keys(TOML.parsefile(artifact_file)))) do key
        artifactmap_inv[key]
    end
end

"""The list of all known pseudopotential families."""
const families = map(PseudoFamily, family_identifiers())

end
