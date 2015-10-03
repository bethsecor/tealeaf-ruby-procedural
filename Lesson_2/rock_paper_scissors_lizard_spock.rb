VALID_CHOICES = %w(rock paper scissors lizard spock)
NUMBER_CHOICES = (1..5).to_a

def prompt(message)
  puts "=> #{message}"
end

def win?(first, second)
  (first == 'scissors' && %w(paper lizard).include?(second)) ||
    (first == 'paper' && %w(rock spock).include?(second)) ||
    (first == 'rock' && %w(lizard scissors).include?(second)) ||
    (first == 'lizard' && %w(spock paper).include?(second)) ||
    (first == 'spock' && %w(scissors rock).include?(second))
end

# WINNING_CHOICES = {
#   'rock' => %w(lizard scissors),
#   'paper' => %w(rock spock),
#   'scissors' => %w(lizard paper),
#   'spock' => %w(scissors rock),
#   'lizard' => %w(spock paper)
# }
#
# def win?(first, second)
#   WINNING_CHOICES[first].include?(second)
# end

def display_results(player, computer)
  if win?(player, computer)
    prompt "You won this round!"
  elsif win?(computer, player)
    prompt "Computer won this round."
  else
    prompt "It's a tie."
  end
end

def add_point(player, computer, players_hash)
  if win?(player, computer)
    players_hash[@name] += 1
  elsif win?(computer, player)
    players_hash["Computer"] += 1
  else
  end
end

def endgame?(players_hash)
  players_hash[@name] >= 5 || players_hash["Computer"] >= 5
end

def wingame?(players_hash)
  if players_hash[@name] >= 5
    puts "#{@name}, you won the game!"
  elsif players_hash["Computer"] >= 5
    puts "Sorry, the computer won this game."
  else
  end
end

choice_prompt = <<-MSG
Choose one by typing the number:
1. rock
2. paper
3. scissors
4. lizard
5. spock
MSG

prompt "Let's play rock, paper, scissors, lizard, spock!"
prompt "Please enter your name!"

@name = ''

loop do
  @name = gets.chomp

  if @name.empty?
    prompt "Please enter your name!"
  else
    break
  end
end

prompt "Hi #{@name.capitalize}!"

players = { @name => 0, "Computer" => 0}

loop do
  prompt choice_prompt

  choice = ''
  choice_string = ''

  loop do
    choice = gets.chomp.to_i
    if NUMBER_CHOICES.include?(choice)
      choice_string = VALID_CHOICES[choice-1]
      break
    else
      prompt "Type either #{NUMBER_CHOICES.join(', ')}"
    end
  end

  computer_choice = VALID_CHOICES.sample

  puts "You chose: #{choice_string}; The computer chose: #{computer_choice}."

  display_results(choice_string, computer_choice)
  add_point(choice_string, computer_choice, players)
  puts "Scores are #{@name}: #{players[@name]} and Computer: #{players["Computer"]}"

  break if endgame?(players)

  prompt "Do you want to play again?"
  answer = gets.chomp.downcase
  break unless answer.start_with?('y')
end

wingame?(players)
prompt "Thank you for playing!"
