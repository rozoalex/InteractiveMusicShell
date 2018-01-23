class PlayedHistory
  def initialize history, sizeLimit
    @history = history
    @sizeLimit = sizeLimit
  end

  def push track
    @history << track
    #puts @history
  end

  def print
    puts "Recently played:" if @history.length > 0
    puts "Never played any tracks." if @history.length == 0
    count = 1
    while count <= [@sizeLimit, @history.length].min
      puts "#{count}: #{@history[@history.length-count]}"
      count += 1
    end
  end

  def save
    ans = Array.new(@sizeLimit)
    count = 1
    while count <= @sizeLimit
      ans[@sizeLimit-count] = @history[@history.length-count]
      count +=1
    end
    return ans
  end


end