# Rename video files with R and Trackman/Yakkertech data
# This code is if you captured random videos throughout a bullpen or game
# This is very handy when working with Edgertronic video 
# all you need to make sure of is you know the very first pitch that you captured on video compared to the CSV!
# unnamed video files in folder /video_files_pitches_out_of_order - unchanged/

library(hms)
library(plyr)
library(dplyr)
library(tidyverse)
library(stringr)
library(tibble)
library(fuzzyjoin)
 

#first load our games CSV
csv <- read.csv("C:/Users/tdmed/OneDrive/_Github/Rename-Video-Files-with-Baseball-Data/05-26 BOOM vs NYB 304 YT.csv") %>%
  # For this specific example, I know that I'm using video from only the bottom of the first, so lets filter
  filter(`Top.Bottom` == 'Bottom' & Inning == 1) %>%
  # we will filter further, because I know the first video I captured was Chase Dawson ground out!
  slice(3:nrow(.)) %>%
# the result is 13 pitches in the bottom of the first. now let's keep the columns to use when we rename
  dplyr::select(Time,PitchNo,Batter,PitchCall,HitType, PlayResult, ExitSpeed) %>%
  mutate(datetime = Time) %>%
  separate(datetime, into = c("time"), sep = " ")%>%
  mutate(time =  as_hms(time),
         time_zero = time - time[1],
         time_diff = time - lag(time)) 

# copy to new df
csv_rename <- csv %>%
  # clean up some of the keywords to make the filename shorter
  mutate(ExitSpeed = round(ExitSpeed,1),
         PitchCall = str_replace_all(PitchCall,c('BallCalled' = 'Ball', 'StrikeCalled' = 'Strike', 'StrikeSwinging' = 'Whiff',
                                                 'HitByPitch'= 'HBP')),
         HitType = str_replace_all(HitType,c('LineDrive' = 'LD', 'Flyball' = 'FB', 'Popup' = 'PU',
                                                 'Groundball'= 'GB', 'Bunt' ='BU' )),
         PlayResult = str_replace_all(PlayResult,c('Single' = '1B', 'Double' = '2B', 'Triple' = '3B', 'HomeRun'= 'HR', 
                                                   'StrikeoutSwinging' ='K', 'StrikeoutLooking' = 'K' ))) %>%
  # create a new column that we will rename the video file
  mutate(vid_name = ifelse(PitchCall == 'InPlay', paste(PitchNo, Batter, PitchCall, HitType, PlayResult, 'EV', ExitSpeed, '.mp4'),
                           paste(PitchNo, Batter, PitchCall, PlayResult,'.mp4') ),
         # remove NAs, InPlay, and extra spaces
         vid_name = str_squish(str_trim(str_replace_all(vid_name, c('NA' = '', 'InPlay' = ''))))
         )


# Next, let's load in our directory where the video files are at

video_folder <- "C:/Users/tdmed/OneDrive/_Github/Rename-Video-Files-with-Baseball-Data/_Random Pitches/video_files_pitches_out_of_order/"

videos <- file.info(list.files(video_folder ,pattern = "*.MOV", full.names = TRUE)) %>% tibble::rownames_to_column("file")
# we also have 13 video files! success!
videos_details <- videos %>%
  mutate(datetime = mtime) %>%
  separate(datetime, into = c("date", "time"), sep = " ") %>%
  arrange(time) %>%
  mutate(time =  as_hms(time),
         time_zero = time - time[1],
         time_diff = time - lag(time)) %>%
  select(file,mtime,time_zero)


# time to join on the time_zero!
# fuzzy join allows us to join on the nearest time_zero, since the time_zero's won't always match!
combined <- videos_details %>%
  fuzzy_left_join(csv_rename, 
                  by = c("time_zero"), 
                  match_fun = function(x, y) abs(x - y) <= 5)

# as you can now see, the df now has the video files with the pitch infor together. Now we rename the videos!
combined
# now the fun part
# time to rename!

file.rename(from = paste0(combined$file),
            to = paste0(video_folder, combined$vid_name))

