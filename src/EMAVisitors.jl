module EMAVisitors

using XLSX, CSV, DataFrames
using Dates

include("config.jl")
export set_path_to_excel, 
       set_path_to_ema_members, 
       set_path_to_other_members, 
       set_path_to_talk_schedule,
       set_path_output_dir,

       get_path_to_excel, 
       get_path_to_ema_members, 
       get_path_to_other_members, 
       get_path_to_talk_schedule,
       get_path_output

include("types.jl")
include("aux_func.jl")
include("main_funcs.jl")
include("write_latex.jl")



# Write your package code here.

end
