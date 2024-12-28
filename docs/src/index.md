```@meta
CurrentModule = PseudoPotentialData
```

# PseudoPotentialData

Enables programmatic access to
standard pseudopotential libraries for solid-state calculations.
In using this library the combination of a string identifier and the element
symbol provides a unique and reproducible mapping to a pseudopotential file.
Moreover in case the pseudopotential file
happens to be missing on the computer Julia's artifact system takes
care to automatically download it as needed.

## Basic usage

For example, the following code automatically downloads the pseudopotential
file of the [standard pseudodojo](http://www.pseudo-dojo.org/) pseudopotential
for LDA pseudopotentials (referred to by the identifier `dojo.nc.sr.lda.v0_4_1.standard.upf`)
and places the full path to the downloaded pseudopotential file into the `filename` variable:

```@example index-example
using PseudoPotentialData
family = PseudoFamily("dojo.nc.sr.lda.v0_4_1.standard.upf")
filename = pseudofile(family, :Si)
```
As you see this will be a string such as
`/home/user/.julia/artifacts/56094b8162385233890d523c827ba06e07566079/Si.upf`,
which luckily you don't usually have to know or remember.
Note, further that this path may differ between computers,
julia versions etc.
It is therefore highly recommended to use the above mechanism
based on `identfier` and element symbol instead of hard-coding
the expanded path in user scripts.

For multiple elements you can similarly use
```@example index-example
pseudofile.(family, [:C, :Si])
```

A [`PseudoFamily`](@ref) struct is furthermore an `AbstractDict{Symbol,String}`
for the mapping of element symbol to file path, e.g. one can perform
index lookup
```@example index-example
family[:Si]
```
iterate over pairs
```@example index-example
for (k, v) in family
   println(k, " => ", v)
   break
end
```
or get the list of available elements as the list of keys:
```@example index-example
collect(keys(family))
```

Metadata on the pseudopotential family and individual elements
in the family can be accessed via the [`pseudometa`](@ref) function:
```@example index-example
pseudometa(family)
```
or for an element:
```@example index-example
pseudometa(family, :Si)
```
Notably this often contains recommended values of the kinetic energy
cutoffs of plane-wave bases. These can be also accessed more conveniently via
```@example index-example
recommended_cutoff(family, :Si)
```
Note, that the `Ecut` and `Ecut_density` values are in atomic Hartree units.

## Available pseudopotential families and naming convention
A list of available pseudopotential families is available as
```@example index-example
PseudoPotentialData.family_identifiers()
```

The naming convention is as that each pseudo family name consists
of a list of fields, which are concatenated using a `.` (dot).
These are:
1. `collection`: An identifier for the pseudo collection (like `dojo` for the [PseudoDojo](http://www.pseudo-dojo.org/) family of potentials.
2. `type`: The type of pseudopotential (`nc`: norm-conserving, `us`: ultrasoft, `paw`: projected  augmented wave)
3. `relativistic`: Details on the level of relativistic effects employed when generating the pseudo (`fr`: Full relativistic, `sr`: Scalar relativistic, `nr`: No relativistic)
4. `functional`: The functional for which the pseudopotential was prepared
5. `version`: The version of the pseudopotential construction (with version points replaced by underscores)
6. `extra`: Some additional comments specifying the pseudopotential.
   E.g. for PseudoDojo potentials there is usually a `stringent` version
   (requiring slightly larger cutoffs) and a `standard` version being a bit softer.
7. `extension`: The file format of the pseudopotential files in this library.

For a given [`PseudoFamily`](@ref) object the above fields
(as well as typically additional metadata information) can also be
accessed via the [`pseudometa`](@ref) function as indicated above.

More details on the available pseudopotential families is given in the
[PseudoLibrary](https://github.com/JuliaMolSim/PseudoLibrary)
repository, which manages the data underlying this package.

## Interface

```@autodocs
Modules = [PseudoPotentialData]
```
