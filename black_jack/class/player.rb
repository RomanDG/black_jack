class Player
  attr_accessor :name, :cards, :points

  def initialize
    @cards = []
    @points = 0
  end

  def set_name name
    @name = name
  end

end