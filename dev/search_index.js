var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = PseudoPotentialData","category":"page"},{"location":"#PseudoPotentialData","page":"Home","title":"PseudoPotentialData","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Enables programmatic access to standard pseudopotential libraries for solid-state calculations. In using this library the combination of a string identifier and the element symbol provides a unique and reproducible mapping to a pseudopotential file. Moreover in case the pseudopotential file happens to be missing on the computer Julia's artifact system takes care to automatically download it as needed.","category":"page"},{"location":"#Basic-usage","page":"Home","title":"Basic usage","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"For example, the following code automatically downloads the pseudopotential file of the standard pseudodojo pseudopotential for LDA pseudopotentials (referred to by the identifier dojo.nc.sr.lda.v0_4_1.standard.upf) and places the full path to the downloaded pseudopotential file into the filename variable:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using PseudoPotentialData\nfamily = PseudoFamily(\"dojo.nc.sr.lda.v0_4_1.standard.upf\")\nfilename = pseudofile(family, :Si)","category":"page"},{"location":"","page":"Home","title":"Home","text":"As you see this will be a string such as /home/user/.julia/artifacts/56094b8162385233890d523c827ba06e07566079/Si.upf, which luckily you don't usually have to know or remember. Note, further that this path may differ between computers, julia versions etc. It is therefore highly recommended to use the above mechanism based on identfier and element symbol instead of hard-coding the expanded path in user scripts.","category":"page"},{"location":"","page":"Home","title":"Home","text":"For multiple elements you can similarly use","category":"page"},{"location":"","page":"Home","title":"Home","text":"pseudofile.(family, [:C, :Si])","category":"page"},{"location":"","page":"Home","title":"Home","text":"A PseudoFamily struct is furthermore an AbstractDict{Symbol,String} for the mapping of element symbol to file path, e.g. one can perform index lookup","category":"page"},{"location":"","page":"Home","title":"Home","text":"family[:Si]","category":"page"},{"location":"","page":"Home","title":"Home","text":"iterate over pairs","category":"page"},{"location":"","page":"Home","title":"Home","text":"for (k, v) in family\n   println(k, \" => \", v)\n   break\nend","category":"page"},{"location":"","page":"Home","title":"Home","text":"or get the list of available elements as the list of keys:","category":"page"},{"location":"","page":"Home","title":"Home","text":"collect(keys(family))","category":"page"},{"location":"","page":"Home","title":"Home","text":"Metadata on the pseudopotential family and individual elements in the family can be accessed via the pseudometa function:","category":"page"},{"location":"","page":"Home","title":"Home","text":"pseudometa(family)","category":"page"},{"location":"","page":"Home","title":"Home","text":"or for an element:","category":"page"},{"location":"","page":"Home","title":"Home","text":"pseudometa(family, :Si)","category":"page"},{"location":"","page":"Home","title":"Home","text":"Notably this often contains recommended values of the kinetic energy cutoffs of plane-wave bases. These can be also accessed more conveniently via","category":"page"},{"location":"","page":"Home","title":"Home","text":"recommended_cutoff(family, :Si)","category":"page"},{"location":"","page":"Home","title":"Home","text":"Note, that the Ecut and Ecut_density values are in atomic Hartree units.","category":"page"},{"location":"#Available-pseudopotential-families-and-naming-convention","page":"Home","title":"Available pseudopotential families and naming convention","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A list of available pseudopotential families is available as","category":"page"},{"location":"","page":"Home","title":"Home","text":"PseudoPotentialData.family_identifiers()","category":"page"},{"location":"","page":"Home","title":"Home","text":"The naming convention is as that each pseudo family name consists of a list of fields, which are concatenated using a . (dot). These are:","category":"page"},{"location":"","page":"Home","title":"Home","text":"collection: An identifier for the pseudo collection (like dojo for the PseudoDojo family of potentials.\ntype: The type of pseudopotential (nc: norm-conserving, us: ultrasoft, paw: projected  augmented wave)\nrelativistic: Details on the level of relativistic effects employed when generating the pseudo (fr: Full relativistic, sr: Scalar relativistic, nr: No relativistic)\nfunctional: The functional for which the pseudopotential was prepared\nversion: The version of the pseudopotential construction (with version points replaced by underscores)\nextra: Some additional comments specifying the pseudopotential. E.g. for PseudoDojo potentials there is usually a stringent version (requiring slightly larger cutoffs) and a standard version being a bit softer.\nextension: The file format of the pseudopotential files in this library.","category":"page"},{"location":"","page":"Home","title":"Home","text":"For a given PseudoFamily object the above fields (as well as typically additional metadata information) can also be accessed via the pseudometa function as indicated above.","category":"page"},{"location":"","page":"Home","title":"Home","text":"More details on the available pseudopotential families is given in the PseudoLibrary repository, which manages the data underlying this package.","category":"page"},{"location":"#Interface","page":"Home","title":"Interface","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Modules = [PseudoPotentialData]","category":"page"},{"location":"#PseudoPotentialData.families","page":"Home","title":"PseudoPotentialData.families","text":"Dictionary from pseudopotential identifiers to respective PseudoLibrary instances. Note, that in the REPL typing PseudoPotentialData.families[\"dojo. <Tab> allows to find the pseudofamily identifier by Tab completion.\n\n\n\n\n\n","category":"constant"},{"location":"#PseudoPotentialData.PseudoFamily-Tuple{AbstractString}","page":"Home","title":"PseudoPotentialData.PseudoFamily","text":"PseudoFamily(identifier::AbstractString) -> PseudoFamily\n\n\nConstruction of a PseudoFamily from a identifier representing the pseudopotential family to use. For a list of valid identifier, see family_identifiers. A PseudoFamily is an `AbstractDict{Symbol,String} mapping from an element symbol to the full path of the pseudopotential file.\n\n\n\n\n\n","category":"method"},{"location":"#PseudoPotentialData.artifact_directory-Tuple{PseudoFamily}","page":"Home","title":"PseudoPotentialData.artifact_directory","text":"artifact_directory(family::PseudoFamily) -> String\n\n\nReturn the directory containing the pseudo files. This downloads the artifact if necessary.\n\n\n\n\n\n","category":"method"},{"location":"#PseudoPotentialData.family_identifiers-Tuple{}","page":"Home","title":"PseudoPotentialData.family_identifiers","text":"family_identifiers() -> Vector{String}\n\n\nGet the list of available pseudopotential family identifiers.\n\n\n\n\n\n","category":"method"},{"location":"#PseudoPotentialData.pseudofile-Tuple{PseudoFamily, Symbol}","page":"Home","title":"PseudoPotentialData.pseudofile","text":"pseudofile(family::PseudoFamily, element::Symbol) -> String\n\n\nGet the full path to the file containing the pseudopotential information for a particular element (identified by an atomic symbol) and a particular pseudopotential family.\n\n\n\n\n\n","category":"method"},{"location":"#PseudoPotentialData.pseudometa-Tuple{PseudoFamily, Symbol}","page":"Home","title":"PseudoPotentialData.pseudometa","text":"pseudometa(\n    family::PseudoFamily,\n    element::Symbol\n) -> Dict{String, Any}\n\n\nReturn collection of metadata of the pseudopotential identified by this family and element.\n\n\n\n\n\n","category":"method"},{"location":"#PseudoPotentialData.pseudometa-Tuple{PseudoFamily}","page":"Home","title":"PseudoPotentialData.pseudometa","text":"pseudometa(family::PseudoFamily) -> Dict{String, Any}\n\n\nReturn collection of metadata of the pseudofamily.\n\n\n\n\n\n","category":"method"},{"location":"#PseudoPotentialData.recommended_cutoff-Tuple{PseudoFamily, Symbol}","page":"Home","title":"PseudoPotentialData.recommended_cutoff","text":"recommended_cutoff(\n    family::PseudoFamily,\n    element::Symbol\n) -> NamedTuple{(:Ecut, :supersampling, :Ecut_density), <:Tuple{Union{Missing, Float64}, Union{Missing, Float64}, Union{Missing, Float64}}}\n\n\nReturn the recommended kinetic energy cutoff, supersampling and density cutoff for the pseudopotential indentified by this family and element. Ecut and Ecut_density are returned in Hartree.\n\n\n\n\n\n","category":"method"}]
}
