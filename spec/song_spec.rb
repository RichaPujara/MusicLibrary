require './song'
require 'json'

describe Song do
    let(:song) { Song.new("SONG_NAME", "SONG_PATH") }
    before { allow(::Kernel).to receive(:system) }

    it "creates a new song when initialize" do
        expect(song).not_to be_nil
        expect(song).to be_an_instance_of Song
    end

    describe "#song_title" do
        it "returns song-title" do
            expect(song.song_title).to eq "SONG_NAME"
        end
    end

    describe "#song_path" do
        it "returns absolute path to the song" do
            expect(song.song_path).to eq "SONG_PATH"
        end
    end

    describe "#to_json(*arr)" do
        it "returns songs array as json" do
            songs = []
            songs.push(song)
            expect(songs.to_json).to eq "[{\"song_title\":\"SONG_NAME\",\"song_path\":\"SONG_PATH\"}]"
        end
    end

    describe "#change_song_title(new_song_title)" do
        it "changes the song title to new_song_title" do
            expect(song.change_song_title("new_song_title")).to eq "new_song_title"
        end
    end

    describe "#change_artist(new_artist)" do
        it "changes the artist's name to new_artist" do
            expect(song.change_artist("new_artist")).to eq "new_artist"
        end
    end

    describe "#change_genre(new_genre)" do
        it "changes the artist's name to new_genre" do
            expect(song.change_artist("new_genre")).to eq "new_genre"
        end
    end

    describe "#change_playtime(new_playtime)" do
        it "changes the artist's name to new_playtime" do
            expect(song.change_artist("new_playtime")).to eq "new_playtime"
        end
    end
end
