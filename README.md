# TTManager
## Description
Target audience: table tennis players and relatives  
TTManager app is an app which can be used to look up data about table tennis.
The users will be able to look up
* the national player ranking
* the own profile
* the own played matched
* the location of the sports halls on a map
* Additional club information

## Matches

<img src="TTManager_Images\Matches_unidentified.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>
<img src="TTManager_Images\Matches_identified.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>
<img src="TTManager_Images\Matches_Details.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>

### Description
The Matches tab is used to display information about official the own Matches. Once the player is
identified, you can watch the players matches. Every time the app is started, it will look up if there
are new matches. If you tab on a match you can see more detailed information about a match.
Also the app will look up the matches played the same day and the matches against this player in
the database.

### Additional Information
The own data is stored in the Userdefaults, whereas the matches are stored in the database.

## Sports Halls

<img src="TTManager_Images\Map.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>
<img src="TTManager_Images\Map_filter.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>
<img src="TTManager_Images\Club_with_image.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>
<img src="TTManager_Images\Club.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>

### Description
The Sports Halls tab is used to look up information in the apps database. You can look up the
phone number, the address and images associated to the club. You can start a phone call to the
club. Also, you can add images to the club and delete them by long pressing on the image. The
image can be taken from the smartphone’s library and from the camera.
### Additional Information
The image will be compressed and saved to the app’s directory.

## NPR

<img src="TTManager_Images\NPR.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>
<img src="TTManager_Images\NPR_Highlight.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>
<img src="TTManager_Images\NPR_filter.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>

### Description
The NPR tab can be used to look up the national player ranking. Once the player is identified, the
player and every player playing in the same club will be highlighted. Every time the app is started
it will ask the API if there is a newer NPR available and download it. Filtering is also possible. The
available filters are the name, the club and the class. These filters can be combined

## Settings

<img src="TTManager_Images\Settings.png" alt="drawing" width="24%" style="max-width: 214px; max-height: 463"/>

### Description
The Settings tab is used to identify the player by sending the entered Data to the API. If there is a
matching player, the fields will be auto completed and the players data will be downloaded. The
players name will be saved to the Userdefaults. You also have the possibility to set the colors used
in the NPR tab. The colors are saved in the Userdefaults.