require 'csv'

class Song
    attr_reader :song_title, :song_path
    attr_accessor :in_playlists, :genre, :artist, :playtime

    def initialize(song_title, song_path, artist = "not defined", genre = "not defined", playtime = "not defined")
        @song_title = song_title
        @song_path = song_path
        @in_playlists = []
        @artist = artist
        @genre = genre
        @playtime = playtime
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
    # def song_path
    #     @song_path.to_s
    # end
end

class User
    attr_accessor :playlist_list, :song_list
    attr_reader :dir_location, :first_name, :last_name, :username, :password

    def initialize(first_name, last_name, username, password, path)
        @first_name = first_name
        @last_name = last_name
        @username = username
        @playlist_list = []
        @password = password
        @song_list = []
        @dir_location = path
    end

    def name
        "#{@first_name} #{@last_name}"
    end

    def change_username(new_username)
        @username = new_username
    end

    def create_playlist(new_playlist)
        Playlist.new(new_playlist)
    end

    def add_playlist(new_playlist)  # check rspec
        @playlist_list.push(new_playlist)
    end
end

class Playlist
    attr_accessor :name, :songs

    def initialize(name)
        @name = name
        @songs_list = []
    end

    def add_song(new_song)
        @songs_list.push(new_song)
    end

    def remove_song(song_name)
        @songs_list.delete(song_name)
        return @song_list
    end

    def save(playlist)
        CSV.open(File.open("./#{playlist}.csv","w"))
    end

    def shuffle_songs(playlist)
        playlist.shuffle
    end
end
