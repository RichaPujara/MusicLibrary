require './song'
require './helper'

# Class that defines user's playlist
class Playlist
    attr_accessor :name, :songs

    def initialize(name)
        @name = name
        @songs = []
    end

    def edit_playlist(main_library, playlist_file_path)
        loop do
            show_logo
            puts "What would you like to do?"
            puts "Press 1. Add more songs"
            puts "Press 2. Delete songs"
            puts "Press 3. Go Back to previous screen"
            puts "Press 4: To close My Music World"
            user_input = gets.chomp.to_i
            show_logo

            case user_input
            when 1
                add_songs_to_playlist(main_library, playlist_file_path)

            when 2
                remove_songs_from_playlist(playlist_file_path)

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

    def add_songs_to_playlist(main_library, playlist_file_path)
        songs_not_in_users_playlist = Playlist.new("songs_not_in_users_playlist")
        main_library.songs.each do |song|
            not_in_playlist = false
            @songs.each do |playlist_song|
                if playlist_song.song_title == song.song_title
                    not_in_playlist = true
                    break
                end
            end

            songs_not_in_users_playlist.add_song(song) unless not_in_playlist
        end

        puts "Songs not in #{@name} Playlist but in your music library:\n"
        songs_not_in_users_playlist.list_songs
        puts "\nPlease select the song numbers you want to add into #{@name} Playlist:"
        sel = gets.chomp.split(",").to_a
        sel.each do |s|
            add_song(songs_not_in_users_playlist.songs["#{s}".to_i - 1])
        end

        save_playlist(playlist_file_path)

        puts "\n\nCongratulations! your Playlist #{@name} has been updated."
        puts "The #{@name} Playlist now contains following songs:"
        list_songs
        sleep(2)
    end

    def add_song(new_song)
        @songs.push(new_song)
    end

    def remove_songs_from_playlist(playlist_file_path)
        puts "Songs in your Playlist:\n"
        list_songs
        puts "\nSelect the songs numbers that you want to delete from #{@name} Playlist:"
        sel = gets.chomp.split(",").to_a
        sel.each do |s|
            remove_song(@songs["#{s}".to_i - 1])
        end

        save_playlist(playlist_file_path)

        puts "\n\nCongratulations! Your Playlist #{@name} has been updated."
        puts "The #{@name} Playlist now contains following songs:"
        list_songs
        sleep(2)
    end

    def remove_song(song_name)
        @songs.delete(song_name)
        return @song
    end

    def list_songs
        @songs.each_with_index do |song, index|
            puts "#{index + 1}. #{song.song_title}"
        end
    end

    def shuffle_play
        shuffled_songs = @songs.shuffle

        puts "Shuffled songs in #{@name} Playlist and playing them in following order"
        shuffled_songs.each_with_index do |song, index|
            puts "#{index + 1}. #{song.song_title}"
        end

        shuffled_songs.each do |song|
            system("play -V1 -q -S #{song.song_path}")
        end
    end

    def play_song(song_no)
        song = @songs[song_no - 1]
        system("play -V1 -q -S #{song.song_path}")
    end

    def play_all
        @songs.each do |song|
            system("play -V1 -q -S #{song.song_path}")
        end
    end

    def save_playlist(playlist_file_path)
        File.open(playlist_file_path.to_s, "w") do |f|
            f.puts @songs.to_json
        end
    end
end
