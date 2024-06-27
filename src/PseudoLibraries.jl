module PseudoLibraries
using Artifacts
using Compat: @compat
using LazyArtifacts
using TOML

export PseudoLibrary, pseudofile
@compat public available_identifiers

struct PseudoLibrary
    identifier::String
    # metadata
    extension::String   # Filename expected as $(symbol).$(extension)
    functional::String  # Functional keyword (or "" if unspecified)
    version::VersionNumber
    # TODO More things will probably follow
    #    - Referencse to papers describing these pseudopotentials
    #    - Elements available
end

"""
Construction of a PseudoLibrary from a `identifier` representing
the pseudopotential library to use.
"""
function PseudoLibrary(identifier::AbstractString)
    artifact_file = find_artifacts_toml(@__FILE__)
    @assert !isnothing(artifact_file)
    meta = artifact_meta(identifier, artifact_file)
    isnothing(meta) && throw(ArgumentError("Invalid pseudo identifier: $identifier"))
    PseudoLibrary(identifier,
                  meta["extension"],
                  meta["functional"],
                  VersionNumber(meta["version"]))
end

Base.Broadcast.broadcastable(l::PseudoLibrary) = Ref(l)


"""Get the list of available pseudopotential library keys."""
function available_identifiers()
    artifact_file = find_artifacts_toml(@__FILE__)
    @assert !isnothing(artifact_file)
    collect(keys(TOML.parsefile(artifact_file)))
end


"""
Return the directory containing the pseudo files.
This downloads the artifact if necessary.
"""
artifact_directory(library::PseudoLibrary) = (@artifact_str "$(library.identifier)")

"""
Get the full path to the file containing the pseudopotential information
for a particular element and a particular pseudopotential library.
"""
function pseudofile(library::PseudoLibrary, element::Symbol)
    file = joinpath(artifact_directory(library), "$(element)." * library.extension)
    isfile(file) || throw(KeyError(element))
    file
end
function pseudofile(identifier::AbstractString, element::Symbol)
    pseudofile(PseudoLibrary(identifier), element)
end
Base.getindex(library::PseudoLibrary, element) = pseudofile(library, element)

end
