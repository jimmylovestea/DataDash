#find variable indeces 
times <- 25550:56939
gbg<-tidync("/home/ST505/CESM-LENS/historical/PREC.nc")%>%
  hyper_filter(lat = lat<18)%>%
  hyper_filter(lon = lon<224)%>%
  hyper_filter(time= time==25550)%>%
  hyper_tibble()
members <- gbg$mem
gbg<-tidync("/home/ST505/CESM-LENS/historical/PREC.nc")%>%
  hyper_filter(mem = mem==1)%>%
  hyper_filter(time= time==25550)%>%
  hyper_tibble()
latitudes <- unique(gbg$lat)
longitudes <- unique(gbg$lon)
remove(gbg)

#This function needs the following data frame to run:
decadal_average_cumulative_prec_waveforms <- readRDS("/home/ST505/precalculated_data/yearly_cumulative_prec.rds")

#use ggplot to make an error message
err_plot <- ggplot()+
  annotate(geom="text",y=1,x=1,label="Oops! It looks like there weren't any raster pixels in your window. Please try a larger window.")+
  theme_void()

a <- latitudes[6]
b <- latitudes[8]
c <- longitudes[24]
d <- longitudes[26]

plot_sawtooths <- function(lat_min,lat_max,lon_min,lon_max){
  dat <- decadal_average_cumulative_prec_waveforms%>%
    filter(latitude>=lat_min&latitude<=lat_max)%>%
    filter(longitude>=lon_min&longitude<=lon_max)
  ndat <- dat%>%
    select(avg_cumulative_prec)%>%
    summarise(n=n())%>%
    as.numeric()
  
  if(ndat==0){err_plot}
  else{
    dat%>%
      group_by(water_day,decade)%>%
      summarise(cum_prec = mean(avg_cumulative_prec))%>%
      ggplot()+
      geom_line(aes(x=water_day,y=cum_prec,color=as.factor(decade)))
  }
}