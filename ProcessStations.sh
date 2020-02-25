#!/bin/bash
#Assignment #5- Complex Tasks in Linux
#Les Warren, February 24,2020
#This script is to process the data in a directory based on specific conditions set forth by the lab instructions. 

##Part 1
if [ -d HigherElevation ] #if  exists
then
 	echo "Directory already exists" #verifying that directory exists
else
	mkdir HigherElevation #make directory
	echo " HigherElevation directory created"
fi

for file in StationData/*
do
  output=`basename "$file"`
  if 
  grep 'Station Altitude: [200,*]' $file #stations equal to or over 200 altitude
  then cp StationData/$output HigherElevation/$ouput #copying results to new directory
  fi
done

##Part 2
awk '/Longitude/ {print -1 * $NF}' StationData/Station_*.txt > Long.list #list of longitude for all stations
awk '/Latitude/ {print $NF}' StationData/Station_*.txt > Lat.list #list of latitude for all stations
paste Long.list Lat.list > AllStations.xy #latitude and longitude for all stations


awk '/Longitude/ {print -1 * $NF}' HigherElevation/Station_*.txt > HELong.list #list of longitude for HigherElevation Stations
awk '/Latitude/ {print $NF}' HigherElevation/Station_*.txt > HELat.list #list of latitude for HigherElevation Stations
paste HELong.list HELat.list > HEStations.xy #latitude and longitude fro HigherElevation Stations 

module load gmt 

gmt pscoast -JU16/4i -R-93/-86/36/43 -B2f0.5 -Ia/blue -Na/orange -P -K -V -Cblue -Dh > SoilMoistureStations.ps #creates the figure, option(-Cblue)= lakes blue, option -Dh uses high resolution
gmt psxy AllStations.xy -J -R -Sc0.15 -Gblack -K -O -V >> SoilMoistureStations.ps #all stations as black circles
gmt psxy HEStations.xy -J -R -Sc0.10 -Gred -O -V >> SoilMoistureStations.ps #high elevation stations as smaller red circles(lowered Sc value) 

##Part 3
ps2epsi SoilMoistureStations.ps #.ps to .epsi
convert -density 150x150 SoilMoistureStations.epsi SoilMoistureStations.tiff #.epsi to .tiff, dpi at 150
