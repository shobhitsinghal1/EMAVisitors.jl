# EMAVisitors.jl

EMAVisitors.jl is a Julia package for managing seminar schedules, members, and generating LaTeX documents for the Energy and Markets Analytic (EMA) group at DTU.

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/licioromao/EMAVisitors.jl.git")
```

## Quick Start

```julia
using EMAVisitors

# Set up configuration (optional)
EMAVisitors.set_path_to_excel("/path/to/talk-info.xlsx")
EMAVisitors.set_path_output_dir("/path/to/output")

# Generate the LaTeX schedule and merge CVs
EMAVisitors.generate_latex_schedule()
```

## Configuration

See the Configuration section below for details on setting file paths and other options.

## Further Reading

- [Tutorials](tutorials.md)
- [API Reference](api.md)
- [Contributing](contributing.md)
