class EngineGame
  attr_accessor :dealer, :player
  def initialize
    @dealer = Dealer.new
    @player = Player.new
    @bank = Bank.new
    @cards = Cards.new
  end

  def start_game
    get_name                # получить имя игрока

    loop do
      if (@bank.player_money > 0) && (@bank.dealer_money == 0)
        puts "++++++++++++++++++++++++++++++++++++++++++++++"
        puts "\nАбсолютный победитель игры: #{@player.name}\n"
        puts "++++++++++++++++++++++++++++++++++++++++++++++"
      elsif (@bank.dealer_money > 0) && (@bank.player_money == 0)
        puts "++++++++++++++++++++++++++++++++++++++++++++++"
        puts "\nАбсолютный победитель игры: Dealer\n"
        puts "++++++++++++++++++++++++++++++++++++++++++++++"
      end

      deal_first_two_cards  # сдать первые две карты каждому участнику игры
      bet_money             # внести деньги в банк
      show_my_data

      loop do
        if @player.cards.size == 3 && @dealer.cards.size == 3
          open_cards
          break
        end
        puts "взять еще карту - 1 | пропустить - 2 | открыть карты - 3"
        case gets.chomp
        when "1"
          deal_one_card @player
          @dealer.points < 17 ? deal_one_card(@dealer) : next
          if @player.cards.size == 3 && @dealer.cards.size == 3
            open_cards
            break
          else
            show_my_data
          end
        when "2"
          deal_one_card @dealer
          if @player.cards.size == 3 && @dealer.cards.size == 3
            open_cards
            break
          else
            show_my_data
          end
        when "3"
          open_cards
          break
        end   
      end 
    end
  end

  def get_name
    print "введите ваше имя: "
    @player.set_name gets.chomp
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

  # показываем информацию о картах, очка
  def show_my_data
    print "#{@player.name} cards: "
    @player.cards.each{ |card| print card + " " }
    print "[ points: #{@player.points} / 21 ] [ money: #{@bank.player_money} ]   |   "
    print "Dealer cards: "
    @dealer.cards.each{ |card| print "* " }
    print "   [ money: #{@bank.dealer_money} ]"
    puts ""
  end

  def choose_winner
    if ((@player.points > @dealer.points) && @player.points <= 21) || ( @player.points < 21 && @dealer.points >= 21)
      @bank.player_money += @bank.bank_money
      @player.name
    elsif (@player.points == @dealer.points)
      puts "ничья"
    else
      @bank.dealer_money += @bank.bank_money
      "Dealer"
    end
  end

  def open_cards
    puts "======== stop game ========"
    print "my cards: "
    @player.cards.each{ |card| print card + " " }
    print "  -  points: #{@player.points} / 21 ]"
    print "   |   "
    print "dealer cards: "
    @dealer.cards.each{ |card| print card + " " }
    print "  -  points: #{@dealer.points} / 21 ]\n"
    puts "Winner is =========> #{choose_winner}"
    puts "============================"
    get_new_card_deck
    puts ""
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