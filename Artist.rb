class Artist
  attr_accessor :name
  def initialize(name, discription)
    @name = name
    @discription = discription
  end

  def intro
    puts @name
    puts @discription
  end
end