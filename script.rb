# 1st Version. Computer is codemaker and human is codebreaker. Computer 
# generates a random 4 digit number and player has to guess it. Human has 12 
# guesses. In each one he inputs a 4 digit number, and the terminal returns how 
# many were correct and in the correct place and how many were correct in the 
# incorrect place. If after guess 12 human hasn't guessed the code, he loses. If 
# at some point he guesses the code, he wins.

# Computer is a class that generates the code. Player is a class that has 
# player actions. Game is a class that recieves input from player and computer, 
# and shows output.

class Game
  attr_reader :code

  def initialize
    @code = [rand(0..9), rand(0..9), rand(0..9), rand(0..9)].join
  end

  def play
    puts 'Guess the code!'
    guess = gets.chomp
    until check(guess) || guess.to_i.zero?
      puts 'Try again!'
      guess = gets.chomp
    end
  end

  def check(player_guess)
    if player_guess == @code
      puts 'You win!'
      true
    end
  end
end

Game.new.play
