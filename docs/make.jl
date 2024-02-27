using TeleQuEST
using Documenter

DocMeta.setdocmeta!(TeleQuEST, :DocTestSetup, :(using TeleQuEST); recursive=true)

makedocs(;
    modules=[TeleQuEST],
    authors="Jonathan Miller <jonathan.miller@fieldofnodes.com> and contributors",
    sitename="TeleQuEST.jl",
    format=Documenter.HTML(;
        canonical="https://fieldofnodes.github.io/TeleQuEST.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/fieldofnodes/TeleQuEST.jl",
    devbranch="main",
)
