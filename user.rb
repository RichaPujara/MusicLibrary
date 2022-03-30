require 'fileutils'
require 'json'
require "shellwords"
require "./playlist"
require "./song"

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
        music_file_formats = [".mp3", ".mp4", ".wav"]
        Dir.each_child(@dir_location) do |file_name|
            next unless music_file_formats.include? File.extname(file_name)

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

    def create_playlist
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
        @song_list.list_songs
        puts "\nPlease select the song no.s you want to add into #{playlist.name} playlist as comma separated list: "
        sel = gets.chomp.split(",").to_a
        sel.each do |s|
            playlist.add_song(@song_list.songs[s.to_i - 1])
        end

        File.open("#{music_manager_playlist_dir}/#{pname}.playlist", "w") do |f|
            f.puts playlist.songs.to_json
        end

        @playlist_list.push(playlist)
        return playlist
    end

    def show_playlists
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
