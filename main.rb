require 'tty-prompt'
require 'tty-font'
require "shellwords"
require "io/console"
require 'json'
require 'csv'
require 'rainbow'
require './user'
require './noSongsFoundException'
require 'fileutils'

# Entry point of the application
def music_library
    user_list = CSV.parse(File.read("user_list.csv"), headers: true)

    font = TTY::Font.new(:doom)
    pastel = Pastel.new
    system("clear")
    puts pastel.yellow("Welcome to")
    puts pastel.cyan(font.write("MY  MUSIC  WORLD"))
    puts pastel.yellow("- Your CLI based music manager.")

    user = nil
    if user_list.empty?
        user = create_user(user_list)
    else
        puts "\nAre you existing user"
        puts "Press 1: Yes I am existing user, I would like login"
        puts "Press 2: I am new user, please set my profile"
        user_input = gets.chomp.to_i
        case user_input
        when 1
            user = login(user_list)
        when 2
            user = create_user(user_list)
        else
            puts "Invalid input"
        end
    end

    main_library = user.song_list
    loop do 
        system("clear")
        puts "What would you like to do??\n"
        puts "1. List all Music files"
        puts "2. My playlists"
        puts "3. Exit"
        user_input = gets.strip.to_i

        case user_input
        when 1
            list_all_songs(main_library)

        when 2
            my_playlist(user, main_library)

        when 3
            puts Rainbow("\nThank you for using My Music Manager today.. See you soon..").cyan
            break

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

        puts "Username \"#{uname}\" exists. Would you like try again with a different username:"
        puts "Press 1: To try again"
        puts "Press 2: Exit from My Music Manager"
        user_input = gets.chomp.to_i
        if user_input == 2
            puts Rainbow("\n\nThank you for using My Music Manager today.. See you again soon").cyan
            exit 0
        end
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

        puts "Username \"#{uname}\" unknown.\nWould you like to try again:"
        puts "Press 1: To try again"
        puts "Press 2: Exit from My Music Manager"
        user_input = gets.chomp.to_i
        if user_input == 2
            puts Rainbow("\n\nThank you for using My Music Manager today.. See you again soon").cyan
            exit 0
        end
        puts ""
    end

    pword = nil
    user_row = user_list.find { |row| row["username"] == uname }

    loop do
        print "Please enter password: "
        pword = $stdin.noecho(&:gets).chomp

        break if user_list.empty?
        break if user_row["password"] == pword

        puts "Invalid Password.\n\nWould you like to try again:"
        puts "Press 1: To try again"
        puts "Press 2: Exit from My Music Manager"
        user_input = gets.chomp.to_i
        if user_input == 2
            puts "\n\nThank you for using My Music Manager today.. See you again soon"
            exit 0
        end
        puts ""
    end

    user = User.new(user_row["first_name"], user_row["last_name"], uname, pword, user_row["path"])
    puts "\nHello #{user.name}"

    if user.song_list.songs.length.zero?
        puts "\nFailed to find any music files at \"#{user.dir_location}\"."
        puts "Please add music files at this location and come back. Bye for now"
        exit 0
    end

    sleep(2)
    return user
end

# List user songs
def list_all_songs(main_library)
    loop do
        system("clear")
        main_library.list_songs
        puts "\n\nPress 1: Play All songs"
        puts "Press 2: Play specific song"
        puts "Press 3: Shuffle play songs"
        puts "Press 4: Go Back"
        user_input = gets.chomp.to_i

        case user_input
        when 1
            main_library.play_all

        when 2
            puts "Please input the song no you want to play:"
            main_library.play_song(gets.chomp.to_i)

        when 3
            main_library.shuffle_play

        when 4
            break

        else
            puts "Invalid Input. Please try again with a valid input"
            sleep(2)
        end
    end
end

# Playlist options
def my_playlist(user, main_library)
    loop do
        system("clear")
        puts "Select from below"
        puts "1. Select Playlist"
        puts "2. Create New Playlist"
        puts "3. Go Back"
        user_input = gets.chomp.to_i
        system("clear")

        case user_input
        when 1
            if user.playlist_list.length.zero?
                system("clear")
                puts "You have not created any playlist yet. Lets start by creating a new playlist from previous menu\n\n\n"
                sleep(2)
            else
                user.show_playlists
                puts "Choose playlist No. you would like to go to"
                playlist_number = gets.chomp.to_i
                playlist = user.playlist_list[playlist_number - 1]
                puts "\n\nSongs in your selected playlist:"
                playlist.list_songs
                playlist_operations(user, playlist)
            end

        when 2
            system("clear")
            playlist = user.create_playlist
            system("clear")
            puts "Congratulations! new playlist #{playlist.name} has been created."
            puts "The #{playlist.name} playlist contains following songs:"
            playlist.list_songs
            playlist_operations(user, playlist)

        when 3
            break

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
        puts "\n\n\nWhat would you like to do now?"
        puts "1. Play all songs"
        puts "2. View all songs"
        puts "3. Shuffle play songs"
        puts "4. Edit Playlist"
        puts "5. Delete Playlist"
        puts "6. Go Back"
        user_input = gets.chomp.to_i
        system("clear")
        case user_input
        when 1
            playlist.play_all

        when 2
            playlist.list_songs

        when 3
            playlist.shuffle_play

        when 4
            playlist.edit_playlist(user.song_list, playlist_file_path)

        when 5
            user.delete_playlist(playlist)
            break

        when 6
            break

        else
            puts "Invalid Input. Please try again with a valid input"
            sleep(2)
        end
    end
end

music_library
