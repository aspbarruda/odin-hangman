def initial_printing(answer, used_letters, guesses)
  print "Answer: "
  answer.each {|value| print "#{value} "}
  puts "\n\n"
  print "Used Letters: "
  used_letters.each {|value| print "#{value} "}
  puts "\n\n"
  puts "Guess #{guesses} out of #{MAX_GUESSES}:\n"
end

def make_a_guess()
  while true
    guess = gets.chomp
    unless check_validity(guess)
      puts "Enter a single letter only:"
      next
    end
    break
  end
  guess
end

def compare(guess, secret_word, answer)
  temp = []
  answer.each_index {|i| temp[i] = answer[i]}
  i = 0
  secret_word.each_char { |letter|
    temp[i] = letter if letter == guess
    i += 1
  }
  temp
end

def check_validity(letter)
  return true unless letter.length != 1 || letter.match?(/[^a-z^A-Z]/)
  false
end

file = File.read "google-10000-english-no-swears.txt"
file = file.split("\n")

MAX_GUESSES = 7

possible_words = file.select {|value| value if value.length > 4 && value.length < 13}

game_running = true

while game_running
  have_won = false
  guess_number = 1
  used_letters = []
  secret_word = possible_words[rand(possible_words.length)]
  answer = Array.new(secret_word.length, "_")
  until have_won || guess_number > MAX_GUESSES
    initial_printing(answer, used_letters, guess_number)
    guess = make_a_guess()
    temp = compare(guess, secret_word, answer)
    used_letters.push guess
    unless temp.include? "_"
      have_won = true
      next
    end
    guess_number += 1 if temp == answer
    answer.each_index {|i| answer[i] = temp[i]}
  end
  if have_won
    puts "You won! Type 'y' to play again or any other key to quit"
  else
    puts "You lost, the correct answer was #{secret_word}! Type 'y' to play again or any other key to quit"
  end
  choice = gets.chomp
  game_running = false if choice.upcase != "Y"
end