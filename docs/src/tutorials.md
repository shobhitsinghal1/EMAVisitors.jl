# This is a Tutorial example

# Tutorials

## Generating a Schedule

This tutorial shows how to generate a seminar schedule and LaTeX document using EMAVisitors.jl.

```julia
using EMAVisitors

# Set up configuration (optional)
EMAVisitors.set_path_to_excel("/path/to/talk-info.xlsx")
EMAVisitors.set_path_output_dir("/path/to/output")

# Generate the LaTeX schedule and merge CVs
EMAVisitors.generate_latex_schedule()
```

## Customizing Output Directory

You can change where files are saved by setting a custom output directory:

```julia
EMAVisitors.set_path_output_dir("/your/custom/path")
```

## Adding Member Data

Prepare your member data in the Excel file specified by `set_path_to_excel`. Make sure the file is formatted as expected by the package.

---

More tutorials coming soon!