using Documenter, EMAVisitors
using HTTP

makedocs(
    sitename = "EMAVisitors.jl",
    authors = "EMA team",
    # edit_branch = "main",  # Set to your default branch ("main" or "master")
    repo = Documenter.Remotes.GitHub("licioromao", "EMAVisitors.jl"),
    modules = [EMAVisitors],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md",
        "Tutorials" => "tutorials.md",
        "Contributing" => "contributing.md",
    ],
)


# HTTP.serve(HTTP.FilesHandler("/docs/build"), ip"127.0.0.1", 8000)