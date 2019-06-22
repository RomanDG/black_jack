class EngineGame
  attr_accessor :dealer, :player
  def initialize
    @dealer = Dealer.new
    @player = Player.new
    @bank = Bank.new
    @cards = Cards.new
    @ui = UserInterface.new
  end

  def start_game
    @player.set_name @ui.get_name                # получить имя игрока

    loop do
      @ui.winner @player if (@bank.player_money > 0) && (@bank.dealer_money == 0)
      @ui.winner @dealer if (@bank.dealer_money > 0) && (@bank.player_money == 0)

      deal_first_two_cards  # сдать первые две карты каждому участнику игры
      bet_money             # внести деньги в банк
      @ui.current_data @player, @dealer, @bank

      loop do
        if @player.cards.size == 3 && @dealer.cards.size == 3
          @ui.open_cards @player, @dealer, choose_winner
          get_new_card_deck
          break
        end

        @ui.select_action
        case gets.chomp
        when "1"
          deal_one_card @player
          @dealer.points < 17 ? deal_one_card(@dealer) : next
          if @player.cards.size == 3 && @dealer.cards.size == 3
            @ui.open_cards @player, @dealer, choose_winner
            get_new_card_deck
            break
          else
            @ui.current_data @player, @dealer, @bank
          end
        when "2"
          deal_one_card @dealer
          if @player.cards.size == 3 && @dealer.cards.size == 3
            @ui.open_cards @player, @dealer, choose_winner
            get_new_card_deck
            break
          else
            @ui.current_data @player, @dealer, @bank
          end
        when "3"
          @ui.open_cards @player, @dealer, choose_winner
          get_new_card_deck
          break
        end   
      end 
    end
  end

  def bet_money
    @bank.bet_money
  end

  # раздаем по первым двум картам
  def deal_first_two_cards
    4.times do |x|
      card = @cards.deal_card
      if x.odd?
        @player.cards << card.first
        @player.points += calculate_points @player, card.last
      else
        @dealer.cards << card.first
        @dealer.points += calculate_points @dealer, card.last 
      end     
    end
  end

  def calculate_points player, number
    if number == 11 && ((player.points + number) > 21)
      number = 1
    end
    number
  end

  # раздаем одну карту
  def deal_one_card player
    card = @cards.deal_card
    player.cards << card.first
    player.points += calculate_points player, card.last
  end

  def choose_winner
    if ((@player.points > @dealer.points) && @player.points <= 21) || ( @player.points < 21 && @dealer.points >= 21)
      @bank.player_money += @bank.bank_money
      @player.name
    elsif (@player.points == @dealer.points)
      false
    else
      @bank.dealer_money += @bank.bank_money
      @dealer.name
    end
  end

  def get_new_card_deck
    @cards = Cards.new
    @player.cards = []
    @dealer.cards = []
    @player.points = 0
    @dealer.points = 0
    @bank.bank_money = 0
  end 
end