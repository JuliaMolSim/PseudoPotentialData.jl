using PseudoLibraries
using Documenter

DocMeta.setdocmeta!(PseudoLibraries, :DocTestSetup, :(using PseudoLibraries); recursive=true)

makedocs(;
    modules=[PseudoLibraries],
    authors="Michael F. Herbst <info@michael-herbst.com> and contributors",
    sitename="PseudoLibraries.jl",
    format=Documenter.HTML(;
        canonical="https://juliamolsim.github.io/PseudoLibraries.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaMolSim/PseudoLibraries.jl",
    devbranch="master",
)
