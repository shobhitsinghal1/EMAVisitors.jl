using EMAVisitors
using Dates
using Test



EMAVisitors.set_path_to_excel(joinpath(pwd(),"test-excel.xlsx"))
mkpath(joinpath(pwd(),"test-output"))
mkpath(joinpath(pwd(),"test-output/CVs"))
run(`cp DTU-wind.svg ./test-output/DTU-wind.svg`)

EMAVisitors.set_path_output_dir(joinpath(pwd(),"test-output"))
EMAVisitors.set_path_to_ema_members(joinpath(pwd(),"test-output", "ema-members.csv"))
EMAVisitors.set_path_to_other_members(joinpath(pwd(),"test-output","other-members.csv"))
EMAVisitors.set_path_to_talk_schedule(joinpath(pwd(),"test-output","talk-schedule.csv"))
EMAVisitors.set_path_dtu_wind_logo(joinpath(pwd(),"test-output","DTU-wind.svg"))
EMAVisitors.set_path_cvs(joinpath(pwd(),"test-output","CVs"))



@testset "Testing types" begin
    @test isfile(EMAVisitors.PATH_TO_EXCEL[])
    @test isfile(EMAVisitors.PATH_TO_DTU_WIND_LOGO[])

    nn = "John Doe" 
    e_email = "john.doe@dtu.dk"
    pos = "Professor"

    dtu_m = EMAVisitors.DtuMember(nn, e_email, pos)
    @test EMAVisitors.name(dtu_m) == nn
    @test EMAVisitors.email(dtu_m) == e_email
    @test EMAVisitors.position(dtu_m) == pos

    room = "Room 101"
    title = "Introduction to Julia"
    time = (Time(10, 0), Time(11, 0))
    date = Date(2023, 10, 1)

    seminar = EMAVisitors.Seminar(room, title, time, date)

    @test EMAVisitors.room(seminar) == room
    @test EMAVisitors.title(seminar) == title
    @test EMAVisitors.time(seminar) == time
    @test EMAVisitors.date(seminar) == date

    nn = "Jane"
    nn_2 = "Smith"
    e_email = "jane.smith@dtu.dk"
    affiliation = "DTU Wind Energy"
    sdate = Date(2023, 10, 1)
    duration = 2
    host = EMAVisitors.DtuMember("Licio Romao", "licio@dtu.dk", "Assistant Professor")

    hoteln = "Hotel DTU"
    hoteladd = "DTU Campus, Lyngby"
    hotelmm = "https://goo.gl/maps/DTUHotel"

    hh = Dict{String, String}()

    hh["Name"] = hoteln
    hh["Address"] = hoteladd
    hh["Google Maps"] = hotelmm

    ss = EMAVisitors.SpeakerName(nn, nn_2, e_email, affiliation, sdate, duration, host, seminar, hh)

    @test EMAVisitors.name(ss) == nn * " " * nn_2
    @test EMAVisitors.email(ss) == e_email
    @test EMAVisitors.affiliation(ss) == affiliation
    @test EMAVisitors.startdate(ss) == sdate 
    @test EMAVisitors.visitduration(ss) == duration
    @test EMAVisitors.hotelname(ss) == hoteln
    @test EMAVisitors.hoteladdress(ss) == hoteladd
    @test EMAVisitors.hotelmaps(ss) == hotelmm
    @test EMAVisitors.name(EMAVisitors.host(ss)) == EMAVisitors.name(host)
    @test EMAVisitors.talkroom(ss) == EMAVisitors.room(seminar)
    @test EMAVisitors.talktime(ss) == EMAVisitors.time(seminar)
    @test EMAVisitors.talkdate(ss) == EMAVisitors.date(seminar)
    @test EMAVisitors.talktitle(ss) == EMAVisitors.title(seminar)


    nn_2 = "Lesia Mitridati"
    e_email_2 = "lesia@dtu.dk"
    pos_2 = "Professor"
    dtu_m_2 = EMAVisitors.DtuMember(nn_2, e_email_2, pos_2)

    dd = Dict{String, Tuple{Tuple{Time, Time}, String}}()
    dd["John Doe"] = ((Time(10, 0), Time(11, 0)), "Room 101")
    dd["Lesia Mitridati"] = ((Time(12, 0), Time(13, 0)), "Room 102")
    dd_2 = Date(2023, 10, 2)
    day_schedule = EMAVisitors.DaySchedule(dd, dd_2)

    @test EMAVisitors.members(day_schedule) == dd
    @test EMAVisitors.date(day_schedule) == dd_2

    dd_ss = EMAVisitors.DaySchedule([dtu_m, dtu_m_2], Date(2023, 10, 3), [(Time(9, 0), Time(10,0)), (Time(10, 0), Time(11,0))], ["Room 103", "Room 104"])
   
end

@testset "Auxiliary functions" begin
    EMAVisitors.parse_members(EMAVisitors.PATH_TO_EXCEL[])
    EMAVisitors.parse_members(EMAVisitors.PATH_TO_EXCEL[]; others=true)

    m = EMAVisitors.get_all_dtu_members()

    ss = EMAVisitors.find_dtu_member(m, "Licio Romao")
    @test EMAVisitors.email(ss) == "licio@dtu.dk"

    ss = EMAVisitors.find_dtu_member(m, "jalal@dtu.dk")
    @test EMAVisitors.name(ss) == "Jalal Kazempour"

    ss = EMAVisitors.find_dtu_member(m, "Kazempour")
    @test EMAVisitors.name(ss) == "Jalal Kazempour"


    # Test _process_meeting_time

    tt = ["09:10 - 10:15 AM"]
    times = EMAVisitors._process_meeting_time(tt)
    @test times == [(Time(9, 10), Time(10, 15))]

    tt = ["09:10 - 10:15 AM", "11:00 - 11:59 AM"]
    times = EMAVisitors._process_meeting_time(tt)
    @test times == [(Time(9, 10), Time(10, 15)), (Time(11, 0), Time(11, 59))]

    # Test _process_seminar

    tt = "
        Room: 101
        Title: Introduction to Julia
        Time: 10:00 - 11:00 AM
        Date: 06/10/2025
    "

    tt = filter(x -> !isempty(x), lstrip.(split(tt, '\n')))

    seminar = EMAVisitors._process_seminar(tt)

    @test EMAVisitors.room(seminar) == "101"
    @test EMAVisitors.title(seminar) == "Introduction to Julia"
    @test EMAVisitors.time(seminar) == (Time(10, 0), Time(11, 0))
    @test EMAVisitors.date(seminar) == Date(2025, 6, 10)

    # Test _process_accommodation

    tt = "
        Name: Hotel DTU
        Address: DTU Campus, Lyngby
        Google Maps: https://goo.gl/maps/DTUHotel
    "
    tt = filter(x -> !isempty(x), lstrip.(split(tt, '\n')))

    hotel = EMAVisitors._process_accommodation(tt)
    @test hotel["Name"] == "Hotel DTU"
    @test hotel["Address"] == "DTU Campus, Lyngby"
    @test hotel["Google Maps"] == "https://goo.gl/maps/DTUHotel"

    @test try
        EMAVisitors._generate_fake_CVs()
        true
    catch
        false
    end

    @test try 
        EMAVisitors.parse_schedule(EMAVisitors.PATH_TO_EXCEL[])
        true
    catch
        false
    end

    EMAVisitors.parse_schedule(EMAVisitors.PATH_TO_EXCEL[])

    @test try
        EMAVisitors.create_schedule()
        true
    catch
        false
    end

    ss, dd_ss = EMAVisitors.create_schedule()

    # EMAVisitors._generate_fake_CVs()
    # EMAVisitors.get_CVs(dd_ss, ss)


    @test try 
        EMAVisitors._generate_fake_CVs()
        EMAVisitors.get_CVs(dd_ss, ss)
        true
    catch e
        println("Error in get_CVs: ", e)
        false
    end

    
end

@testset "Write_latex" begin 
    @test try
        EMAVisitors.generate_latex_schedule()
        true
    catch
        false
    end

end


