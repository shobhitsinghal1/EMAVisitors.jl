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
        df_members = isfile(PATH_TO_EMA_MEMBERS[]) ? CSV.read(PATH_TO_EMA_MEMBERS[], DataFrame) : error("File $PATH_EMA_MEMBERS does not exist")
    else
        df_members = isfile(PATH_TO_OTHER_MEMBERS[]) ? CSV.read(PATH_TO_OTHER_MEMBERS, DataFrame) : error("File $PATH_OTHER_MEMBERS does not exist")
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
