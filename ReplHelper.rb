#This is the helper module for the REPL
#There are only helper methods in this module
module ReplHelper
  #store should be a pstore object
  #This method recover all the maps
  def self.recover store
    store.transaction do #open a session
      store[:tToA] = {} if store[:tToA].nil? 
      store[:aToT] = {} if store[:aToT].nil?
      store[:hist] = Array.new if store[:hist].nil?
      return store[:tToA], store[:aToT], store[:hist]
    end
  end

  def self.clear store
    store.transaction do #open a session
      store[:tToA] = {} 
      store[:aToT] = {} 
      store[:hist] = Array.new 
      return store[:tToA], store[:aToT], store[:hist]
    end
  end

  def self.printDetails tToA, aToT
    puts "There are #{tToA.length} tracks, " 
    tToA.each do |key, value|
      print "ID:#{key}, "
      self.printTrackInfo value, aToT
    end
  end

  def self.printTrackInfo track, aToT
    print "#{track.name} by "
    i = 0;
    for v in track.artistIDs
      print "#{aToT[v][0].name}"
      if i==track.artistIDs.length-1
        puts ""
      else
        print ", "
      end
      i = i+1
    end
  end

  def self.printArtistDetails artistID, tToA, aToT, doIntro
    artistID.strip!
    if aToT[artistID] == nil
      puts "The artist ID does not exist, use {$ add artist name} to create one. "
      return
    end
    aToT[artistID][0].intro() if doIntro
    if aToT[artistID].length == 1
      puts "There is no tracks for now."
      return
    else 
      puts "Tracks:"
    end
    for i in 1.. aToT[artistID].length-1
      puts tToA[aToT[artistID][i]].name
    end
  end

  def self.printTrackDetails trackNum, tToA, aToT
    trackNum.strip!
    num = trackNum.to_i
    return if num == nil
    self.printTrackInfo tToA[num],aToT
  end

  def self.getNewArtistID command
    i = 0
    artistID = ''
    artistRealName = ''
    for c in command.split ' ' 
      if i>1 
        artistID = artistID + c[0] 
        artistRealName = artistRealName + c +' '
      end
      i=i+1
    end
    return artistRealName, artistID 
  end

  def self.getNewTrackID command, tToA
    i = 0
    trackID = tToA.length
    trachName = ''
    artistID = ''
    flag = false
    for c in command.split(' ')
      if i>1
        if c == 'by'
          flag = true
          next
        end
        if flag
          artistID = artistID + c 
        else
          trachName = trachName + c + ' '
        end
      end
      i=i+1
    end
    return trachName, trackID, artistID
  end
end