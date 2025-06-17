"""
    find_dtu_member(members::Vector{DtuMember}, query::AbstractString)

Searches for a DTU member in the provided list by first name, last name, email, or full name.

# Arguments
- `members::Vector{DtuMember}`: List of DTU members to search.
- `query::AbstractString`: The search string (can be a name or email).

# Returns
- The matching `DtuMember` if found, otherwise throws an error.

# Example
    member = find_dtu_member(members, "Alice")
"""
function find_dtu_member(members::Vector{DtuMember}, query::AbstractString)
    # Searches for a DTU member by first name, last name, email, or full name.
    # Returns the matching DtuMember or throws an error if not found or ambiguous.
    tmp = filter(m -> m.firstname == query || m.lastname == query || m.email == query || name(m) == query , members)

    if isempty(tmp) || length(tmp) > 1
        error("Error finding member: $query. Either no member found or multiple members found with the same name.")
    else
        return tmp[1]
    end

end

"""
    get_dtu_members(; others=false::Bool)

Reads DTU member data from a CSV file and returns a vector of `DtuMember` objects. Uses the global file path variables defined as `Ref`.

# Keyword Arguments
- `others::Bool=false`: If `false`, reads from `PATH_TO_EMA_MEMBERS[]`; if `true`, reads from `PATH_TO_OTHER_MEMBERS[]`.

# Returns
- `Vector{DtuMember}`: A vector of DTU members read from the file.

# Errors
Throws an error if the specified file does not exist.
"""
function get_dtu_members(;others=false::Bool)
    # Reads DTU member data from a CSV file using the global Ref variables for file paths.
    if !others
        df_members = isfile(PATH_TO_EMA_MEMBERS[]) ? CSV.read(PATH_TO_EMA_MEMBERS[], DataFrame) : error("File $(PATH_TO_EMA_MEMBERS[]) does not exist")
    else
        df_members = isfile(PATH_TO_OTHER_MEMBERS[]) ? CSV.read(PATH_TO_OTHER_MEMBERS[], DataFrame) : error("File $(PATH_TO_OTHER_MEMBERS[]) does not exist")
    end

    number_members = size(df_members)[1]
    members = Vector{DtuMember}(undef, number_members)

    #   Getting the name, last name, and email address of each EMA members
    for (idx,row) in enumerate(eachrow(df_members))
       members[idx] = DtuMember(row[1],row[2],row[3])  
    end

    return members
end

"""
    get_all_dtu_members()

Returns a combined vector of all DTU members from both EMA and other members files.

# Returns
- `Vector{DtuMember}`: All DTU members from both sources.
"""
function get_all_dtu_members()
    # Combines all DTU members from both sources into a single vector.
    return [get_dtu_members(others=false)...,
            get_dtu_members(others=true)...]
end


"""
    _process_meeting_time(times::Vector{String})

Converts a vector of time strings to a vector of tuples of `Time` objects.

# Arguments
- `times::Vector{String}`: Vector of time strings in the format "start - end" (e.g., "9:00 AM - 10:00 AM").

# Returns
- `Vector{Tuple{Time,Time}}`: Vector of (start, end) time tuples.

# Errors
Throws an error if a time entry does not have both start and end times.
"""
function _process_meeting_time(times::Vector{String})
    # Convert time strings to Time objects
    times_processed = Vector{Tuple{Time,Time}}(undef, length(times))
    for (idx,t) in enumerate(times)
        tmp = split(t, " - ")
        @assert length(tmp) == 2 "Each time entry must have a start and end time."
        tmp[1] = tmp[1]*" "*split(tmp[2], " ")[end]  # Ensure both times have the same format 
        times_processed[idx] = (Time(tmp[1], dateformat"I:MM p"), Time(tmp[2], dateformat"I:MM p"))
    end

    return times_processed
end


"""
    _process_seminar(ss::AbstractVector)

Processes a vector of seminar information strings and returns a `Seminar` object.

# Arguments
- `ss::AbstractVector`: Vector of strings describing seminar fields (e.g., "Room: 123", "Title: Talk", etc.).

# Returns
- `Seminar`: A Seminar object constructed from the parsed information.

# Errors
Throws an error if an unknown seminar type is encountered or if time/date formats are invalid.
"""
function _process_seminar(ss::AbstractVector)
    tmp = split.(String.(ss), ":", limit=2)

    room = "" 
    title = "" 
    tt = "" 
    dd = ""

    for (type,info) in tmp
        # println("Type: $type, Info: $info")
        if type == "Room"
            room = lstrip(info)

        elseif type == "Title"
            title = lstrip(info)

        elseif type == "Time"
            tmp_tt = String(lstrip(info))
            tmp_tt = split(tmp_tt, " - ")
            @assert length(tmp_tt) == 2 "Each seminar must have a start and end time."
            tmp_tt[1] = tmp_tt[1]*" "*split(tmp_tt[2], " ")[end]  # Ensure both times have the same format
            tt = (Time(tmp_tt[1], dateformat"I:MM p"), Time(tmp_tt[2], dateformat"I:MM p"))
            # println(typeof(tt))

        elseif type == "Date"
            # println("Date: $info")
            dd = Date(lstrip(info), "mm/dd/yyyy")

        else
            error("Unknown seminar type: $type")
        end
    end

    return Seminar(room, title, tt, dd) 
end


function _process_accommodation(hh::AbstractVector)
    println(hh)
    println(typeof(collect(skipmissing(hh))))
    tmp = split.(String.(hh), ":", limit=2)
    name = ""
    address = ""
    google_maps = ""

    for (type,info) in tmp
        if type == "Name"
            name = lstrip(info)
        elseif type == "Address"
            address = lstrip(info)
        elseif type == "Google Maps"
            google_maps = lstrip(info)
        else
            error("Unknown accommodation type: $type. It should be either 'Name', 'Address', or 'Google Maps'.")
        end
    end

    return Dict("Name" => name, "Address" => address, "Google Maps" => google_maps)
    
end


"""
    _count_pdf_pages(path_to_pdf::String)

Counts the number of pages in a PDF file using the `pdfinfo` command-line tool.

# Arguments
- `path_to_pdf::String`: Path to the PDF file.

# Returns
- `Int`: The number of pages in the PDF.

# Errors
Throws an error if the file does not exist or if the page count cannot be determined.
"""
function _count_pdf_pages(path_to_pdf::String)
    if !isfile(path_to_pdf)
        error("PDF file $path_to_pdf does not exist.")
    end
    cmd = `pdfinfo $(path_to_pdf)`
    out = read(cmd, String)
    for line in split(out, "\n")
        if startswith(line, "Pages:")
            return parse(Int, split(line, ":")[2])
        end
    end
end

"""
    get_CVs(m::Vector{Union{DaySchedule,Nothing}})

Generates a list of CV PDF file paths for all unique members in the provided day schedules, and merges them into a single PDF using `pdftk`.

# Arguments
- `m::Vector{Union{DaySchedule,Nothing}}`: Vector of day schedules.

# Returns
- `Tuple{Vector{String}, String}`: A tuple containing the list of individual CV PDF paths and the path to the merged PDF file.

# Errors
Throws an error if a required PDF file does not exist (currently commented out).
"""
function get_CVs(m::Vector{Union{DaySchedule,Nothing}})
    mkpath(PATH_TO_CVs[])  # Ensure the CVs directory exists
    n = unique(vcat(name.(m)...))
    tmp = map(x -> replace(x, " " => "-"), n)
    tmp = map(x -> lowercase(x), tmp)
    tmp = map(x -> joinpath(PATH_TO_CVs[], x  * "-CV.pdf"), tmp)
    tmp[end] = rstrip(tmp[end])  # Remove trailing space from the last element

    pdfs = Vector{String}(undef, length(tmp))
    for (idx,s) in enumerate(tmp)
        pdfs[idx] = joinpath(PATH_TO_CVs[], s)
        if !isfile(pdfs[idx])
            error("CV file $s does not exist. Please ensure all CVs are available in the CVs directory.")
        end
    end

    tmp_2 = joinpath(PATH_TO_CVs[], "all-CVs.pdf")
    tmp_3 = joinpath(PATH_TO_CVs[], "all-CVs-2.pdf")
    run(`cp $(pdfs[1]) $(tmp_2)`)  # Copy the first PDF to tmp_2
    for ff in pdfs[2:end]
        pdftk_cmd = `pdftk $(tmp_2) $ff cat output $tmp_3` 
        run(pdftk_cmd)
        _tmp = tmp_2
        tmp_2 = tmp_3
        tmp_3 = _tmp
    end

    n_page_2 = _count_pdf_pages(tmp_2)
    n_page_3 = _count_pdf_pages(tmp_3)

    if n_page_2 > n_page_3
        return tmp_2
    else
        return tmp_3
    end

end

function _generate_fake_CVs()
    mkpath(PATH_TO_CVs[])
    dtu_members = get_all_dtu_members()
    dtu_names = name.(dtu_members)

    for n in dtu_names
        content = """
        \\documentclass{article}

        \\begin{document}
            $(n)'s CV 
        \\end{document}
        """
        filename = joinpath(PATH_TO_CVs[], "tmp.tex")
        open(filename, "w") do f
            write(f, content)
        end
        run(`pdflatex -output-directory=$(PATH_TO_CVs) $(filename)`)
        n = replace(n, " " => "-")  # Replace spaces with hyphens for file naming
        n = lowercase(n)  # Convert to lowercase for consistency
        n = n * "-CV.pdf"  # Append "-CV.pdf" to the name
        run(`cp $(joinpath(PATH_TO_CVs[], "tmp.pdf")) $(joinpath(PATH_TO_CVs[], n))`)

    end

    run(`rm $(joinpath(PATH_TO_CVs[], "tmp.tex"))`)
    run(`rm $(joinpath(PATH_TO_CVs[], "tmp.log"))`)
    run(`rm $(joinpath(PATH_TO_CVs[], "tmp.pdf"))`)
    run(`rm $(joinpath(PATH_TO_CVs[], "tmp.aux"))`)


    return dtu_names 

end
