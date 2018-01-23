class Track
  attr_accessor :name, :artistIDs
  def initialize name, artist
    @name = name
    @artistIDs = [artist]
  end

  #add a list of new artist ids
  def addArtist name
    artistIDs.concat(name)
  end

  def play
    puts "~#{@name}"
    #play some fancy waves
    #if we have an audio database, play that here
    for i in 0.. Random.new.rand(100..150)
      sleep 0.1
      musicIndex = 10
      musicIndexH = musicIndex/2
      if (i%musicIndex) < (musicIndex/2)
        puts "~" * musicIndex if i % musicIndexH == 0
        puts "~" * (1 + i % musicIndexH) * (1 + i % musicIndexH)
      else 
        puts "~" * (musicIndexH - i % musicIndexH) * (musicIndexH - i % musicIndexH) * 2 if i % musicIndexH == 0
        puts "~" * (musicIndexH - i % musicIndexH) * (musicIndexH - i % musicIndexH)
      end
    end
    puts "hmmm, your speaker is not working correctly... or maybe nothing is recorded in this track."
  end
end