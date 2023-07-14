# Rename video files with R and Trackman/Yakkertech data
# This assumes that there is a video clip for each consecutive pitch
# This is very handy when working with Edgertronic video from bullpens where every pitch is captured
# unnamed video files in folder /video_files - unchanged/

library(hms)
library(dplyr)
library(stringr)
 

#first load our games CSV
csv <- read.csv("C:/Users/tdmed/OneDrive/_Github/Rename-Video-Files-with-Baseball-Data/05-26 BOOM vs NYB 304 YT.csv") %>%
  # For this specific example, I know that I'm using video from only the bottom of the first, so lets filter
  filter(`Top.Bottom` == 'Bottom' & Inning == 1) %>%
# the result is 13 pitches in the bottom of the first. now let's keep the columns to use when we rename
  dplyr::select(PitchNo,Batter,PitchCall,HitType, PlayResult, ExitSpeed) 

# lets replace these long words in the df
x <- c("BallCalled","StrikeCalled",'HitByPitch','StrikeSwinging', 'InPlay')
y <- c('Ball', 'Strike', 'HBP', 'StrSw', '')
str_replace_all(x, colours, col2hex)

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

video_folder <- "C:/Users/tdmed/OneDrive/_Github/Rename-Video-Files-with-Baseball-Data/video_files/"

videos <- file.info(list.files(video_folder ,pattern = "*.mp4")) %>% tibble::rownames_to_column("file")
# we also have 13 video files! success!
videos_details <- videos %>%
  mutate(datetime = mtime) %>%
  separate(datetime, into = c("date", "time"), sep = " ") %>%
  mutate(time =  as_hms(time),
         time_zero = time - time[1],
         time_diff = time - lag(time)) 

# now the fun part
for(i in 1:length(csv_rename$vid_name)) {
  videos_details <- videos_details %>%
    mutate(vid_name = csv_rename$vid_name)
}

# time to rename!
file.rename(from = paste0(video_folder,videos_details$file),
            to = paste0(video_folder, videos_details$vid_name))
