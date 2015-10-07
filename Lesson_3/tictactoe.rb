require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
FIRST = 'Player'

def prompt(message)
  prompt "=> #{message}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  prompt "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  prompt ""
  prompt "  1  |  2  |  3"
  prompt "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  prompt "     |     |"
  prompt "-----+-----+-----"
  prompt "  4  |  5  |  6"
  prompt "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  prompt "     |     |"
  prompt "-----+-----+-----"
  prompt "  7  |  8  |  9"
  prompt "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  prompt "     |     |"
  prompt ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(array, sep, finalsep = 'or')
  if array.length > 2
    array[0..(array.length-2)].join(sep) + sep + finalsep + ' ' + array.last.to_s
  elsif array.length == 2
    array.join(" #{finalsep} ")
  else
    array.last.to_s
  end
end

def player_places_piece!(brd)
  square = ''

  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd), ', ', 'or')}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that is not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def player_almost_win(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 2 && brd.values_at(*line).count(COMPUTER_MARKER) == 0
      return brd.select{|k,v| k == line[0] || k== line[1] || k == line[2]}.key(INITIAL_MARKER)
    end
  end
  nil
end

def computer_almost_win(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2 && brd.values_at(*line).count(PLAYER_MARKER) == 0
      return brd.select{|k,v| k == line[0] || k== line[1] || k == line[2]}.key(INITIAL_MARKER)
    end
  end
  nil
end
# refactor the above two methods to take in computer or player, then use accordingly below

def computer_places_piece!(brd)
  if !!computer_almost_win(brd)
    square = computer_almost_win(brd)
  elsif !!player_almost_win(brd)
    square = player_almost_win(brd)
  elsif brd.values_at(5) == [' ']
    square = 5
  else
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def place_piece!(brd, whos_playing)
  if whos_playing == 'Player'
    player_places_piece!(brd)
  elsif whos_playing == 'Computer'
    computer_places_piece!(brd)
  end
end

def alternate_player(plyr)
  if plyr == 'Computer'
    'Player'
  elsif plyr == 'Player'
    'Computer'
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    # if brd[line[0]] == PLAYER_MARKER &&
    #    brd[line[1]] == PLAYER_MARKER &&
    #    brd[line[2]] == PLAYER_MARKER
    #   return 'Player'
    # elsif brd[line[0]] == COMPUTER_MARKER &&
    #       brd[line[1]] == COMPUTER_MARKER &&
    #       brd[line[2]] == COMPUTER_MARKER
    #   return 'Computer'
    # end
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def add_point(brd, players_hash)
  if someone_won?(brd)
    players_hash[detect_winner(brd)] += 1
  end
end

def end_entire_game?(players_hash)
  players_hash["Player"] >= 5 || players_hash["Computer"] >= 5
end

def win_entire_game?(players_hash)
  if players_hash["Player"] >= 5
    prompt "You won the game!"
  elsif players_hash["Computer"] >= 5
    prompt "Sorry, the computer won this game."
  else
  end
end

# BEGIN GAME
players = { 'Player' => 0, 'Computer' => 0}

loop do
  board = initialize_board
  current_player = FIRST
  loop do
    # display_board(board)
    #
    # player_places_piece!(board)
    # add_point(board, players)
    # break if someone_won?(board) || board_full?(board)
    #
    # computer_places_piece!(board)
    # add_point(board, players)
    # break if someone_won?(board) || board_full?(board)

    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie!"
  end

  prompt "Scores are:"
  prompt "You: #{players["Player"]}"
  prompt "Computer: #{players["Computer"]}"

  break if end_entire_game?(players)

  prompt "Do you want to play again? (Y or N):"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

win_entire_game?(players)
prompt "Thanks for playing tic tac toe!"
