"""
    PATH_TO_EXCEL

A `Ref{String}` holding the path to the main Excel file with talk information.
"""
const PATH_TO_EXCEL = Ref(joinpath(homedir(), "Documents", "talk-info.xlsx"))

"""
    OUTPUT_DIR

A `Ref{String}` holding the path to the output directory for generated files.
"""
const OUTPUT_DIR = Ref(joinpath(homedir(), "Documents", "ema-talks"))

"""
    PATH_TO_EMA_MEMBERS

A `Ref{String}` holding the path to the CSV file for EMA members.
"""
const PATH_TO_EMA_MEMBERS = Ref(joinpath(OUTPUT_DIR[], "ema-members.csv"))

"""
    PATH_TO_OTHER_MEMBERS

A `Ref{String}` holding the path to the CSV file for other members.
"""
const PATH_TO_OTHER_MEMBERS = Ref(joinpath(OUTPUT_DIR[], "other-members.csv"))

"""
    PATH_TO_TALK_SCHEDULE

A `Ref{String}` holding the path to the CSV file for the talk schedule.
"""
const PATH_TO_TALK_SCHEDULE = Ref(joinpath(OUTPUT_DIR[], "talk-schedule.csv"))

"""
    PATH_TO_DTU_WIND_LOGO

A `Ref{String}` holding the path to the DTU wind logo SVG file.
"""
const PATH_TO_DTU_WIND_LOGO = Ref(joinpath(OUTPUT_DIR[], "DTU-wind.svg"))


"""
    PATH_TO_CVs

A `Ref{String}` holding the path to the directory containing CV PDF files.
"""
const PATH_TO_CVs = Ref(joinpath(OUTPUT_DIR[], "CVs"))

"""
    set_path_to_excel(path::String)

Set the path to the main Excel file with talk information.
"""
function set_path_to_excel(path::String)
    PATH_TO_EXCEL[] = path
end

"""
    set_path_to_ema_members(path::String)

Set the path to the EMA members CSV file.
"""
function set_path_to_ema_members(path::String)
    PATH_TO_EMA_MEMBERS[] = path
end

"""
    set_path_to_other_members(path::String)

Set the path to the other members CSV file.
"""
function set_path_to_other_members(path::String)
    PATH_TO_OTHER_MEMBERS[] = path
end

"""
    set_path_to_talk_schedule(path::String)

Set the path to the talk schedule CSV file.
"""
function set_path_to_talk_schedule(path::String)
    PATH_TO_TALK_SCHEDULE[] = path
end

"""
    set_path_output_dir(path::String)

Set the path to the output directory for generated files.
"""
function set_path_output_dir(path::String)
    OUTPUT_DIR[] = path
end

"""
    set_path_dtu_wind_logo(path::String)

Set the path to the DTU wind logo SVG file.
"""
function set_path_dtu_wind_logo(path::String)
    PATH_TO_DTU_WIND_LOGO[] = path
end

function set_path_cvs(path::String)
    PATH_TO_CVs[] = path
end

"""
    get_path_to_excel()

Get the path to the main Excel file with talk information.
"""
function get_path_to_excel()
    return PATH_TO_EXCEL[]
end

"""
    get_path_to_ema_members()

Get the path to the EMA members CSV file.
"""
function get_path_to_ema_members()
    return PATH_TO_EMA_MEMBERS[]
end

"""
    get_path_to_other_members()

Get the path to the other members CSV file.
"""
function get_path_to_other_members()
    return PATH_TO_OTHER_MEMBERS[]
end

"""
    get_path_to_talk_schedule()

Get the path to the talk schedule CSV file.
"""
function get_path_to_talk_schedule()
    return PATH_TO_TALK_SCHEDULE[]
end

"""
    get_path_output()

Get the path to the output directory for generated files.
"""
function get_path_output()
    return OUTPUT_DIR[]
end

"""
    get_path_dtu_wind_logo()

Get the path to the DTU wind logo SVG file.
"""
function get_path_dtu_wind_logo()
    return PATH_TO_DTU_WIND_LOGO[]
end

function get_path_cvs()
    return PATH_TO_CVs[]
end


