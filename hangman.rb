def initial_printing(answer, used_letters, guesses)
  print "Answer: "
  answer.each {|value| print "#{value} "}
  puts "\n\n"
  print "Used Letters: "
  used_letters.each {|value| print "#{value} "}
  puts "\n\n"
  puts "Guess #{guesses} out of 7:\n"
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
  i = 0
  secret_word.each_char { |letter|
    answer[i] = letter if letter == guess
    i += 1
  }
  answer
end

def check_validity(letter)
  return true unless letter.length != 1 || letter.match?(/[^a-z^A-Z]/)
  false
end

file = File.read "google-10000-english-no-swears.txt"
file = file.split("\n")

possible_words = file.select {|value| value if value.length > 4 && value.length < 13}

game_running = true

while game_running
  have_won = false
  guess_number = 1
  used_letters = []
  secret_word = possible_words[rand(possible_words.length)]
  answer = Array.new(secret_word.length, "_")
  until have_won
    initial_printing(answer, used_letters, guess_number)
    guess = make_a_guess()
    answer = compare(guess, secret_word, answer)
  end
end