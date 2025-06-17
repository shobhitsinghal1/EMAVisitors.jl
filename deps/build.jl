using EMAVisitors

src_file = isfile(EMAVisitors.PATH_TO_DTU_WIND_LOGO[]) ? EMAVisitors.PATH_TO_DTU_WIND_LOGO[] : error("File $(EMAVisitors.PATH_TO_DTU_WIND_LOGO[]) does not exist") 
