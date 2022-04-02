require './playlist'
require './song'
require 'json'

describe Playlist do
    let(:my_playlist) { Playlist.new("Playlist1") }
    before do
        allow(::Kernel).to receive(:system)
        allow_any_instance_of(Object).to receive(:sleep)
    end

    it "creates a new song when initialize" do
        expect(my_playlist).not_to be_nil
        expect(my_playlist).to be_an_instance_of Playlist
    end

    describe "#name" do
        it "returns playlist name" do
            expect(my_playlist.name).to eq "Playlist1"
        end
    end

    describe "#songs" do
        it "returns the array of the songs" do
            expect(my_playlist.songs).to eq []
        end
    end

    describe "#add_song(new_song)" do
        it "add song to playlist song list" do
            song = Song.new("name", "path")
            my_playlist.add_song(song)
            expect(my_playlist.songs).to eq [song]
        end
    end

    describe "#list_songs(song_name)" do
        it "list playlist songs" do
            song = Song.new("name", "path")
            my_playlist.add_song(song)
            expect { my_playlist.list_songs }.to output("1. name\n").to_stdout
        end
    end

    describe "#shuffle_play" do
        it "shuffle play playlist songs" do
            actual_stdout = $stdout
            $stdout = File.open(File::NULL, "w")
            song = Song.new("name", "path")
            my_playlist.add_song(song)
            expect_any_instance_of(Kernel).to receive(:system).with "mpg123 -q path "
            my_playlist.shuffle_play
            $stdout = actual_stdout
        end
    end

    describe "#play_song(song_no)" do
        it "play a song from playlist" do
            actual_stdout = $stdout
            $stdout = File.open(File::NULL, "w")
            song = Song.new("name", "path")
            my_playlist.add_song(song)
            expect_any_instance_of(Kernel).to receive(:system).with "mpg123 -q path"
            my_playlist.play_song(0)
            $stdout = actual_stdout
        end
    end

    describe "#play_all" do
        it "play all songs in playlist" do
            actual_stdout = $stdout
            $stdout = File.open(File::NULL, "w")
            song = Song.new("name", "path")
            my_playlist.add_song(song)
            expect_any_instance_of(Kernel).to receive(:system).with "mpg123 -q path "
            my_playlist.play_all
            $stdout = actual_stdout
        end
    end

    describe "#add_songs_to_playlist(main_library, playlist_file_path)" do
        it "add songs to an existing playlist list" do
            actual_stdout = $stdout
            $stdout = File.open(File::NULL, "w")
            song = Song.new("name", "path")
            my_playlist.add_song(song)

            main_library = Playlist.new("Main_Library")
            song2 = Song.new("name2", "path2")
            song3 = Song.new("name3", "path3")
            main_library.add_song(song)
            main_library.add_song(song2)
            main_library.add_song(song3)

            allow($stdin).to receive(:gets).and_return('1')
            my_playlist.add_songs_to_playlist(main_library, "test.playlist")
            expect(my_playlist.songs).to eq [song, song2]
            File.delete("test.playlist")
            $stdout = actual_stdout
        end
    end

    describe "#remove_songs_from_playlist(playlist_file_path)" do
        it "remove songs from existing playlist list" do
            actual_stdout = $stdout
            $stdout = File.open(File::NULL, "w")
            song = Song.new("name", "path")
            my_playlist.add_song(song)

            allow($stdin).to receive(:gets).and_return('1')
            my_playlist.remove_songs_from_playlist("test.playlist")
            expect(my_playlist.songs).to eq []
            File.delete("test.playlist")
            $stdout = actual_stdout
        end
    end
end
