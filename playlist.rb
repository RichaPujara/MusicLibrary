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
            options = ["Add more songs", "Delete songs", "Go Back to previous screen"]
            user_input = menu_option("What would you like to do?", options, true)

            case user_input
            when 1
                show_logo
                add_songs_to_playlist(main_library, playlist_file_path)

            when 2
                show_logo
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
        if songs_not_in_users_playlist.empty?
             puts_indianred("All songs in your library in #{@name} Playlist. So can't add anymore songs.\n")
             sleep(2)
             return
        end
        puts "Songs not in #{@name} Playlist but in your music library:\n"
        list_songs(songs_not_in_users_playlist)
        msg = "\nPlease select the song numbers you want to add into #{@name} Playlist:"
        song_numbers = get_song_choices(msg, songs_not_in_users_playlist.length + 1)
        add_songs(songs_not_in_users_playlist, song_numbers)
        save_playlist(playlist_file_path)
        show_updated_playlist
    end

    def add_songs(songs, song_numbers)
        song_numbers.each { |song_number| @songs.push(songs[song_number.to_i - 1]) }
    end

    def add_song(new_song)
        @songs.push(new_song)
    end

    def remove_songs_from_playlist(playlist_file_path)
        puts "Songs in your Playlist:\n"
        list_songs
        msg = "\nSelect the songs numbers that you want to delete from #{@name} Playlist:"
        song_numbers = get_song_choices(msg, @songs.length + 1)
        songs_to_delete = []
        song_numbers.each { |number| songs_to_delete.push(@songs[number.to_i - 1]) }
        @songs -= songs_to_delete
        save_playlist(playlist_file_path)
        show_updated_playlist
    end

    def show_updated_playlist
        puts "\n\nCongratulations! Your Playlist #{@name} has been updated."
        puts "The #{@name} Playlist now contains following songs:"
        list_songs
        sleep(2)
    end

    def list_songs(songs = @songs)
        songs.each_with_index { |song, index| puts "#{index + 1}. #{song.song_title}" }
    end

    def shuffle_play
        shuffled_songs = @songs.shuffle
        puts "Shuffled songs in #{@name} Playlist and playing them in following order"
        shuffled_songs.each_with_index { |song, index| puts "#{index + 1}. #{song.song_title}" }
        play_all(shuffled_songs)
    end

    def play_song(song_no)
        play(@songs[song_no].song_path.to_s)
    end

    def play_all(songs = @songs)
        song_paths = ""
        songs.each { |song| song_paths = "#{song_paths}#{song.song_path} " }
        play(song_paths)
    end

    def play(song_paths)
        show_playback_options
        status = system("mpg123 -q #{song_paths}")
        raise NoMediaPlayerError unless status == true
    rescue NoMediaPlayerError
            puts_indianred("\nSorry! You don't have supported media player installed on your device.\n" \
                           "Please refer to ReadMe.md for help.")
            sleep(6)
    end

    def save_playlist(playlist_file_path)
        File.open(playlist_file_path.to_s, "w") { |f| f.puts @songs.to_json }
    end
end
