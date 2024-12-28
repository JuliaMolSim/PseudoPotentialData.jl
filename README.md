# PseudoPotentialData

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliamolsim.github.io/PseudoPotentialData.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliamolsim.github.io/PseudoPotentialData.jl/dev/)
[![Build Status](https://github.com/JuliaMolSim/PseudoPotentialData.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/JuliaMolSim/PseudoPotentialData.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/JuliaMolSim/PseudoPotentialData.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaMolSim/PseudoPotentialData.jl)

Package providing programmatic access
to standard pseudopotential data files for solid-state calculations.
The combination of the identifier for the
pseudopotential family and the element
symbol provides a unique and reproducible mapping to a pseudopotential file.
In case the pseudopotential data file happens to be missing on the computer
it will be automatically download.

For example, the following code automatically downloads the pseudopotential
file for silicon of the [standard pseudodojo](http://www.pseudo-dojo.org/)
family for LDA pseudopotentials (referred to by
the identifier `dojo.nc.sr.lda.v0_4_1.standard.upf`)
and places the full path to the downloaded pseudopotential file
into the `filename` variable:

```julia
using PseudoPotentialData
family = PseudoFamily("dojo.nc.sr.lda.v0_4_1.standard.upf")
filename = family[:Si]
```
Some metadata for each pseudopotential family and each file
(including for example recommended cutoffs) are also easily accessible.
See the [PseudoPotentialData documenation](https://juliamolsim.github.io/PseudoPotentialData.jl/)
for more details.
