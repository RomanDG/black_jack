class UserInterface
  def winner player
    puts "++++++++++++++++++++++++++++++++++++++++++++++"
    puts "\nАбсолютный победитель игры: #{player.name}\n"
    puts "++++++++++++++++++++++++++++++++++++++++++++++"
  end

  def select_action
    puts "взять еще карту - 1 | пропустить - 2 | открыть карты - 3"
  end

  def get_name
    print "введите ваше имя: "
    gets.chomp
  end

  def current_data player, dealer, bank
    print "#{player.name} cards: "
    player.cards.each{ |card| print card + " " }
    print "[ points: #{player.points} / 21 ] [ money: #{bank.player_money} ]   |   "
    print "Dealer cards: "
    dealer.cards.each{ |card| print "* " }
    print "   [ money: #{bank.dealer_money} ]"
    puts ""
  end

  def open_cards player, dealer, winner
    winner_name = !winner ? "ничья" : winner
    puts "======== stop game ========"
    print "my cards: "
    player.cards.each{ |card| print card + " " }
    print "  -  points: #{player.points} / 21 ]"
    print "   |   "
    print "dealer cards: "
    dealer.cards.each{ |card| print card + " " }
    print "  -  points: #{dealer.points} / 21 ]\n"
    puts "Winner is =========> #{winner_name}"
    puts "============================"
    puts ""
  end
end