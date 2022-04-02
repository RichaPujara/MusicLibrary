# My Music World

### About:
***My Music World*** is a Ruby application to help the user manage their music files(mp3 and mpeg) from terminal. The app allows the user to create the music library as well as create, edit and manage the playlists. The user will be able to to play the songs from the library and playlists (single song, all songs, shuffle and play mode) provided the user machine has required softwares installed.
Enjoy managing your music through terminal... 

### Dependencies:
This app is buit in Ruby language. The user needs to have Ruby installed on their computer in order to use this app. You can get more help from [Ruby Documentation](https://www.ruby-lang.org/en/documentation/installation/) on how to install Ruby.
The app also depends on the following gems: 
``` ruby
gem "tty-font", "~> 0.5.0"

gem "rainbow", "~> 3.1"

gem "shellwords", "~> 0.1.0"

gem "fileutils", "~> 1.6"

gem "optparse", "~> 0.2.0"
```

The app depends on the other application ***mpg123*** for playing the music files. In order to use the music playing functionality of the app, users need to have this app downloaded on their local machine. You will be able to get more help on how to install this app from *[here](https://www.mpg123.de/)*.


### Installation:

If you are using this app for the first time, please clone this repository on your local machine. Now change your current directory to the one where you have the project on your local machine. You will also need to install the ruby gems stated above. You can do that either manually or by running ```./my_music_world.sh -i```. It will install all the required gems on to your machine. 
If you want to enjoy full functionality of this app (including playing music), you will also need ***mpg123*** app for playing music. You will be able to get the information regarding the installation of mpg123 from its official website.[https://www.mpg123.de/](https://www.mpg123.de/) You can also download mpg123 app on your Mac by running ```brew install mpg123``` on your terminal. If you haven't installed mpg123, you will still be able to use other functionalities such as creating music library, creating and editing playlists. 



### Usage:

If you already have the required dependecies on your machine, you can simply start using the app by running ```./my_music_world.sh```. If you are an existing user of this app with your profile already created, you can also directly sign in to your profile by providing their username and password as arguments when running the script in terminal by ```./my_music_world.sh -u username -p password``` format. You can also start the app by just providing your username as an argument with terminal command as ```./my_music_world.sh -u username```. If you want the help regarding the terminal commands, you can get it by running ```./my_music_world.sh -h```. This app works best when the terminal width is minimum 100 cols.

Upon starting the app, you can create your profile by providing your name, username, password and path to your local music directory. Please provide the full path to your music folder from root directory during sign up when prompted for the path. The app will serach through the folder recursively and create your music library. You will now be ready to use this library to create, edit or delete your playlists. You will also be able to play the songs. This app allows multiple users to create and maintain their profile on the same machine.

### Hardware/ OS requirements:

This app runs with most of the modern machines. However, for using the play music functionality, you will need the ***mpg123*** app. It supports Unix/Linux/Mac and some of Windows OS. Please check its compatibility with your device. 
