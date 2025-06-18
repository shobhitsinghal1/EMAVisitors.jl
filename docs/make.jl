using Documenter, EMAVisitors

makedocs(
    sitename = "EMAVisitors.jl",
    authors = "EMA team",
    edit_branch = "main",  # Set to your default branch ("main" or "master")
    repo = Documenter.Remotes.GitHub("licioromao", "EMAVisitors.jl"),
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