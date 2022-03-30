require 'tty-font'
require 'rainbow'

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
