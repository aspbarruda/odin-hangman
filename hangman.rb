# frozen_string_literal: true

require 'yaml'

# creating pool of words
module AvailableWords
  file = File.read 'google-10000-english-no-swears.txt'
  file = file.split("\n")

  WORDS = file.select { |value| value if value.length > 4 && value.length < 13 }
end

# class for each game
class Game
  attr_accessor :guess_number, :used_letters, :answer, :secret_word

  include AvailableWords

  def initialize(guess_number = 1, used_letters = [], secret_word = nil, answer = nil)
    @guess_number = guess_number
    @used_letters = used_letters
    if secret_word.nil?
      @secret_word = WORDS[rand(WORDS.length)]
      @answer = Array.new(@secret_word.length, '_') if answer.nil?
    else
      @secret_word = secret_word
      @answer = answer
    end
  end

  def initial_printing
    print 'Answer: '
    @answer.each { |value| print "#{value} " }
    puts "\n\n"
    print 'Used Letters: '
    @used_letters.sort.each { |value| print "#{value} " }
    puts "\n\n"
    puts "Guess #{@guess_number} out of #{MAX_GUESSES}: (press 1 at any time to save the game)\n"
  end

  def make_a_guess
    loop do
      @guess = gets.chomp.downcase
      self.save if @guess == '1'
      unless check_validity(@guess, @used_letters)
        puts "Enter a single letter only that hasn't been used: (press 1 at any time to save the game)\n"
        next
      end
      break
    end
    @used_letters.push @guess
  end

  def compare
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

  def save
    savefile_content = File.open('savefile.yml', 'w')
    content = (YAML.dump({
                          guess_number: @guess_number,
                          used_letters: @used_letters,
                          secret_word: @secret_word,
                          answer: @answer
                        }))
    savefile_content.puts(content)
    savefile_content.close
  end

  def self.load(savefile)
    content = File.read savefile
    data = YAML.load content
    puts data
    Game.new(data[:guess_number], data[:used_letters], data[:secret_word], data[:answer])
  end
end

MAX_GUESSES = 7

game_running = true

while game_running
  have_won = false
  puts 'Load a previously saved game? (y for load, any other key for start new game)'
  choice = gets.chomp
  if choice.downcase == 'y'
    game = Game.load 'savefile.yml'
  else
    game = Game.new
  end

  until have_won || game.guess_number > MAX_GUESSES
    system('clear')

    game.initial_printing
    game.make_a_guess
    temp = game.compare
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
