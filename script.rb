module Checker
  def valid?(input)
    input_array = input.split('')
    input_array.all? { |value| integer?(value) } && input_array.length == 4
  end

  def integer?(value)
    value.to_i.to_s == value
  end
end

class Game
  include Checker

  attr_reader :code, :guess, :code_maker, :code_guesser, :tries

  def initialize
    puts 'Welcome to Mastermind! Enter "make" if you want to be the codemaker, or "guess" if you want to be the codeguesser. The computer will play the other role.'
    loop do
      case gets.chomp
      when 'make'
        @code_maker = Human.new
        @code_guesser = Computer.new
        puts 'Input the secret code you want to generate, and the computer will try to guess it. The code has to be made of 4 digits between 1 and 9, both included.'
        break
      when 'guess'
        @code_guesser = Human.new
        @code_maker = Computer.new
        puts 'A 4 digit code will be generated, with numbers 1-9, both included. Inputting a 0 will terminate the program. You have 12 tries to guess the code. Good luck!'
        break
      else
        puts 'Incorrect input!'
      end
    end
  end

  def play
    @code = code_maker.generate_code
    code_guesser.get_code(self)
    @tries = 12
    loop do
      code_guesser.get_tries(self)
      @guess = code_guesser.make_guess
      break unless @guess

      result = check(guess)
      break if result == 'Win'

      @tries -= 1
      puts "#{code_guesser} #{result[0]} correct digits in the correct place, and #{result[1]} correct digits in an incorrect place. #{code_guesser} #{tries} tries left."
      if tries <= 0
        puts "#{code_guesser} ran out of tries. #{code_guesser} lost!"
        break
      end
      code_guesser.pause
    end
  end

  def check(player_guess)
    if player_guess == @code
      puts "#{code_guesser} won!"
      return 'Win'
    end
    guess_array = player_guess.split('')
    code_array = @code.split('')
    red = [0, 1, 2, 3].reduce(0) do |in_common, i|
      in_common += 1 if guess_array[i] == code_array[i]
      in_common
    end
    white = ((guess_array & code_array).flat_map { |n| [n]*[guess_array.count(n), code_array.count(n)].min }).length - red
    [red, white]
  end
end

class Human
  include Checker

  def get_code(game); end

  def get_tries(game); end

  def pause; end

  def generate_code
    loop do
      provisional_code = gets.chomp
      if valid?(provisional_code)
        return provisional_code
      else
        puts 'Incorrect code format! Try again.'
      end
    end
  end

  def make_guess
    loop do
      provisional_guess = gets.chomp
      if valid?(provisional_guess)
        return provisional_guess
      elsif provisional_guess == '0'
        puts 'Game over'
        return false
      else
        puts 'Incorrect guess format! Try again.'
      end
    end
  end

  def to_s
    'You have'
  end
end

class Computer
  def initialize
    @guess = [rand(1..9), rand(1..9), rand(1..9), rand(1..9)].join
  end

  def get_code(game)
    @code = game.code
  end

  def get_tries(game)
    @tries = game.tries
  end

  def generate_code
    [rand(1..9), rand(1..9), rand(1..9), rand(1..9)].join
  end

  def make_guess
    return @guess if @tries == 12
    
    change_guess
    puts "The computer guesses: #{@guess}"
    @guess
  end

  def to_s
    'The computer has'
  end

  def pause
    sleep 2
  end

  def change_guess
    modified_guess = Array.new(4, nil)
    modified_guess = add_reds(modified_guess)
    modified_guess = add_whites(modified_guess)
    @guess = modified_guess.join
  end

  def add_reds(modified_guess)
    @guess.split('').each_with_index do |element, index|
      if @code.split('')[index] == element
        modified_guess[index] = element
      end
    end
    modified_guess
  end

  def add_whites(modified_guess)
    in_common = []
    @guess.split('').each_with_index do |element, index|
      if @code.split('').include?(element)
        in_common.push(element) unless @code.split('').count(element) <= modified_guess.count(element)
      end
    end
    (0..3).each do |i|
      if modified_guess[i].nil?
        modified_guess[i] = (in_common.pop || rand(1..9).to_s)
      end
    end
    modified_guess
  end
end

game = Game.new
game.play
