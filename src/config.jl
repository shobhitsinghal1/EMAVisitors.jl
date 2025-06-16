
# Variables where paths to files are stored and read
const PATH_TO_EXCEL = Ref(joinpath(homedir(), "Documents", "talk-info.xlsx"))
const PATH_TO_EMA_MEMBERS = Ref(joinpath(homedir(), "Documents", "ema-members.csv"))
const PATH_TO_OTHER_MEMBERS = Ref(joinpath(homedir(), "Documents", "other-members.csv"))
const PATH_TO_TALK_SCHEDULE = Ref(joinpath(homedir(), "Documents", "talk-schedule.csv"))
const OUTPUT_DIR = Ref(joinpath(homedir(), "Documents", "ema-talks"))

function set_path_to_excel(path::String)
    PATH_TO_EXCEL[] = path
end
function set_path_to_ema_members(path::String)
    PATH_TO_EMA_MEMBERS[] = path
end
function set_path_to_other_members(path::String)
    PATH_TO_OTHER_MEMBERS[] = path
end
function set_path_to_talk_schedule(path::String)
    PATH_TO_TALK_SCHEDULE[] = path
end
function set_path_output_dir(path::String)
    OUTPUT_DIR[] = path
end


function get_path_to_excel()
    return PATH_TO_EXCEL[]
end
function get_path_to_ema_members()
    return PATH_TO_EMA_MEMBERS[]
end
function get_path_to_other_members()
    return PATH_TO_OTHER_MEMBERS[]
end
function get_path_to_talk_schedule()
    return PATH_TO_TALK_SCHEDULE[]
end
function get_path_output()
    return OUTPUT_DIR[]
end

