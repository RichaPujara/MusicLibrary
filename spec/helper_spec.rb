require './helper'

describe "#get_song_choices(msg, max)" do
    it "get song numbers as valid array of numbers within range" do
        allow($stdin).to receive(:gets).and_return('1,2,3')
        expect { get_song_choices("test msg", 5) }.to output("test msg\n").to_stdout and eq %w[1 2 3]
    end

    it "get song numbers as valid array of numbers within range on third try" do
        allow($stdin).to receive(:gets).and_return('1, ,a', '1,2,0', '1,2,3')
        expected_puts = "test msg\nSong number choice is invalid. Lets try again\n\n" \
                        "test msg\nSong number choice is invalid. Lets try again\n\n"\
                        "test msg\n"
        expect { get_song_choices("test msg", 5) }.to output(expected_puts).to_stdout and eq %w[1 2 3]
    end
end

describe "#get_user_playlist_choice(max)" do
    it "get valid playlist number(integer within the range)" do
        allow($stdin).to receive(:gets).and_return("3")
        expected_puts = "\nChoose Playlist Number you would like to go to. Press 0 to go back to previous screen.\n"
        expect { get_user_playlist_choice(5) }.to output(expected_puts).to_stdout and eq 3
    end

    it "get valid playlist number(integer within the range) on fourth try" do
        allow($stdin).to receive(:gets).and_return('a bg', '-3', '4')
        expected_puts = "\nChoose Playlist Number you would like to go to. Press 0 to go back to previous screen.\n" \
                        "Playlist choice is invalid. Lets try again\n\n" \
                        "\nChoose Playlist Number you would like to go to. Press 0 to go back to previous screen.\n" \
                        "Playlist choice is invalid. Lets try again\n\n" \
                        "\nChoose Playlist Number you would like to go to. Press 0 to go back to previous screen.\n"
        expect { get_user_playlist_choice(5) }.to output(expected_puts).to_stdout and eq 4
    end
end
