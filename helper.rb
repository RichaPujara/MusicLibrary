require 'tty-font'
require 'rainbow'
require './exceptions'

# Logo
def show_logo
    system("clear")
    font = TTY::Font.new(:doom)
    puts_gold("Welcome to")
    puts Rainbow(font.write("MY  MUSIC  WORLD")).royalblue.bright
    puts_gold("Your CLI based music manager.\n")
end

# Close the application gracefully
def exit_app
    puts Rainbow("\nThank you for using My Music Manager today.. See you soon..").cyan.bright
    exit 0
end

# Display coloured text
def puts_rosybrown(text)
    puts Rainbow(text).rosybrown
end

def puts_lightcoral(text)
    puts Rainbow(text).lightcoral
end

def puts_indianred(text)
    puts Rainbow(text).indianred
end

def puts_gold(text)
    puts Rainbow(text).gold
end

# Display Menu question, option and get user input
def menu_option(question, options, logo_show)
    show_logo if logo_show
    puts_rosybrown(question)
    options.each_with_index do |element, index|
        puts_lightcoral("Press #{index + 1}: #{element}")
    end
    puts_indianred("Press #{options.length + 1}: To close My Music World")
    gets.chomp.to_i
end

# Display invalid input message
def show_invalid_input
    puts "Invalid Input. Please try again with a valid input"
    sleep(2)
end

def get_song_diff(song_list1, song_list2)
    songs_diff = []
    song_list1.each do |song|
        not_in_list = false
        song_list2.each do |playlist_song|
            if playlist_song.song_title == song.song_title
                not_in_list = true
                break
            end
        end
        songs_diff.push(song) unless not_in_list
    end
    songs_diff
end

def get_song_choices(msg, max)
        puts msg
        input = gets.strip
        unless input.split(',').all? { |num| num =~ /\d+/ && num.to_i.positive? && num.to_i < max }
            raise InvalidInputError
        end

        input.split(',')
rescue InvalidInputError
        puts "Song number choice is invalid. Lets try again\n"
        retry
end

def get_user_playlist_choice(max)
        puts "\nChoose Playlist Number you would like to go to. Press 0 to go back to previous screen."
        num = gets.strip
        raise InvalidInputError unless num =~ /\d+/ && num.to_i >= 0 && num.to_i < max

        num.to_i
rescue InvalidInputError
        puts "Playlist choice is invalid. Lets try again\n"
        retry
end

def show_playback_options
    puts_gold("\n\nPress 's' or spacebar to pause and unpause music")
    puts_gold("Press 'f' to play next track")
    puts_gold("Press 'd' to play previous track")
    puts_gold("Press 'b' to play from beginning of track")
    puts_gold("Press 't' to display track information")
    puts_gold("Press 'q' to quit music player")
    puts_gold("Press 'h' to view more music player options")
end
