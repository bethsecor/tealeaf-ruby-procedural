# Actual rules of the game:
# http://planningwithkids.com/2012/06/20/21-card-game/
# Tealeaf solution leaves out if player or dealer gets 21, then they win.

require 'pry'

def prompt(message)
  puts "=> #{message}"
end

CARDS_SUIT = ("2".."10").to_a + ["jack", "queen", "king", "ace"]
CARDS_SUIT_VALUES = (2..10).to_a + [10, 10, 10, 1]
CARDS_SUIT_H = Hash[CARDS_SUIT.zip CARDS_SUIT_VALUES]
DECK_CARDS = CARDS_SUIT * 4

def initialize_game_dealer
  DECK_CARDS.sample(2)
end

def initialize_game_player(dealer_game_cards)
  (DECK_CARDS - dealer_game_cards).sample(2)
end

def total_sum_cards(cards)
  cards_values = cards.map { |card| CARDS_SUIT_H[card] }
  total_sum = cards_values.reduce(:+)

  cards.count("ace").times do
    total_sum += 10 if total_sum + 10 <= 21
  end

  total_sum
end

def busted?(cards)
  total_sum_cards(cards) > 21
end

def twentyone?(cards)
  total_sum_cards(cards) == 21
end

def seventeen?(cards)
  total_sum_cards(cards) >= 17
end

def new_card(dealer_game_cards, player_game_cards)
  (DECK_CARDS - dealer_game_cards - player_game_cards).sample
end

def compare_cards(player_game_cards, dealer_game_cards)
  if total_sum_cards(player_game_cards) < total_sum_cards(dealer_game_cards)
    "Dealer"
  elsif total_sum_cards(player_game_cards) > total_sum_cards(dealer_game_cards)
    "Player"
  elsif total_sum_cards(player_game_cards) == total_sum_cards(dealer_game_cards)
    "Tie"
  end
end

def add_point(players_hash, player)
  players_hash[player] += 1
end

def end_entire_game?(players_hash)
  players_hash["Player"] >= 5 || players_hash["Dealer"] >= 5
end

def win_entire_game?(players_hash)
  if players_hash["Player"] >= 5
    prompt "You won the game!"
  elsif players_hash["Dealer"] >= 5
    prompt "Sorry, the Dealer won this game."
  end
end

# BEGIN GAME
prompt "Welcome to Twenty One!"
players = { 'Player' => 0, 'Dealer' => 0 }

loop do
  dealer_cards = initialize_game_dealer
  prompt "Dealer has #{dealer_cards[0]} and unknown card."
  player_cards = initialize_game_player(dealer_cards)
  prompt "You have: #{player_cards[0]} and #{player_cards[1]}."

  answer = nil

  loop do
    break if twentyone?(player_cards)
    prompt "Your total card sum is #{total_sum_cards(player_cards)}."
    prompt "hit or stay?"
    answer = gets.chomp
    if answer == 'hit'
      dealt_card_player = new_card(dealer_cards, player_cards)
      prompt "You got a #{dealt_card_player}!"
      player_cards << dealt_card_player
      prompt "Your cards are: #{player_cards.join(', ')}"
    end
    break if answer == 'stay' || twentyone?(player_cards) || busted?(player_cards)
  end

  if busted?(player_cards)
    prompt "You busted. Dealer won. Do you want to play again?"
    add_point(players, 'Dealer')
  elsif twentyone?(player_cards)
    prompt "You got 21! You won the game!"
    add_point(players, 'Player')
  else
    prompt "You chose to stay. Dealer will now play."
    choice = nil

    loop do
      break if choice == 'stay' || twentyone?(dealer_cards) || busted?(dealer_cards)
      loop do
        break if seventeen?(dealer_cards)
        dealt_card_dealer = new_card(dealer_cards, player_cards)
        dealer_cards << dealt_card_dealer
        prompt "Dealer hits."
        prompt "Dealer cards: #{dealer_cards.join(', ')}"
      end

      choice = %w(hit stay).sample
    end

    if busted?(dealer_cards)
      prompt "Dealer busted. You win!"
      add_point(players, 'Player')
    elsif twentyone?(dealer_cards)
      prompt "Dealer won with 21."
      add_point(players, 'Dealer')
    else
      prompt "Dealer stayed."
      prompt "Your card total: #{total_sum_cards(player_cards)}"
      prompt "Dealer card total: #{total_sum_cards(dealer_cards)}"
      stayed_winner = compare_cards(player_cards, dealer_cards)
      if stayed_winner != "Tie"
        prompt "#{stayed_winner} won."
        add_point(players, stayed_winner)
      elsif stayed_winner == "Tie"
        puts "It's a tie."
      end
    end
  end

  prompt "Scores are:"
  prompt "You: #{players['Player']}"
  prompt "Dealer: #{players['Dealer']}"

  break if end_entire_game?(players)

  prompt "Do you want to play again? (Y or N):"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

win_entire_game?(players)
prompt "Thanks for playing Twenty One!"
