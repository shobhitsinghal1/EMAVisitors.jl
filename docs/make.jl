using Documenter, EMAVisitors

makedocs(
    sitename = "EMAVisitors.jl",
    authors = "EMA team",
    modules = [EMAVisitors],
    pages = [
        "Home" => "index.md",
        "Tutorials" => "tutorials.md",
        "API Reference" => "api.md",
        "Contributing" => "contributing.md",
    ],
    checkdocs = true,
    format = Documenter.HTML(),
)