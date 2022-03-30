require 'tty-font'
require 'pastel'

# Logo
def show_logo
    system("clear")
    font = TTY::Font.new(:doom)
    pastel = Pastel.new
    puts pastel.bright_yellow("Welcome to")
    puts pastel.bright_magenta(font.write("MY  MUSIC  WORLD"))
    puts pastel.bright_yellow("Your CLI based music manager.\n")
end
