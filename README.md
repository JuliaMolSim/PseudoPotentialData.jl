# PseudoPotentialData

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliamolsim.github.io/PseudoPotentialData.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliamolsim.github.io/PseudoPotentialData.jl/dev/)
[![Build Status](https://github.com/JuliaMolSim/PseudoPotentialData.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/JuliaMolSim/PseudoPotentialData.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/JuliaMolSim/PseudoPotentialData.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaMolSim/PseudoPotentialData.jl)

Package providing programmatic access
to standard pseudopotential data files for solid-state calculations.
The combination of a string identifier for the
pseudopotential family and the element
symbol provides a unique and reproducible mapping to a pseudopotential file.
In case the pseudopotential data file happens to be missing on the computer
it will be automatically download as needed.

For example, the following code automatically downloads the pseudopotential
file for silicon of the [stringent pseudodojo](http://www.pseudo-dojo.org/)
family for LDA pseudopotentials
(referred to by the identifier `pd_nc_sr_lda_stringent_0.4.1_upf`)
and places the full path to the downloaded pseudopotential file
into the `filename` variable:

```julia
using PseudoPotentialData
identifier = "pd_nc_sr_lda_stringent_0.4.1_upf"
family = PseudoFamily(identifier)
filename = pseudofile(family, :Si)
```

For a list of available identifiers see
```julia
PseudoPotentialData.family_identifiers()
```
More details on the meaning of these keys is given
in the README of the
[PseudoLibrary](https://github.com/JuliaMolSim/PseudoLibrary/blob/7c4b71a3b9d70a229d757aa6d546ef22b83a85a9/README.md)
repository.

**Warning:**
The current identifiers for the pseudopotential families is planned to be overhauled.
This will be a breaking change, where the minor version of the package will be bumped.
