#!/bin/bash

if [ ! -f "user_list.csv" ]
then
    echo "first_name,last_name,username,password,path" >> user_list.csv
fi

if [ ! -d "data" ]
then
    mkdir data
fi

while getopts ":u::p:ih" options
do
    case "${options}" in
        i) # install gems
            printf "Installing GEMs for my music world ruby application.\n"
            gem install bundler
            bundle install
            printf "GEMs installed for my music world ruby application.\n"
            printf "Please install mpg123 for playing the music. To know how to install please check the README.md\n"
            read -p "Is mpg123 installed? y/n:"
            user_input=${REPLY}
            user_input=$(echo "$user_input" | awk '{print tolower($0)}')
            if [ "y" = $user_input ]
            then
                printf "Taking you to MY MUSIC WORLD\n"
                sleep 2
                ruby my_music_world.rb
            else
                printf "Okay, sorry you wont able to play music but you can still enjoy other features of MY MUSIC WORLD.\n"
                printf "Taking you to MY MUSIC WORLD\n"
                sleep 2
                ruby my_music_world.rb
            fi
            exit 0
            ;;

        u) # set username
            username=${OPTARG}
            ;;

        p) # set password
            password=${OPTARG}
            ;;

        h) #display Help
            ruby my_music_world.rb -h
            exit 0
            ;;
        *)
            printf "no parameter included with argument $OPTARG\n"
            ruby my_music_world.rb -h
            exit 0
            ;;
    esac
done

cmd="ruby my_music_world.rb"
if [ ! -z "$username" ]
then
    cmd="${cmd} -u ${username}"
fi

if [ ! -z "$password" ]
then
    cmd="${cmd} -p $password"
fi

# Start MY MUSIC WORLD ruby app
#${cmd}
