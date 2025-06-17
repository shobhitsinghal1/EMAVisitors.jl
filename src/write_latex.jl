"""
    print_packages()

Returns the LaTeX preamble and document start, including all required packages and header formatting for the EMA schedule document.

# Returns
- `String`: The LaTeX code for the document preamble and header.
"""
function print_packages()
    return """
    \\documentclass[8pt]{extarticle}
    \\usepackage[landscape, top=1.5cm, left=0.5cm, right=0.5cm]{geometry}
    \\usepackage[absolute,overlay]{textpos}
    \\usepackage{graphicx}
    \\usepackage[notransparent,inkscape=true]{svg}
    \\svgpath{$(OUTPUT_DIR[])}
    \\usepackage{multicol}
    \\usepackage{xcolor}
    \\usepackage{hyperref}

    \\usepackage{fontspec}
    \\usepackage{listings}

    \\setmonofont{JuliaMono-Regular}
    \\setmainfont{JuliaMono}


    % Defining page header
    \\usepackage{fancyhdr}
    \\pagestyle{fancy}
    \\fancyhead{}
    \\renewcommand{\\headrulewidth}{0pt}
    \\fancyhead[L]
    {
        Technical University of Denmark\\\\
        Department of Wind and Energy Systems\\\\
        Energy and Markets Analytic (EMA) 
    }

    \\fancyhead[R]
    {
        \\begin{textblock*}{3cm}(19.5cm, 0.2cm)
            \\includesvg[height=1.5cm]{DTU-wind}
        \\end{textblock*}
    }

    % Adjust space after header
    \\setlength{\\headsep}{2cm} % Change value as needed

    \\begin{document}
        \\begin{center}
    """
    
end

"""
    print_first_column(speaker::SpeakerName, dtu_mem::Vector{DtuMember})

Generates the LaTeX code for the first column of the schedule, including host, contact, and speaker information.

# Arguments
- `speaker::SpeakerName`: The speaker for the visit.
- `dtu_mem::Vector{DtuMember}`: Vector of DTU members for contact info.

# Returns
- `String`: The LaTeX code for the first column.
"""
function print_first_column(speaker::SpeakerName, dtu_mem::Vector{DtuMember})

    n_days = visitduration(speaker)

    if n_days == 3
        col_size = 0.75
    elseif n_days == 2
        col_size = 0.5
    elseif n_days == 1
        col_size = 0.25
    end

    content="""
            \\begin{minipage}[t]{$(0.23)\\textwidth}
                \\begin{flushleft}
                    DTU Lyngby Campus, Building 325 \\\\
                    2800 Kgs. Lyngby \\\\
                    Denmark \\\\

                    \\vspace{0.5cm}
                    $(name(host(speaker))), $(position(host(speaker))) \\\\
                    \\vspace{0.25cm}
                    Jalal Kazempour (head), Professor

                    \\vspace{0.5cm}
                    Contact: $(name(find_dtu_member(dtu_mem,"Josefine"))) \\\\
                    Phone: +45 25 13 05 01 \\\\
                    mail: $(email(find_dtu_member(dtu_mem,"Josefine"))) 

                    \\vspace{3.5cm}
                    $(name(speaker))\\\\
                    $(affiliation(speaker)) \\\\
                

                    \\vspace{4cm}
                    \\textbf{Accomodation:} \\\\
                    Hotel Name: $(hotelname(speaker)), \\\\
                    Address: $(hoteladdress(speaker)), \\\\
                    Maps link \\href{$(hotelmaps(speaker))}{here.} \\\\
                \\end{flushleft}
            \\end{minipage}%
            \\vrule width 1pt
            \\hspace{0.25cm}
            \\begin{minipage}[t]{$(col_size)\\columnwidth}
    """

    return content
    
end

"""
    print_other_columns(speaker::SpeakerName, day_schedules::Vector{Union{DaySchedule,Nothing}}, dtu_mem::Vector{DtuMember})

Generates the LaTeX code for the remaining columns of the schedule, including daily meeting and seminar information for each day of the visit.

# Arguments
- `speaker::SpeakerName`: The speaker for the visit.
- `day_schedules::Vector{Union{DaySchedule,Nothing}}`: The day schedules for the visit.
- `dtu_mem::Vector{DtuMember}`: Vector of DTU members for meeting info.

# Returns
- `Vector{String}`: A vector containing the LaTeX code for each column.
"""
function print_other_columns(speaker::SpeakerName, day_schedules::Vector{Union{DaySchedule,Nothing}}, dtu_mem::Vector{DtuMember})
    col_size = 1/visitduration(speaker)

    tmp_content = ["" for _ in 1:length(day_schedules)]

    for (idx,schedule) in enumerate(day_schedules)
        if schedule === nothing 
            continue
        end

        members_meeting = members(schedule)
        if !isnothing(speaker.seminar) && talkdate(speaker) == date(schedule) 
            info_seminar = name(speaker) => (talktime(speaker), talkroom(speaker))
            members_meeting = (collect(members_meeting)..., info_seminar)
        end

        sorted_members = sort(collect(members_meeting), by = x -> x[2][1][1])
        tmp_content[idx] = """
                    \\begin{minipage}[t]{$(col_size)\\columnwidth}
                        \\begin{flushleft}
                            \\textbf{$(Dates.format(date(schedule), "d u yyyy"))} \\\\
                        \\end{flushleft}
        """

        for (n, (time, room)) in sorted_members 
            start_end_time = Dates.format(time[1], "HH:MM") * " - " * Dates.format(time[2], "HH:MM") * Dates.format(time[2], "p")

            if n == name(speaker) 

                tmp_content[idx] = tmp_content[idx] * """
                            \\begin{minipage}[t]{$(0.45)\\columnwidth}
                                $(start_end_time) \\\\
                                \\textit{(Seminar)}
                            \\end{minipage}%
                            \\begin{minipage}[t]{$(0.55)\\columnwidth}
                                \\textbf{$(name(speaker))} \\\\
                                $(talktitle(speaker)) \\\\
                                $(affiliation(speaker)) \\\\
                                Room: $room \\\\
                            \\end{minipage}
                            \\vspace{0.01cm} \\\\
                """
            else
                dtu_m = find_dtu_member(dtu_mem, n)

                tmp_content[idx] = tmp_content[idx] * """
                            \\begin{minipage}[t]{$(0.45)\\columnwidth}
                                $(start_end_time)
                            \\end{minipage}%
                            \\begin{minipage}[t]{$(0.55)\\columnwidth}
                                $(name(dtu_m)) \\\\
                                $(position(dtu_m)) \\\\
                                $(email(dtu_m)) \\\\
                                Room: $room \\\\
                            \\end{minipage}
                            \\vspace{0.01cm} \\\\
                """
            end

        end

        if idx < length(day_schedules)
            tmp_content[idx] = tmp_content[idx] * """
                    \\end{minipage}%
                    \\vrule width 1pt
                    \\vspace{0.01cm}
                    \\hspace{0.15cm}
            """
        else
            tmp_content[idx] = tmp_content[idx] * """
                        \\end{minipage}%
                        \\vspace{0.01cm}
            """
        end
    end
    return tmp_content
end


"""
    generate_latex_schedule(; CVs::Bool=true)

Generates the full LaTeX schedule document for the visit, writes it to a `.tex` file, and compiles it to PDF. Reads and parses member and schedule data, builds all columns, and saves the output in the directory specified by `OUTPUT_DIR[]`.

# Keyword Arguments
- `CVs::Bool=true`: (Currently unused) Option for including CVs.

# Side Effects
- Writes the LaTeX file to disk and runs `pdflatex` to generate the PDF.
"""
function generate_latex_schedule(; CVs::Bool=true)

    parse_members(PATH_TO_EXCEL[])
    parse_members(PATH_TO_EXCEL[], others=true)
    parse_schedule(PATH_TO_EXCEL[])

    dtu_mem = get_all_dtu_members()
    speaker, dayschedule = create_schedule()


    a = print_packages()
    b = print_first_column(speaker, dtu_mem)
    c = print_other_columns(speaker, dayschedule, dtu_mem)

    n = name(speaker)
    n = replace(n, " " => "-") # Replace spaces with underscores for file naming
    n = lowercase(n) # Convert to lowercase for consistency

    filename = joinpath(OUTPUT_DIR[], "$(n).tex")
    filename_pdf = joinpath(OUTPUT_DIR[], "$(n).pdf")


    open(filename, "w") do io
        write(io, a)
        write(io, b)
        for cc in c
            write(io, cc)
        end
        write(io, """
                \\end{minipage}
            \\end{center}
        \\end{document}
        """)
    end

    run(`lualatex -output-directory=$(OUTPUT_DIR[]) -shell-escape $(filename)`)

    if !CVs
        run(`open $(filename_pdf)`)  # Open the PDF file
        return filename_pdf, nothing
    else
        _generate_fake_CVs()
        all_CVs = get_CVs(dayschedule)
        run(`open $(filename_pdf) $(all_CVs)`)  # Open the PDF file
        return filename_pdf, all_CVs
    end

end
