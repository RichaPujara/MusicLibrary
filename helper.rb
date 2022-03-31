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
def menu_option(question, options)
    puts_rosybrown(question)
    options.each_with_index do |element, index|
        puts_lightcoral("Press #{index + 1}: #{element}")
    end
    puts_indianred("Press #{options.length + 1}: To close My Music World")
    gets.chomp.to_i
end
