require 'optparse'
require './main'
require './helper'

begin
    username = ""
    password = ""

    option_parser = OptionParser.new do |opts|
        opts.on('-i', 'Install MY MUSIC WORLD dependencies.')
        opts.on('-u username', 'Username used for login, this is required if password provided.') do |user|
            username = user
            if ['-p', '--password'].include? username
                puts_indianred("Please provide valid username.\n")
                puts_royalblue(option_parser)
                exit_app
            end
        end
        opts.on('-p password', 'Password to login.') do |pwd|
            password = pwd
        end
        opts.on('-h', 'Shows MY MUSIC WORLD usage information.') do
            puts_royalblue(option_parser)
            exit_app
        end
    end

    options = {}
    option_parser.parse!(into: options)
    user_list = CSV.parse(File.read("user_list.csv"), headers: true)

    if (username.nil? || username.empty?) && (!password.nil? && !password.empty?)
        puts_indianred("Please also provide username when providing password to login into the app.\n")
        puts_royalblue(option_parser)
        exit_app
    elsif username.nil? || username.empty?
        music_library
    else
        show_logo
        user = login(user_list, username, password)
        main_menu(user)
    end
rescue OptionParser::MissingArgument => e
    if e.args.include?("-u" || "--username")
        puts_indianred("Please provide username value, in the following format: -u username\n")
    end

    if e.args.include?("-p" || "--password")
        puts_indianred("Please provide username value, in the following format: -p password\n")
    end

    puts_royalblue(option_parser)
    exit_app
end
