# PseudoLibraries

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliamolsim.github.io/PseudoLibraries.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliamolsim.github.io/PseudoLibraries.jl/dev/)
[![Build Status](https://github.com/JuliaMolSim/PseudoLibraries.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/JuliaMolSim/PseudoLibraries.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/JuliaMolSim/PseudoLibraries.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaMolSim/PseudoLibraries.jl)

Package providing programmatic access
to standard pseudopotentials in solid-state calculations.
In using this library the combination of a string identifier and the element
symbol provides a unique and reproducible mapping to a pseudopotential file.
Moreover in case the pseudopotential file
happens to be missing on the computer Julia's artifact system takes
care to automatically download it as needed.

For example, the following code automatically downloads the pseudopotential
file of the [stringent pseudodojo](http://www.pseudo-dojo.org/) pseudopotential
for LDA pseudopotentials (referred to by the identifier `pd_nc_sr_lda_stringent_0.4.1_upf`)
and places the full path to the downloaded pseudopotential file into the `filename` variable:

```julia
using PseudoLibraries
identifier = "pd_nc_sr_lda_stringent_0.4.1_upf"
library = PseudoLibrary(identifier)
filename = pseudofile(library, :Si)
```

For a list of available identifiers see
```julia
PseudoLibraries.available_identifiers()
```
More details on the meaning of these keys is given
in the README of the
[PseudoLibrary](https://github.com/JuliaMolSim/PseudoLibrary/blob/7c4b71a3b9d70a229d757aa6d546ef22b83a85a9/README.md)
repository.

**Warning:**
The current identifiers for the pseudopotential families is planned to be overhauled.
This will be a breaking change, where the minor version of the package will be bumped.
