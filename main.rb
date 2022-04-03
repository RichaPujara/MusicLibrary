require 'tty-prompt'
require "shellwords"
require "io/console"
require 'json'
require 'csv'
require 'rainbow'
require 'fileutils'
require './user'
require './exceptions'
require './helper'

# Entry point of the application
def music_library(username = nil, password = nil)
    user = gets_user(username, password)
    main_menu(user)
end

# Gets the user information
def gets_user(username, password)
    user_file_name = "user_list.csv"
    user_list = CSV.parse(File.read(user_file_name), headers: true, skip_blanks: true)
    return user_mgmt(user_list, user_file_name, username, password) unless user_list.empty?

    return create_user(user_list, user_file_name)
end

def user_mgmt(user_list, user_file_name, uname, pword)
    loop do
        options = ["Yes I am existing user, I would like login", "I am new user, please set my profile"]
        user_input = menu_option("\nAre you existing user", options, true)
        case user_input
        when 1
            return login(user_list, user_file_name, uname, pword)
        when 2
            return create_user(user_list, user_file_name)
        when 3
            exit_app
        else
            show_invalid_input
        end
    end
end

# Create new user
def create_user(user_list, user_file_name)
    show_logo
    puts "Let's get to know you little better.\n\nPlease tell me"
    print "Your first name: "
    fname = $stdin.gets.chomp.upcase
    print "Your last name: "
    lname = $stdin.gets.chomp.upcase
    puts "\nHello #{fname} #{lname}"

    uname = nil
    loop do
        print "Select your username: "
        uname = $stdin.gets.chomp.downcase

        break if user_list.empty?
        break unless user_list.by_col["username"].include? uname

        puts "Username '#{uname}' exists.\n\n"
        user_input = menu_option("Would you like try again with a different username:", ["To try again"], false)
        exit_app if user_input == 2
        puts ""
    end

    print "Select your password: "
    pword = $stdin.noecho(&:gets).chomp
    puts "\n\nThank you.. Let's organize your music files\n"

    begin
        puts "Please add the absolute path to your music directory."
        path = $stdin.gets.chomp
        puts "Using #{path} as your music library base\n"
        user = User.new(fname, lname, uname, pword, path)

        raise NoSongsFoundError if user.song_list.songs.length.zero?

        puts "\nCongratulations! Your Music Library profile been created."

        CSV.open(user_file_name, "a", headers: true) do |csv|
            csv << [user.first_name, user.last_name, user.username, user.password, user.dir_location]
        end

        puts "\nYour music library has following songs.\n\n"
        user.song_list.list_songs
        puts "\n\n"
        sleep(2)
        return user
    rescue Errno::ENOENT, NoSongsFoundError
        puts_indianred("\nThere seems to be some error with the path provided. " \
                       "Either the path is invalid or no music files found at the path.\n\n")
        user_input = menu_option("Would you like try again:", ["To try again"], false)
        exit_app if user_input == 2
        puts ""
        retry
    end
end

# Login a user
def login(user_list, user_file_name, uname, pword)
    if user_list.empty?
        puts_indianred("There are no users setup currently, Lets start with setting you up.\n")
        sleep(2)
        return create_user(user_list, user_file_name)
    end

    loop do
        if uname.nil? || uname.empty?
            print "Please enter username: "
            uname = $stdin.gets.chomp.downcase
        end

        break if user_list.empty?
        break if user_list.by_col["username"].include? uname

        puts "Username '#{uname}' unknown.\n\n"
        user_input = menu_option("Would you like try again:", ["To try again", "Create new profile"], false)
        return create_user(user_list, user_file_name) if user_input == 2

        exit_app if user_input == 3
        uname = nil
        puts ""
    end

    user_row = user_list.find { |row| row["username"] == uname }

    loop do
        if pword.nil? || pword.empty?
            print "Please enter password: "
            pword = $stdin.noecho(&:gets).chomp
        end

        break if user_list.empty?
        break if user_row["password"] == pword

        puts "\nInvalid Password.\n\n"
        user_input = menu_option("Would you like try again:", ["To try again", "Create new profile"], false)
        return create_user(user_list, user_file_name) if user_input == 2

        exit_app if user_input == 3
        puts ""
        pword = nil
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

# Show application main menu
def main_menu(user)
    main_library = user.song_list
    loop do
        user_input = menu_option("What would you like to do?\n", ["List all Music files", "My Playlists"], true)

        case user_input
        when 1
            all_songs_menu(main_library)

        when 2
            my_playlist_menu(user, main_library)

        when 3
            exit_app

        else
            show_invalid_input
        end
    end
end

# List user songs and operations on it
def all_songs_menu(main_library)
    loop do
        show_logo
        main_library.list_songs
        break if all_song_operations_menu(main_library) == -1
    end
end

# Operate on a song list
def all_song_operations_menu(main_library)
    options = ["Play All songs", "Play specific song", "Shuffle play songs", "Go Back to previous screen"]
    user_input = menu_option("\n\n", options, false)
    case user_input
    when 1
        main_library.play_all
    when 2
        song_numbers = get_song_choices("Please input the song no you want to play:", main_library.songs.length + 1)
        song_numbers.each { |song_number| main_library.play_song(song_number.to_i - 1) }
    when 3
        main_library.shuffle_play
    when 4
        return -1
    when 5
        exit_app
    else
        show_invalid_input
    end
end

# Show playlist operations
def my_playlist_menu(user, _main_library)
    loop do
        options = ["Select Playlist", "Create New Playlist", "Go Back to previous screen"]
        user_input = menu_option("Select from below", options, true)
        case user_input
        when 1
            select_playlist(user)
        when 2
            create_playlist(user)
        when 3
            break
        when 4
            exit_app
        else
            show_invalid_input
        end
    end
end

# Get user to create a playlist
def create_playlist(user)
    show_logo
    playlist = user.create_playlist
    playlist_operations_menu(user, playlist)
end

# Get user to select a playlist
def select_playlist(user)
    show_logo
    if user.playlist_list.length.zero?
        puts "You have not created any Playlist yet. Lets start by creating a new Playlist\n"
        sleep(2)
        create_playlist(user)
    else
        select_a_playlist(user)
    end
end

# Select a playlist
def select_a_playlist(user)
    user.show_playlists
    playlist_number = get_user_playlist_choice(user.playlist_list.length + 1)

    return if playlist_number.zero?

    playlist = user.playlist_list[playlist_number - 1]
    playlist_operations_menu(user, playlist)
end

# Operate on a selected playlist
def playlist_operations_menu(user, playlist)
    loop do
        playlist_file_path = "#{user.music_manager_playlist_dir}/#{playlist.name}.playlist"
        show_logo
        puts "Songs in the Playlist:"
        playlist.list_songs
        opt = ["Play all songs", "Shuffle play songs", "Edit Playlist", "Delete Playlist", "Go Back to previous screen"]
        user_input = menu_option("\n\n\nWhat would you like to do now?", opt, false)
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
            show_invalid_input
        end
    end
end
