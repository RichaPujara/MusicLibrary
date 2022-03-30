require './user'
require 'json'
require 'fileutils'

describe User do
    let(:user) { User.new("Jane", "Doe", "username", "password", "resources") }
    after(:all) { FileUtils.rm_rf("data/username") }

    it 'creates a new User when initialized' do
        expect(user).not_to be_nil
        expect(user).to be_an_instance_of User
    end

    describe "#name" do
        it 'returns name as first name last name' do
            expect(user.name).to eq "Jane Doe"
        end
    end

    describe "#username" do
        it "returns username" do
            expect(user.username).to eq "username"
        end
    end

    describe "#password" do
        it "returns the password" do
            expect(user.password).to eq "password"
        end
    end

    describe "#song_list" do
        it "check all songs in music directory loaded" do
            expect(user.song_list.songs.length).to eq 3
        end
    end

    describe "#playlist_list" do
        it "check playlist loaded from user directory" do
            expect(user.playlist_list.length).to eq 0
        end
    end

    describe "#create_playlist" do
        it "create a new playlist" do
            $stdout = File.open(File::NULL, "w")
            allow(user).to receive(:gets).and_return("test", "1,2")
            user.create_playlist
            expect(user.playlist_list.length).to eq 1
            expect(user.playlist_list[0].name).to eq "test"
            expect(user.playlist_list[0].songs.length).to eq 2
        end
    end

    describe "#show_playlists" do
        it "show users playlist" do
            expect {
                user.show_playlists
            }.to output("1. test\n").to_stdout
        end
    end

    describe "#delete_playlist(playlist)" do
        it "delete playlist from users playlists" do
            user.delete_playlist(user.playlist_list[0])
            expect(user.playlist_list.length).to eq 0
            expect(File.exist?("#{user.music_manager_playlist_dir}/test.playlist")).to eq false
        end
    end
end
