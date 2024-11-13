module PseudoPotentialData
using Artifacts
using Compat: @compat
using LazyArtifacts
using TOML

export PseudoFamily, pseudofile
@compat public families
@compat public family_identifiers

include("pseudofamily.jl")

end
