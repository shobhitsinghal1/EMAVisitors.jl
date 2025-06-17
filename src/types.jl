"""
    DtuMember(firstname::String, lastname::String, email::String, position::String)

A type representing a DTU member.

# Fields
- `firstname::String`: The member's first name.
- `lastname::String`: The member's last name.
- `email::String`: The member's email address.
- `position::String`: The member's position or title.

# Example
    member = DtuMember("Alice", "Smith", "alice@dtu.dk", "Professor")
"""
struct DtuMember 
    firstname::String
    lastname::String
    email::String
    position::String
end


"""
    DtuMember(name::AbstractString, email::AbstractString, position::AbstractString)

Alternate constructor for `DtuMember` that takes a full name as a single string, an email, and a position.

# Arguments
- `name::AbstractString`: The full name (first and last name separated by a space).
- `email::AbstractString`: The member's email address.
- `position::AbstractString`: The member's position or title.

# Returns
- A `DtuMember` instance with the parsed first and last name.

# Example
    member = DtuMember("Alice Smith", "alice@dtu.dk", "Professor")
"""
function DtuMember(name::AbstractString, email::AbstractString, position::AbstractString)
    firstname, lastname = String.(split(name, " ")) 
    return DtuMember(firstname, lastname, email, position)
end

"""
    Seminar(room::String, title::String, time::Tuple{Time,Time}, date::Date)

A type representing a seminar event.

# Fields
- `room::String`: The seminar room.
- `title::String`: The seminar title.
- `time::Tuple{Time,Time}`: Start and end time.
- `date::Date`: The seminar date.
"""
struct Seminar 
    room::String
    title::String
    time::Tuple{Time,Time}
    date::Date
end

"""
    room(s::Seminar)
Returns the room of the seminar.
"""
room(s::Seminar) = s.room

"""
    title(s::Seminar)
Returns the title of the seminar.
"""
title(s::Seminar) = s.title

"""
    time(s::Seminar)
Returns the time tuple of the seminar.
"""
time(s::Seminar) = s.time

"""
    date(s::Seminar)
Returns the date of the seminar.
"""
date(s::Seminar) = s.date

"""
    SpeakerName(firstname::String, lastname::String, email::String, affiliation::String, startingdate::Date, visitduration::Int, host::DtuMember, seminar::Union{Seminar,Nothing})

A type representing a speaker's name and visit details.

# Fields
- `firstname::String`: First name.
- `lastname::String`: Last name.
- `email::String`: Email address.
- `affiliation::String`: Affiliation.
- `startingdate::Date`: Start date of visit.
- `visitduration::Int`: Duration of visit in days.
- `host::DtuMember`: Host member.
- `seminar::Union{Seminar,Nothing}`: Associated seminar or `nothing`.
"""
struct SpeakerName
    firstname::String
    lastname::String
    email::String
    affiliation::String
    startingdate::Date
    visitduration::Int
    host::DtuMember

    seminar::Union{Seminar,Nothing}
    hotel::Dict{String,String}
end

"""
    name(member::Union{DtuMember,SpeakerName})
Returns the full name of the member.
"""
name(member::Union{DtuMember,SpeakerName}) = member.firstname * " " * member.lastname 

"""
    email(member::Union{DtuMember,SpeakerName})
Returns the email of the member.
"""
email(member::Union{DtuMember,SpeakerName}) = member.email

"""
    position(member::DtuMember)
Returns the position of the DTU member.
"""
position(member::DtuMember) = member.position

"""
    startdate(member::SpeakerName)
Returns the start date of the speaker's visit.
"""
startdate(member::SpeakerName) = member.startingdate

"""
    visitduration(member::SpeakerName)
Returns the visit duration in days.
"""
visitduration(member::SpeakerName) = member.visitduration

"""
    host(member::SpeakerName)
Returns the host of the speaker.
"""
host(member::SpeakerName) = member.host

"""
    affiliation(member::SpeakerName)
Returns the affiliation of the speaker.
"""
affiliation(member::SpeakerName) = member.affiliation

"""
    talkroom(member::SpeakerName)
Returns the seminar room or "Not scheduled" if no seminar is assigned.
"""
talkroom(member::SpeakerName) = member.seminar === nothing ? "Not scheduled" : room(member.seminar)

"""
    talktime(member::SpeakerName)
Returns the seminar time or "Not scheduled" if no seminar is assigned.
"""
talktime(member::SpeakerName) = member.seminar === nothing ? "Not scheduled" : time(member.seminar)

"""
    talkdate(member::SpeakerName)
Returns the seminar date or "Not scheduled" if no seminar is assigned.
"""
talkdate(member::SpeakerName) = member.seminar === nothing ? "Not scheduled" : date(member.seminar)

"""
    talktitle(member::SpeakerName)
Returns the seminar title or "Not scheduled" if no seminar is assigned.
"""
talktitle(member::SpeakerName) = member.seminar === nothing ? "Not scheduled" : title(member.seminar)


"""
    hotelname(member::SpeakerName)
Returns the name of the hotel for the speaker.
"""
hotelname(member::SpeakerName) = member.hotel["Name"]

"""
    hoteladdress(member::SpeakerName)
Returns the address of the hotel for the speaker.
"""
hoteladdress(member::SpeakerName) = member.hotel["Address"]

"""
    hotelmaps(member::SpeakerName)
Returns the Google Maps link for the hotel of the speaker.
"""
hotelmaps(member::SpeakerName) = member.hotel["Google Maps"]

"""
    DaySchedule(members::Dict{String, Tuple{Tuple{Time,Time}, String}}, date::Date)

A type representing a day's schedule for seminars.

# Fields
- `members::Dict{String, Tuple{Tuple{Time,Time}, String}}`: Mapping from member name to (time, room).
- `date::Date`: The date of the schedule.
"""
struct DaySchedule
    members::Dict{String, Tuple{Tuple{Time,Time}, String}}
    date::Date
end

"""
    members(schedule::DaySchedule)
Returns the members dictionary of the schedule.
"""
members(schedule::DaySchedule) = schedule.members

"""
    date(schedule::DaySchedule)
Returns the date of the schedule.
"""
date(schedule::DaySchedule) = schedule.date

"""
    name(schedule::DaySchedule)
Returns a vector of member names in the schedule.
"""
name(schedule::DaySchedule) = keys(members(schedule)) |> collect

"""
    DaySchedule(m::Vector{DtuMember}, date::Date, times::Vector{Tuple{Time,Time}}, room::Vector{String})

Alternate constructor for `DaySchedule` that builds the members dictionary from vectors of members, times, and rooms.

# Arguments
- `m::Vector{DtuMember}`: List of members.
- `date::Date`: The date of the schedule.
- `times::Vector{Tuple{Time,Time}}`: List of time slots.
- `room::Vector{String}`: List of rooms.

# Returns
- A `DaySchedule` instance.

# Example
    schedule = DaySchedule([member1, member2], date, [(t1, t2), (t3, t4)], ["Room1", "Room2"])
"""
function DaySchedule(m::Vector{DtuMember}, date::Date, times::Vector{Tuple{Time,Time}}, room::Vector{String})
    @assert length(m) == length(times) "Number of members must match number of times"
    @assert length(m) == length(room) "Number of members must match number of rooms"

    members = Dict{String, Tuple{Tuple{Time,Time}, String}}()
    for (i, member) in enumerate(m)
        members[name(member)] = (times[i], room[i])
    end
    return DaySchedule(members, date)
end
