# Rename Video Files with Baseball Data
Way back in 2021, I would capture Edgertronic videos of pitchers or hitters during bullpens and games. That part was easy- trigger the camera as the event happens. What was not fun was having to manually rename a whole bunch of clips every day. I came up with this to help!

With this code, you can rename your high speed video clips (Edgertronic, Sony, [Video Buffer for Apple](https://apps.apple.com/us/app/video-buffer-clip-prerecorder/id1331747164), or just slow motion video taken with your smartphone camera) from a game with pitch information from a Tackman or Yakkertech CSV. This could be used for Rapsodo or Hawkeye too, you'd just need to change the column names appropriately! 
 
 ### There are two versions of this renamer: 
 1. The first is where video was captured consecutively and you know what was captured. For example, you capture video for every pitch thrown in a bullpen, every swing a player takes, etc.
 2. The second is where video was captured randomly. For example, maybe you capture a few of your hitters' swings, some of your pitchers pitches, so it's random.

# Known / Consecutive Video
**_Whatever device your video is stored on, copy it to a folder on you hard drive or other drive. Never work with the original video file in case you royally mess it up!_**
- In R we are going to be loading the CSV and the folder details of our videos. 
- With this version, the # of pitches and the # of clips should line up easily. It just becomes a matter of what data you want to use from the csv to rename the video files.
- Example: 1 deGrom FB 98mph.mp4, 2 deGrom SL 90mph.mp4 ; 15 Trout LD HR EV-105.mp4


Here is a screenshot of the video folder before renaming!
![](https://github.com/tony-baseball/Rename-Video-Files-with-Baseball-Data/blob/main/_Known%20Pitches/video%20folder%201%20after%20rename.png)





Here is the after!

![](https://github.com/tony-baseball/Rename-Video-Files-with-Baseball-Data/blob/main/_Known%20Pitches/video%20folder%202%20after%20rename.png)

# Random Video
**_Whatever device your video is stored on, copy it to a folder on you hard drive or other drive. Never work with the original video file in case you royally mess it up!_**
- In R we are going to be loading the CSV and the folder details of our videos. It'll give us a time when the pitch was captured by the system, as well as a time stamp when the video was triggered.
- With this version, we'll be using the first event captured on video as our starting point, so it's important to remember! Once we filter to our first captured video clip in the csv, we create a time difference column to show how much time has passed since the first clip. In both the video_details df and csv df, they should be within 5 seconds of each other. The code will then join on the nearest time stamp and voila!

Video folder before renaming

![](https://github.com/tony-baseball/Rename-Video-Files-with-Baseball-Data/blob/main/_Random%20Pitches/video%20folder%201%20before%20rename.png)

csv dataframe

![](https://github.com/tony-baseball/Rename-Video-Files-with-Baseball-Data/blob/main/_Random%20Pitches/df%201%20csv_rename.png)

csv dataframe - an example if you were to do it with pitcher info!

![](https://github.com/tony-baseball/Rename-Video-Files-with-Baseball-Data/blob/main/_Random%20Pitches/df%201%20csv_rename%20pitcher.png)

video_details dataframe 

![](https://github.com/tony-baseball/Rename-Video-Files-with-Baseball-Data/blob/main/_Random%20Pitches/df%202%20video_details.png)

The combined/joined dataframe!!!!!!

![](https://github.com/tony-baseball/Rename-Video-Files-with-Baseball-Data/blob/main/_Random%20Pitches/df%203%20combined.png)


Look at those files renamed!!!

![](https://github.com/tony-baseball/Rename-Video-Files-with-Baseball-Data/blob/main/_Random%20Pitches/video%20folder%202%20after%20rename.png)
