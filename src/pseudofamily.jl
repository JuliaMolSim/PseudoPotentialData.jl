struct PseudoFamily <: AbstractDict{Symbol,String}
    identifier::String
    #
    # metadata
    collection::String        # Pseudo collection this family is from (e.g. "dojo")
    type::String              # Pseudofamily type ("nc", "us", "paw")
    relativistic::String      # Kind of relativistic effects ("fr", "sr")
    functional::String        # DFT functional keyword
    version::VersionNumber    # Version of the pseudofamily
    program::String           # Program used to generate the pseudos
    extra::Vector{String}     # Additional specifiers for this family
    extension::String         # Filename expected as $(symbol).$(extension)
    elements::Vector{Symbol}  # Available elements
    #
    additional_metadata::Dict{String,Any}
    # TODO More things will probably follow
    #    - References to papers describing these pseudopotentials
end

"""
Construction of a PseudoFamily from a `identifier` representing
the pseudopotential family to use. For a list of valid identifier,
see [`family_identifiers`](@ref).
A `PseudoFamily` is an `AbstractDict{Symbol,String} mapping from
an element symbol to the full path of the pseudopotential file.
"""
function PseudoFamily(identifier::AbstractString)
    if occursin(".oncvpsp3.", identifier)
        newid = replace(identifier, ".oncvpsp3." => ".")
        @warn "Identifier $identifier is deprecated. Use $newid instead."
        return PseudoFamily(newid)
    end

    artifact_file = find_artifacts_toml(@__FILE__)
    @assert !isnothing(artifact_file)
    meta = artifact_meta(identifier, artifact_file)
    isnothing(meta) && throw(ArgumentError("Invalid PseudoFamily identifier: $identifier"))

    additional_metadata = Dict{String,Any}()
    for k in keys(meta)
        k in mandatory_family_keys && continue
        k in ("lazy", "git-tree-sha1", "download", "pseudolibrary_version") && continue
        additional_metadata[k] = meta[k]
    end

    PseudoFamily(identifier,
                 meta["collection"],
                 meta["type"],
                 meta["relativistic"],
                 meta["functional"],
                 VersionNumber(meta["version"]),
                 meta["program"],
                 meta["extra"],
                 meta["extension"],
                 Symbol.(meta["elements"]),
                 additional_metadata)
end
Base.Broadcast.broadcastable(l::PseudoFamily) = Ref(l)

function Base.show(io::IO, family::PseudoFamily)
    print(io, "PseudoFamily(\"$(family.identifier)\")")
end
Base.show(io::IO, ::MIME"text/plain", family::PseudoFamily) = show(io, family)

"""
Get the full path to the file containing the pseudopotential information
for a particular `element` (identified by an atomic symbol) and a particular
pseudopotential `family`.
"""
pseudofile(family::PseudoFamily, element::Symbol) = family[element]

"""Return collection of metadata of the pseudofamily."""
function pseudometa(family::PseudoFamily)
    d = copy(family.additional_metadata)
    for k in mandatory_family_keys
        d[k] = getproperty(family, Symbol(k))
    end
    d
end

"""
Return collection of metadata of the pseudopotential
identified by this `family` and `element`.
"""
function pseudometa(family::PseudoFamily, element::Symbol)
    file = joinpath(artifact_directory(family), "$(element).toml")
    isfile(file) || throw(KeyError(element))
    open(TOML.parse, file)
end

"""
Return the recommended kinetic energy cutoff, supersampling and density
cutoff for the pseudopotential indentified by this `family` and `element`.
"""
function recommended_cutoff(family::PseudoFamily, element::Symbol)
    data = pseudometa(family, element)

    Ecut = missing
    supersampling = missing
    Ecut_density = missing
    if haskey(data, "Ecut") && data["Ecut"] > 0
        Ecut = data["Ecut"]
        if haskey(data, "supersampling")
            supersampling = data["supersampling"]
            Ecut_density  = supersampling^2 * Ecut
        end
    end

    (; Ecut, supersampling, Ecut_density)
end

#
# AbstractDict interface
#

Base.keys(family::PseudoFamily)   = family.elements
Base.length(family::PseudoFamily) = length(family.elements)

function Base.getindex(family::PseudoFamily, element::Symbol)
    file = joinpath(artifact_directory(family), "$(element)." * family.extension)
    isfile(file) || throw(KeyError(element))
    file
end

function Base.iterate(family::PseudoFamily, state::Int=0)
    if state == length(family)
        return nothing
    else
        element = family.elements[state+1]
        return (element => family[element], state+1)
    end
end

#
# Helper functions and constants (not exported)
#

# Keys from the Artifact.toml, which are mandatory directly stored in the above struct
const mandatory_family_keys = ("collection", "type", "relativistic", "functional", "version",
                               "program", "extra", "extension", "elements")


"""
Return the directory containing the pseudo files.
This downloads the artifact if necessary.
"""
function artifact_directory(family::PseudoFamily)
    @artifact_str "$(family.identifier)"
end
