require 'fileutils'
require 'json'

# Class that defines music player users
class User
    attr_accessor :playlist_list, :song_list, :other_dir, :music_manager_playlist_dir
    attr_reader :dir_location, :first_name, :last_name, :username, :password

    def initialize(first_name, last_name, username, password, path)
        @first_name = first_name
        @last_name = last_name
        @username = username
        @playlist_list = []
        @password = password
        @song_list = Playlist.new("Main_Library")
        @dir_location = path

        create_library
        create_playlist_directory
        read_playlists
    end

    def name
        "#{@first_name} #{@last_name}"
    end

    def create_library
        Dir.each_child(@dir_location) do |file_name|
            next unless file_name.include?(".mp3" || ".mp4" || ".wav")

            file_path = File.join(@dir_location, Shellwords.escape(file_name))
            new_song = Song.new(file_name, file_path)
            @song_list.songs.push(new_song)
        end
        return @song_list
    end

    def create_playlist_directory
        @music_manager_playlist_dir = "data/#{@username}/playlists"
        FileUtils.mkdir_p(@music_manager_playlist_dir.to_s) unless File.directory?(@music_manager_playlist_dir.to_s)
        @music_manager_playlist_dir
    end

    def create_playlist(main_library)
        music_manager_playlist_dir = create_playlist_directory
        pname = nil
        loop do
            puts "Add the playlist Name:"
            pname = gets.chomp
            break unless File.exist?("#{music_manager_playlist_dir}/#{pname}.playlist")

            puts "Playlist with name \"#{pname}\" already exists. Please provide a different playlist name"
        end
        playlist = Playlist.new(pname)

        puts "\nSongs in your music library:"
        main_library.list_songs
        puts "\nPlease select the song no.s you want to add into #{playlist.name} playlist as comma separated list: "
        sel = gets.chomp.split(",").to_a
        sel.each do |s|
            playlist.add_song(main_library.songs[s.to_i - 1])
        end

        File.open("#{music_manager_playlist_dir}/#{pname}.playlist", "w") do |f|
            f.puts playlist.songs.to_json
        end

        @playlist_list.push(playlist)
        return playlist
    end

    def playlists
        @playlist_list.each_with_index do |playlist, index|
            puts "#{index + 1}. #{playlist.name}"
        end
    end

    def read_playlists
        Dir.each_child(@music_manager_playlist_dir) do |file_name|
            next unless file_name.include?(".playlist")

            playlist = Playlist.new(file_name.sub(".playlist", ""))
            File.readlines("#{@music_manager_playlist_dir}/#{file_name}").map do |line|
                json_obj = JSON.parse(line)
                json_obj.each do | song_json |
                    playlist.add_song(Song.new(song_json["song_title"], song_json["song_path"]))
                end
            end
            @playlist_list.push(playlist)
        end
        return @playlist_list
    end

    def delete_playlist(playlist)
       File.delete("#{@music_manager_playlist_dir}/#{playlist.name}.playlist")
       playlist_list.delete(playlist)
       playlist
    end
end

# Class that defines Songs
class Song
    attr_reader :song_title, :song_path
    attr_accessor :genre, :artist, :playtime

    def initialize(song_title, song_path, artist = "not defined", genre = "not defined", playtime = "not defined")
        @song_title = song_title
        @song_path = song_path
        @artist = artist
        @genre = genre
        @playtime = playtime
    end

    def to_json(*arr)
        { 'song_title' => @song_title.to_s, 'song_path' => @song_path.to_s }.to_json(*arr)
    end

    def change_song_title(new_song_title)
        @song_title = new_song_title
    end

    def change_artist(new_artist)
        @artist = new_artist
    end

    def change_genre(new_genre)
        @genre =  new_genre
    end

    def change_playtime(new_playtime)
        @playtime = new_playtime
    end

    def play_song
        system("play -V1 -q #{@song_path}")
    end

    def pause_song
        system("kill -#{@cmd[@toggle_pause]} #{`pidof play`.chomp} > /dev/null")
    end
end

# Class that defines user's playlist
class Playlist
    attr_accessor :name, :songs

    def initialize(name)
        @name = name
        @songs = []
    end

    def edit_playlist(main_library, playlist_file_path)
        loop do
            puts "What would you like to do?"
            puts "1. Add more songs"
            puts "2. Delete songs"
            puts "3. Go back"
            user_input = gets.chomp.to_i
            case user_input
            when 1
                add_songs_to_playlist(main_library, playlist_file_path)

            when 2
                remove_songs_from_playlist(playlist_file_path)

            when 3
                break

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

        songs_not_in_users_playlist.list_songs
        puts "Please select the song no.s you want to add into #{@name} playlist: "
        sel = gets.chomp.split(",").to_a
        sel.each do |s|
            add_song(songs_not_in_users_playlist.songs["#{s}".to_i - 1])
        end

        write_playlist_to_file(playlist_file_path)

        system("clear")
        puts "Congratulations! your playlist #{@name} has been updated."
        puts "The #{@name} playlist now contains following songs:"
        list_songs
    end

    def add_song(new_song)
        @songs.push(new_song)
    end

    def remove_songs_from_playlist(playlist_file_path)
        list_songs
        puts "Select the no of songs you want to delete from #{@name} playlist:"
        sel = gets.chomp.split(",").to_a
        sel.each do |s|
            remove_song(@songs["#{s}".to_i - 1])
        end

        write_playlist_to_file(playlist_file_path)

        system("clear")
        puts "Congratulations! Your playlist #{@name} has been updated."
        puts "The #{@name} playlist now contains following songs:"
        list_songs
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

        puts "Shuffled songs and playing them in following order"
        shuffled_songs.each_with_index do |song, index|
            puts "#{index + 1}.#{song.song_title}"
        end

        shuffled_songs.each do |song|
            system("play -V1 -q -S #{song.song_path}")
        end
    end

    def play_song(song_no)
        song = @songs[song_no + 1]
        system("play -V1 -q -S #{song.song_path}")
    end

    def play_all
        @songs.each do |song|
            system("play -V1 -q -S #{song.song_path}")
        end
    end

    def write_playlist_to_file(playlist_file_path)
        File.open(playlist_file_path.to_s, "w") do |f|
            f.puts @songs.to_json
        end
    end
end