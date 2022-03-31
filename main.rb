require 'tty-prompt'
require "shellwords"
require "io/console"
require 'json'
require 'csv'
require 'rainbow'
require './user'
require './noSongsFoundException'
require 'fileutils'
require './helper'

# Entry point of the application
def music_library
    user_list = CSV.parse(File.read("user_list.csv"), headers: true)

    user = nil
    if user_list.empty?
        show_logo
        user = create_user(user_list)
    else
        loop do
            show_logo
            puts_rosybrown("\nAre you existing user")
            puts_lightcoral("Press 1: Yes I am existing user, I would like login")
            puts_lightcoral("Press 2: I am new user, please set my profile")
            puts_indianred("Press 3: To close My Music World")
            user_input = gets.chomp.to_i
            case user_input
            when 1
                user = login(user_list)
                break

            when 2
                user = create_user(user_list)
                break

            when 3
                exit_app

            else
                puts "Invalid Input. Please try again with a valid input"
                sleep(2)
            end
        end
    end

    main_library = user.song_list
    loop do
        show_logo
        puts_rosybrown("What would you like to do??\n")
        puts_lightcoral("Press 1. List all Music files")
        puts_lightcoral("Press 2. My Playlists")
        puts_indianred("Press 3. To close My Music World")
        user_input = gets.strip.to_i

        case user_input
        when 1
            list_all_songs(main_library)

        when 2
            my_playlist(user, main_library)

        when 3
            exit_app

        else
            puts "Invalid Input. Please try again with a valid input"
            sleep(2)
        end
    end
end

# Create new user
def create_user(user_list)
    puts "Let's get to know you little better.\n\nPlease tell me"
    print "Your first name: "
    fname = gets.chomp.upcase
    print "Your last name: "
    lname = gets.chomp.upcase
    puts "\nHello #{fname} #{lname}"

    uname = nil
    loop do
        print "Select your username: "
        uname = gets.chomp.downcase

        break unless user_list.by_col["username"].include? uname

        puts "Username '#{uname}' exists.\n\n"
        puts_rosybrown(" Would you like try again with a different username:")
        puts_lightcoral("Press 1: To try again")
        puts_indianred("Press 2: To close My Music World")
        user_input = gets.chomp.to_i
        exit_app if user_input == 2
        puts ""
    end

    print "Select your password: "
    pword = $stdin.noecho(&:gets).chomp
    puts "\n\nThank you.. Let's organize your music files\n"

    begin
        puts "Please add the absolute path to your music directory."
        path = gets.chomp
        puts "Using #{path} as your music library base\n"
        # creating new USER instance:
        user = User.new(fname, lname, uname, pword, path)

        raise NoSongsFoundException if user.song_list.songs.length.zero?

        puts "\nCongratulations! Your Music Library profile been created."

        CSV.open("user_list.csv", "a", headers: true) do |csv|
            csv << [user.first_name, user.last_name, user.username, user.password, user.dir_location]
        end

        puts "\nYour music library has following songs.\n\n"
        user.song_list.list_songs
        puts "\n\n"
        sleep(2)
        return user
    rescue Errno::ENOENT
        puts "There seems to be some error with path provided.\nLets try again.\n\n"
        retry
    rescue NoSongsFoundException
        puts "Failed to find any music files at the provided path.\nLets try again.\n\n"
        retry
    end
end

# Login a user
def login(user_list)
    uname = nil
    loop do
        print "Please enter username: "
        uname = gets.chomp.downcase

        break if user_list.empty?
        break if user_list.by_col["username"].include? uname

        puts "Username '#{uname}' unknown.\n\n"
        puts_rosybrown("Would you like to try again:")
        puts_lightcoral("Press 1: To try again")
        puts_indianred("Press 2: To close My Music World")
        user_input = gets.chomp.to_i
        exit_app if user_input == 2
        puts ""
    end

    pword = nil
    user_row = user_list.find { |row| row["username"] == uname }

    loop do
        print "Please enter password: "
        pword = $stdin.noecho(&:gets).chomp

        break if user_list.empty?
        break if user_row["password"] == pword

        puts "\nInvalid Password.\n\n"
        puts_rosybrown("Would you like to try again:")
        puts_lightcoral("Press 1: To try again")
        puts_indianred("Press 2: To close My Music World")
        user_input = gets.chomp.to_i
        exit_app if user_input == 2
        puts ""
    end

    user = User.new(user_row["first_name"], user_row["last_name"], uname, pword, user_row["path"])
    puts "\nHello #{user.name}"

    if user.song_list.songs.length.zero?
        puts_gold("\nFailed to find any music files at \"#{user.dir_location}\".")
        puts_gold("Please add music files at this location and come back.")
        exit_app
    end

    sleep(2)
    return user
end

# List user songs
def list_all_songs(main_library)
    loop do
        show_logo
        main_library.list_songs
        puts_lightcoral("\n\nPress 1: Play All songs")
        puts_lightcoral("Press 2: Play specific song")
        puts_lightcoral("Press 3: Shuffle play songs")
        puts_lightcoral("Press 4: Go Back to previous screen")
        puts_indianred("Press 5: To close My Music World")
        user_input = gets.chomp.to_i

        case user_input
        when 1
            main_library.play_all

        when 2
            begin
                puts "Please input the song no you want to play:"
                main_library.play_song(gets.chomp.to_i)
            rescue NoMethodError
                puts "Invalid Input. Please add the 'Number' in range 1..#{main_library.songs.length}"
                sleep(3)
            end

        when 3
            main_library.shuffle_play

        when 4
            break

        when 5
            exit_app

        else
            puts "Invalid Input. Please try again with a valid input"
            sleep(2)
        end
    end
end

# Playlist options
def my_playlist(user, _main_library)
    loop do
        show_logo
        puts_rosybrown("Select from below")
        puts_lightcoral("Press 1. Select Playlist")
        puts_lightcoral("Press 2. Create New Playlist")
        puts_lightcoral("Press 3: Go Back to previous screen")
        puts_indianred("Press 4: To close My Music World")
        user_input = gets.chomp.to_i
        show_logo

        case user_input
        when 1
            if user.playlist_list.length.zero?
                puts "You have not created any Playlist yet. Lets start by creating a new Playlist from previous menu\n\n"
                sleep(2)
            else
                puts "You have following Playlists:"
                user.show_playlists
                puts "\nChoose Playlist Number you would like to go to. Press 0 to go back to previous screen."
                playlist_number = gets.chomp.to_i

                next if playlist_number.zero?

                playlist = user.playlist_list[playlist_number - 1]
                playlist_operations(user, playlist)
            end

        when 2
            playlist = user.create_playlist
            playlist_operations(user, playlist)

        when 3
            break

        when 4
            exit_app

        else
            puts "Invalid Input. Please try again with a valid input"
            sleep(2)
        end
    end
end

# Operate on a selected playlist
def playlist_operations(user, playlist)
    loop do
        playlist_file_path = "#{user.music_manager_playlist_dir}/#{playlist.name}.playlist"
        show_logo
        puts "Songs in the Playlist:"
        playlist.list_songs
        puts_rosybrown("\n\n\nWhat would you like to do now?")
        puts_lightcoral("Press 1. Play all songs")
        puts_lightcoral("Press 2. Shuffle play songs")
        puts_lightcoral("Press 3. Edit Playlist")
        puts_lightcoral("Press 4. Delete Playlist")
        puts_lightcoral("Press 5: Go Back to previous screen")
        puts_indianred("Press 6: To close My Music World")
        user_input = gets.chomp.to_i

        case user_input
        when 1
            playlist.play_all

        when 2
            playlist.shuffle_play

        when 3
            playlist.edit_playlist(user.song_list, playlist_file_path)

        when 4
            user.delete_playlist(playlist)
            break

        when 5
            break

        when 6
            exit_app

        else
            puts "Invalid Input. Please try again with a valid input"
            sleep(2)
        end
    end
end

music_library
