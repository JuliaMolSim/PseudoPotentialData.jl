using PseudoPotentialData
using Documenter

DocMeta.setdocmeta!(PseudoPotentialData, :DocTestSetup, :(using PseudoPotentialData); recursive=true)

makedocs(;
    modules=[PseudoPotentialData],
    authors="Michael F. Herbst <info@michael-herbst.com> and contributors",
    sitename="PseudoPotentialData.jl",
    format=Documenter.HTML(;
        canonical="https://juliamolsim.github.io/PseudoPotentialData.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaMolSim/PseudoPotentialData.jl",
    devbranch="master",
)
