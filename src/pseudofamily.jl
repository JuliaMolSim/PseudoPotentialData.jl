struct PseudoFamily <: AbstractDict{Symbol,String}
    identifier::String
    #
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
the pseudopotential family to use. For a list of valid identifier,
see [`family_identifiers`](@ref).
A `PseudoFamily` is an `AbstractDict{Symbol,String} mapping from
an element symbol to the full path of the pseudopotential file.
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

function Base.show(io::IO, family::PseudoFamily)
    print(io, "PseudoFamily(\"$(family.identifier)\")")
end
Base.show(io::IO, ::MIME"text/plain", family::PseudoFamily) = show(io, family)

#
# Helper functions (not exported)
#

"""
Return the directory containing the pseudo files.
This downloads the artifact if necessary.
"""
artifact_directory(family::PseudoFamily) = (@artifact_str "$(family.identifier)")

"""Return the list of all pseudopotential files in the artifact"""
function available_elements(family::PseudoFamily)
    # TODO Once this is part of the metadata, do this without downloading
    files = filter!(endswith(family.extension),
                    readdir(artifact_directory(family)))
    map(files) do file
        base, _ = splitext(file)
        Symbol(base)
    end
end

"""
Get the full path to the file containing the pseudopotential information
for a particular `element` (identified by an atomic symbol) and a particular
pseudopotential `family`.
"""
pseudofile(family::PseudoFamily, element::Symbol) = family[element]

#
# AbstractDict interface
#

Base.keys(family::PseudoFamily) = available_elements(family)
Base.length(family::PseudoFamily) = length(available_elements(family))

function Base.getindex(family::PseudoFamily, element::Symbol)
    file = joinpath(artifact_directory(family), "$(element)." * family.extension)
    isfile(file) || throw(KeyError(element))
    file
end

function Base.iterate(family::PseudoFamily, state::Int=0)
    if state == length(family)
        return nothing
    else
        element = available_elements(family)[state+1]
        return (element => family[element], state+1)
    end
end
