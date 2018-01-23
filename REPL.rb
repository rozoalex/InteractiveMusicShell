require 'yaml/store'
require './ReplHelper.rb'
require './Track.rb'
require './Artist.rb'
require './PlayedHistory.rb'

class REPL
  def initialize
    #@VERSION = "0.0.1"
    @WELCOME = "Interactive Mu$ic $hell version #{@VERSION} $tarted."
    @NEWCOMMAND = "im$> "
    @HELP = open('user_manual').read
    @store = YAML::Store.new 'store.yml' 
    @tracksToArtists, @artistsToTracks, played = ReplHelper.recover @store
    #A double way map
    @playedHistory = PlayedHistory.new(played, 3)
  end

  def start
    while true
      print @NEWCOMMAND
      command = gets.chomp.to_s
      command.strip! #no write spaces
      break if command == "exit"
      self.process command
    end
    @store.transaction do
      @store[:hist] = @playedHistory.save
    end
  end

  def process command
    if command == "help"
      puts @HELP
    elsif command.match(/^add artist/) #add a new artist
      self.addNewArtisit command
    elsif command.match(/^add tracks/) #add a new track
      self.addNewTrack command
    elsif command == "info"
      ReplHelper.printDetails @tracksToArtists, @artistsToTracks
      @playedHistory.print
    elsif command.match(/^info track/)
      ReplHelper.printTrackDetails command[11..-1], @tracksToArtists, @artistsToTracks
    elsif command.match(/^info artist/)
      ReplHelper.printArtistDetails command[12..-1], @tracksToArtists, @artistsToTracks, true
    elsif command.match(/^count tracks by /)
      tracks = @artistsToTracks[command[16..-1]]
      if tracks != nil 
        puts "#{tracks.length-1}"
      else
        puts "Artist ID {#{command[16..-1]}} not found."
      end
    elsif command.match(/^list tracks by /)
      ReplHelper.printArtistDetails command[15..-1], @tracksToArtists, @artistsToTracks, false
    elsif command.match(/^play track /)
      self.play command[11..-1]
    elsif command == "clear"
      print "Do you really want to clear everything? (Enter Y to confirm)"
      if gets.chomp.to_s == "Y"
        self.clear
      end
    else 
      puts "command '#{command}' cannot be understood."
    end
  end

  

  def play track
    trackNum = track.to_i
    if @tracksToArtists[trackNum].nil?
      puts "Track #{track} does not exist."
    else
      @tracksToArtists[trackNum].play #pretend we can play
      @playedHistory.push "ID: #{trackNum}, Name: #{@tracksToArtists[trackNum].name}"
    end

  end

  def addNewArtisit command 
    result = ReplHelper.getNewArtistID command
    @store.transaction do
      if @artistsToTracks[result[1]] == nil
        @artistsToTracks[result[1]] = [Artist.new(result[0],"")]
        #put id as key and list as the value
        #the list will contain 
        #An artisit object at begining and tracks following
        @store[:aToT] = @artistsToTracks
        puts ("""
        New artist added, 
        the name and id are 
        #{result}
        """)
      else
        puts "Artist #{result[0]} has already existed"
      end
    end
  end

  def addNewTrack command
    result = ReplHelper.getNewTrackID command, @tracksToArtists
    if result.length != 3
      puts 
      "The format of given command '#{command}' is wrong,
      please use command $ help for help"
    end
    @store.transaction do
      if @tracksToArtists[result[1]] == nil
        @tracksToArtists[result[1]] = Track.new(result[0],result[2])
        #puts "|#{result[2]}|"
        @artistsToTracks[result[2]] << result[1]
    
        puts "New track added, 
        the name, id and artist ID are 
        #{result}"
      else
        puts "Track #{result[0]} has already existed"
      end
      @store[:tToA] = @tracksToArtists
      @store[:aToT] = @artistsToTracks 
    end
  end

  def clear 
    @tracksToArtists, @artistsToTracks, played = ReplHelper.clear @store
    @playedHistory = PlayedHistory.new(played, 3)
  end
end