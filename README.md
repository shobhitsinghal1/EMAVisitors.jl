# EMAVisitors

[![Build Status](https://github.com/licioromao@gmail.com/EMAVisitors.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/licioromao@gmail.com/EMAVisitors.jl/actions/workflows/CI.yml?query=branch%3Amain)

EMAVisitors.jl is a Julia package for managing seminar schedules, members, and generating LaTeX documents for the Energy and Markets Analytic (EMA) group at DTU.

## Installation

To install the package, open the Julia REPL, enter the package manager by typing `]`, and run:

```julia
add https://github.com/licioromao/EMAVisitors.jl.git
```

## Configuration

The package uses several configuration variables and functions (in `config.jl`) to set and get file paths for data and output. You can customize these paths as needed.

### Configuration Functions

- `set_path_to_excel(path::String)`: Set the path to the main Excel file with talk information.
- `set_path_to_ema_members(path::String)`: Set the path to the EMA members CSV file.
- `set_path_to_other_members(path::String)`: Set the path to the other members CSV file.
- `set_path_to_talk_schedule(path::String)`: Set the path to the talk schedule CSV file.
- `set_path_output_dir(path::String)`: Set the path to the output directory for generated files.
- `set_path_dtu_wind_logo(path::String)`: Set the path to the DTU wind logo SVG file.

**Getter functions** are also available (e.g., `get_path_to_excel()`, `get_path_output()`) to retrieve the current paths.

**Example:**
```julia
using EMAVisitors

EMAVisitors.set_path_to_excel("/Users/yourname/Documents/talk-info.xlsx")
EMAVisitors.set_path_output_dir("/Users/yourname/Documents/ema-talks")
```

## Generating the LaTeX Schedule

To generate the LaTeX schedule document and compile it to PDF, use:

```julia
using EMAVisitors

EMAVisitors.generate_latex_schedule()
```

This will:
- Read the configuration and data files.
- Generate a LaTeX file in your output directory.
- Compile the LaTeX file to PDF (requires a working LaTeX installation).

## Requirements

- Julia 1.6 or later
- LaTeX installation with `pdflatex` and required packages (e.g., `svg`, `fontspec`, `xcolor`, etc.)

## License

MIT License
