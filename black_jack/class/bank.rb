class Bank
  attr_accessor :player_money, :dealer_money, :bank_money

  def initialize
    @bank_money = 0
    @player_money = 100
    @dealer_money = 100
  end

  def bet_money
    if @player_money > 10 && @dealer_money > 10
      @bank_money += 20
      @player_money -= 10
      @dealer_money -= 10
    end
  end
end