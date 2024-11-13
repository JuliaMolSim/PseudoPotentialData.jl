struct PseudoFamily
    identifier::String
    # metadata
    extension::String   # Filename expected as $(symbol).$(extension)
    functional::String  # DFT functional keyword (or "" if unspecified)
    version::VersionNumber
    # TODO More things will probably follow
    #    - Type of pseudisation (norm-conserving, PAW, ...)
    #    - References to papers describing these pseudopotentials
    #    - Elements available
end

"""
Construction of a PseudoFamily from a `identifier` representing
the pseudopotential family to use.
"""
function PseudoFamily(identifier::AbstractString)
    artifact_file = find_artifacts_toml(@__FILE__)
    @assert !isnothing(artifact_file)
    meta = artifact_meta(identifier, artifact_file)
    isnothing(meta) && throw(ArgumentError("Invalid pseudo identifier: $identifier"))
    PseudoFamily(identifier,
                 meta["extension"],
                 meta["functional"],
                 VersionNumber(meta["version"]))
end

Base.Broadcast.broadcastable(l::PseudoFamily) = Ref(l)
Base.getindex(family::PseudoFamily, element::Symbol) = pseudofile(family, element)


"""Get the list of available pseudopotential family identifiers."""
function family_identifiers()
    artifact_file = find_artifacts_toml(@__FILE__)
    @assert !isnothing(artifact_file)
    collect(keys(TOML.parsefile(artifact_file)))
end

"""The list of all known pseudopotential families."""
const families = map(PseudoFamily, family_identifiers())


"""
Return the directory containing the pseudo files.
This downloads the artifact if necessary.
"""
artifact_directory(family::PseudoFamily) = (@artifact_str "$(family.identifier)")

"""
Get the full path to the file containing the pseudopotential information
for a particular element and a particular pseudopotential `family`.
The family can be specified as an identifier or an object.
"""
function pseudofile(family::PseudoFamily, element::Symbol)
    file = joinpath(artifact_directory(family), "$(element)." * family.extension)
    isfile(file) || throw(KeyError(element))
    file
end
function pseudofile(family::AbstractString, element::Symbol)
    pseudofile(PseudoFamily(family), element)
end
