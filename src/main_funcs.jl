"""
    parse_members(path_to_file::String; others=false)

Parses member data from an Excel file and writes it to a CSV file. The sheet and output file depend on the `others` flag. Uses the global `Ref` variables `PATH_TO_EMA_MEMBERS[]` and `PATH_TO_OTHER_MEMBERS[]` for output paths.

# Arguments
- `path_to_file::String`: Path to the Excel file containing member data.

# Keyword Arguments
- `others::Bool=false`: If `false`, reads from the "ema-members" sheet and writes to `PATH_TO_EMA_MEMBERS[]`; if `true`, reads from the "other-members" sheet and writes to `PATH_TO_OTHER_MEMBERS[]`.

# Returns
- Nothing. Prints a success or error message.
"""
function parse_members(path_to_file::String; others=false)
    try
        if !others 
            members = DataFrame(XLSX.readtable(path_to_file, "ema-members", "A:C"))
            CSV.write(PATH_TO_EMA_MEMBERS[], members)
            println("File successfully save as $(PATH_TO_EMA_MEMBERS[])")
        else
            members = DataFrame(XLSX.readtable(path_to_file, "other-members", "A:C"))
            CSV.write(PATH_TO_OTHER_MEMBERS[], members)
            println("File successfully save as $(PATH_TO_OTHER_MEMBERS[])")
        end
    catch e
        println("Error while saving the file: ", e)
    end
end

"""
    parse_schedule(path_to_schedule::String)

Parses the talk schedule from an Excel file and writes it to a CSV file. Uses the global `OUTPUT_DIR[]` for the output directory and saves as "talk-schedule.csv".

# Arguments
- `path_to_schedule::String`: Path to the Excel file containing the talk schedule.

# Returns
- The `DataFrame` containing the talk schedule if successful, otherwise prints an error message.
"""
function parse_schedule(path_to_schedule::String) 
    talk_schedule = DataFrame(XLSX.readtable(path_to_schedule, "talk-schedule", "A:L"))
    try
        CSV.write(joinpath(OUTPUT_DIR[], "talk-schedule.csv"), talk_schedule)
        println("File successfully save as $(joinpath(OUTPUT_DIR[], "talk-schedule.csv"))")
        return talk_schedule
    catch e
        println("Error while saving the file: ", e)
    end
end

"""
    create_schedule()

Creates a seminar schedule and speaker information from the talk schedule CSV file. Reads the file specified by the global `PATH_TO_TALK_SCHEDULE[]`, processes the data, and returns the speaker and a vector of day schedules.

# Returns
- `SpeakerName`: The speaker with seminar and visit details.
- `Vector{Union{DaySchedule,Nothing}}`: A vector of day schedules for the visit period.

# Errors
Throws an error if the visit duration is greater than 3 days, if the talk schedule file does not exist, if a member is not found, or if there are too many members scheduled for a day.
"""
function create_schedule()
    talk_schedule = isfile(PATH_TO_TALK_SCHEDULE[]) ? CSV.read(PATH_TO_TALK_SCHEDULE[], DataFrame) : error("File $(PATH_TO_TALK_SCHEDULE[]) does not exist")

    n = String.(split(talk_schedule[1,"Speakers' name"], ' ', limit=2))
    email = talk_schedule[1,"Email"]
    startingdate = talk_schedule[1,"Starting date"]
    duration = talk_schedule[1,"Visit duration"]
    if duration > 3
        error("Visit duration must be less than or equal to 3 days. Current duration: $duration days.")
    end
    host = talk_schedule[1,"Host"]
    affiliation = talk_schedule[1,"Affiliation"]

    hotel = collect(skipmissing(talk_schedule[:,"Accommodation"])) |> _process_accommodation

    tmp_seminar = collect(skipmissing(talk_schedule[:,"Seminar"]))
    seminar = _process_seminar(tmp_seminar)

    dtu_members = get_all_dtu_members()
    host = find_dtu_member(dtu_members, host)

    speaker = SpeakerName(n[1], n[2], email, affiliation, Date(startingdate), duration, host, seminar, hotel)

    tmp_m = String.(talk_schedule[:,"Members interested in meeting"])
    members = Vector{DtuMember}(undef, length(tmp_m))
    for (i, member_name) in enumerate(tmp_m)
        if !isempty(member_name)
            members[i] = find_dtu_member(dtu_members, member_name)
        else
            error("Member $(member_name) not found in the list of DTU members.")
        end
    end

    tmp_time = String.(talk_schedule[:, "Time"])
    time = _process_meeting_time(tmp_time)

    rooms = String.(talk_schedule[:,"Room"])

    dates = talk_schedule[:,"Date"]
    visit_period = collect(startdate(speaker):Day(1):(startdate(speaker) + Day(visitduration(speaker) - 1)))

    day_schedules = Vector{Union{DaySchedule,Nothing}}(nothing, length(visit_period))

    for (jdx, d) in enumerate(visit_period) 

        idx = findall(η -> η == d, dates)
        
        if !isempty(idx)
            members_today = members[idx]
            if length(members_today) > 7
                error("Too many members on day $(Date(d)): $(length(members_today)). Maximum allowed is 7.")
            end
            times_today = time[idx]
            rooms_today = rooms[idx]

            day_schedules[jdx] = DaySchedule(members_today, Date(d), times_today, rooms_today)
        end

    end

    return speaker, day_schedules

end
