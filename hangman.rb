# frozen_string_literal: true

require 'yaml'

# class for each game
class Game
  attr_accessor :guess_number, :used_letters, :answer, :secret_word

  @@file = File.read 'google-10000-english-no-swears.txt'
  @@file = @@file.split("\n")

  @@possible_words = @@file.select { |value| value if value.length > 4 && value.length < 13 }

  def initialize
    @guess_number = 1
    @used_letters = []
    @secret_word = @@possible_words[rand(@@possible_words.length)]
    @answer = Array.new(@secret_word.length, '_')
  end

  def initial_printing
    print 'Answer: '
    @answer.each { |value| print "#{value} " }
    puts "\n\n"
    print 'Used Letters: '
    @used_letters.sort.each { |value| print "#{value} " }
    puts "\n\n"
    puts "Guess #{@guess_number} out of #{MAX_GUESSES}:\n"
  end

  def make_a_guess
    while true
      @guess = gets.chomp.downcase
      unless check_validity(@guess, @used_letters)
        puts "Enter a single letter only that hasn't been used:"
        next
      end
      break
    end
    @used_letters.push @guess
  end

  def compare()
    temp = []
    @answer.each_index { |i| temp[i] = @answer[i] }
    i = 0
    @secret_word.each_char do |letter|
      temp[i] = letter if letter == @guess
      i += 1
    end
    temp
  end

  def check_validity(letter, used_letters)
    return true unless letter.length != 1 || letter.match?(/[^a-z^A-Z]/) || used_letters.include?(letter)

    false
  end
end

MAX_GUESSES = 7

game_running = true

while game_running
  have_won = false
  game = Game.new

  until have_won || game.guess_number > MAX_GUESSES
    system('clear')
    game.initial_printing()
    game.make_a_guess()
    temp = game.compare()
    unless temp.include? '_'
      have_won = true
      next
    end
    game.guess_number += 1 if temp == game.answer
    game.answer.each_index { |i| game.answer[i] = temp[i] }
  end

  if have_won
    puts "You won, the correct answers was #{game.secret_word.upcase}! Type 'y' to play again or any other key to quit"
  else
    puts "You lost, the correct answer was #{game.secret_word.upcase}! Type 'y' to play again or any other key to quit"
  end
  choice = gets.chomp
  game_running = false if choice.upcase != 'Y'
end
