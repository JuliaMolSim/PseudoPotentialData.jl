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
(referred to by the identifier `dojo.nc.sr.lda.v0_4_1.oncvpsp3.standard.upf`)
and places the full path to the downloaded pseudopotential file
into the `filename` variable:

```julia
using PseudoPotentialData
identifier = "dojo.nc.sr.lda.v0_4_1.oncvpsp3.standard.upf"
family = PseudoFamily(identifier)
filename = family[:Si]
```

For a list of available identifiers see
```julia
PseudoPotentialData.family_identifiers()
```
Details on the naming convention of these keys and their respective
meaning provides the [PseudoPotentialData documenation](https://juliamolsim.github.io/PseudoPotentialData.jl/).
