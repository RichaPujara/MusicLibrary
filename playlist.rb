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
            options = ["Add more songs", "Delete songs", "Go Back to previous screen"]
            user_input = menu_option("What would you like to do?", options)
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
                show_invalid_input
            end
        end
    end

    def add_songs_to_playlist(main_library, playlist_file_path)
        songs_not_in_users_playlist = get_song_diff(main_library.songs, @songs)
        puts "Songs not in #{@name} Playlist but in your music library:\n"
        list_songs(songs_not_in_users_playlist)
        song_numbers = get_user_song_choices("\nPlease select the song numbers you want to add into #{@name} Playlist:", songs_not_in_users_playlist.length + 1)
        add_songs(songs_not_in_users_playlist, song_numbers)
        save_playlist(playlist_file_path)
        puts "\n\nCongratulations! your Playlist #{@name} has been updated."
        puts "The #{@name} Playlist now contains following songs:"
        list_songs
        sleep(2)
    end

    def add_songs(songs, song_numbers)
        song_numbers.each do |song_number|
            add_song(songs[song_number.to_i - 1])
        end
    end

    def add_song(new_song)
        @songs.push(new_song)
    end

    def remove_songs_from_playlist(playlist_file_path)
        puts "Songs in your Playlist:\n"
        list_songs
        song_numbers = get_user_song_choices("\nSelect the songs numbers that you want to delete from #{@name} Playlist:", @songs.length + 1) 
        remove_songs(song_numbers)
        save_playlist(playlist_file_path)
        puts "\n\nCongratulations! Your Playlist #{@name} has been updated."
        puts "The #{@name} Playlist now contains following songs:"
        list_songs
        sleep(2)
    end

    def remove_songs(song_numbers)
        song_numbers.each do |song_number|
            remove_song(@songs[song_number.to_i - 1])
        end
    end

    def remove_song(song_name)
        @songs.delete(song_name)
        return @song
    end

    def list_songs(songs = @songs)
        songs.each_with_index do |song, index|
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
        song = @songs[song_no]
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
