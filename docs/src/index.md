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
file of the [stringent pseudodojo](http://www.pseudo-dojo.org/) pseudopotential
for LDA pseudopotentials (referred to by the identifier `dojo.nc.sr.lda.v0_4_1.oncvpsp3.standard.upf`)
and places the full path to the downloaded pseudopotential file into the `filename` variable:

```@example index-example
using PseudoPotentialData
identifier = "dojo.nc.sr.lda.v0_4_1.oncvpsp3.standard.upf"
family = PseudoFamily(identifier)
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

A `PseudoFamily` is furthermore an `AbstractDict{Symbol,String}`
for the mapping of element symbol to file path, e.g. one can perform
index lookup
```@example index-example
family[:Si]
```
or iterate over pairs
```@example index-example
for (k, v) in family
   println(k, " => ", v)
   break
end
```

## Available keys and naming convention
A list of available pseudopotential identifiers is available as
```@example index-example
PseudoPotentialData.family_identifiers()
```

The naming convention is as that each pseudo family name consists
of a list of fields, which are concatenated using a `.` (dot).
These are:
1. An identifier for the pseudo family (like `dojo` for the [PseudoDojo](http://www.pseudo-dojo.org/) family of potentials.
2. The type of pseudopotential (`nc`: norm-conserving, `us`: ultrasoft, `paw`: projected  augmented wave)
3. Details on the level of relativistic effects employed when generating the pseudo (`fr`: Full relativistic, `sr`: Scalar relativistic, `nr`: No relativistic)
4. The functional for which the pseudopotential was prepared
5. The version of the pseudopotential construction (with version points replaced by underscores)
6. The program used to generate the pseudopotential
7. Some additional comments specifying the pseudopotential.
   E.g. for PseudoDojo potentials there is usually a `stringent` version
   (requiring slightly larger cutoffs) and a `standard` version being a bit softer.
8. The format of the pseudopotential files in this library.

More details on the meaning of these keys
will be provided at a later stage.
Some information is also available in the README of the
[PseudoLibrary](https://github.com/JuliaMolSim/PseudoLibrary/blob/7c4b71a3b9d70a229d757aa6d546ef22b83a85a9/README.md)
repository.

## Interface

```@autodocs
Modules = [PseudoPotentialData]
```
