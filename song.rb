require 'json'

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
        system("play -V1 -q -S #{@song_path}")
    end
end
