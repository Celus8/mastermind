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
    @code = [rand(1..9), rand(1..9), rand(1..9), rand(1..9)].join
  end

  def play
    puts 'Welcome to Mastermind! A 4 digit code will be generated, with numbers 1-9, both included. Inputting a 0 or text will terminate the program. Good luck!'
    puts @code
    loop do
      guess = gets.chomp
      break if guess.to_i.zero?

      result = check(guess)
      break if result == 'Win'

      unless result
        puts 'Incorrect input!'
        next
      end

      puts "You have #{result[0]} correct digits in the correct place, and #{result[1]} correct digits in an incorrect place."
    end
  end

  def check(player_guess)
    return false unless valid?(player_guess)

    if player_guess == @code
      puts 'You win!'
      return 'Win'
    end
    guess_array = player_guess.split('')
    code_array = @code.split('')
    red = [0, 1, 2, 3].reduce(0) do |in_common, i|
      in_common += 1 if guess_array[i] == code_array[i]
      in_common
    end
    white = (guess_array & code_array).length
    [red, white]
  end

  def valid?(input)
    input_array = input.split('')
    input_array.all? { |value| integer?(value) } && input_array.length == 4
  end

  def integer?(value)
    value.to_i.to_s == value
  end
end

Game.new.play
