require './classes.rb'

# describe Music_Library do
#     describe User do
#         it "creates a new user when initialize" do

#         end
#     end
# end
# describe MusicFinder do
#     it "returns the list of files from the directory(path)" do
#        expect(get_files(path)) .to eq 


#     end
# end

describe User do 
    let(:user) { User.new("Richa", "Pujara", "Richa_Pujara", "password", "/Users/richa/Desktop/Sandeep/music") }
    it 'creates a new User when initialized' do
        # user = User.new('Richa', 'Pujara', 'Richa_Pujara')
        expect(user).not_to be_nil
        expect(user).to be_an_instance_of User
    end

    describe "#name" do
        it 'returns name as first name last name' do
            expect(user.name).to eq "Richa Pujara"
        end
    end

    describe "#username" do
        it "returns username" do
            expect(user.username).to eq "Richa_Pujara"
        end
    end

    describe "#password" do
        it "returns the password" do
            expect(user.password).to eq "password"
        end
    end
    describe "#change_username(new_username)" do
        it "changes the username to new username" do
            expect(user.change_username("sandeep")).to eq "sandeep"
        end
    end

    describe "#create_playlist(new_playlist)" do
        it "creates a new instance of Playlist" do
            expect(user.create_playlist("new_playlist")).to be_an_instance_of Playlist
        end
    end
    describe "#add_playlist(new_playlist)" do
        xit "adds the new_playlist to user's playlists" do
            expect(user.add_playlist("new_playlist")).to 
        end
    end
end

describe Song do
    let(:song) { Song.new("Srivalli.mp3", "/Users/richa/Desktop/Sandeep/music/") }

    it "creates a new song when initialize" do
        expect(song).not_to be_nil
        expect(song).to be_an_instance_of Song
    end

    describe "#song_title" do
        it "returns song-title" do
            expect(song.song_title).to eq "Srivalli.mp3"
        end
    end

    describe "#song_path" do
        it "returns absolute path to the song" do
            expect(song.song_path).to eq "/Users/richa/Desktop/Sandeep/music/"
        end
    end

    describe "#change_song_title(new_song_title)" do
        it "changes the song title to new_song_title" do
            expect(song.change_song_title("new song title")).to eq "new song title"
        end
    end

    describe "#change_artist(new_artist)" do
        it "changes the artist's name to new_artist" do
            expect(song.change_artist("new artist")).to eq "new artist"
        end
    end

    describe "#change_genre(new_genre)" do
        it "changes the artist's name to new_genre" do
            expect(song.change_artist("new genre")).to eq "new genre"
        end
    end
    describe "#change_playtime(new_playtime)" do
        it "changes the artist's name to new_playtime" do
            expect(song.change_artist("new playtime")).to eq "new playtime"
        end
    end

end


