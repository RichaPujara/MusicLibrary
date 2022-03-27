require "./classes"
require "shellwords"

private def music_library
    puts "Welcome to MY MUSIC WORLD - Your CLI based music manager."
    puts "Let's organize your music files"

    path = "/Users/richa/Desktop/Sandeep/music"
    puts "Using #{path} as your music library base"

    song_lib = []
    music_dir = []

    Dir.each_child(path) do |file_name|
        if file_name.include?(".mp3")
            file_path = File.join(path, Shellwords.escape(file_name))
            new_song = Song.new(file_name, file_path)
            song_lib.push(new_song)
        else
            music_dir.push(file_name)
        end
    end

    print "\nsongs List :\n"
    song_lib.each {|song| puts song.song_title}
    puts ""
    puts "Other folders at provided path: #{music_dir}"
    system("play -V1 -q -S #{song_lib[0].song_path}")



end

music_library


