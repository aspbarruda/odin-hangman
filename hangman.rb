file = File.read "google-10000-english-no-swears.txt"
file = file.split("\n")

possible_words = file.select {|value| value if value.length > 4 && value.length < 13}

game_running = true

while game_running
  have_won = false
  guesses = 1
  used_letters = []
  secret_word = possible_words[rand(possible_words.length)]
  answer = Array.new(secret_word.length, "_")
  until have_won
    print "Answer: "
    answer.each {|value| print "#{value} "}
    puts "\n\n"
    print "Used Letters: "
    used_letters.each {|value| print "#{value} "}
    puts "\n\n"
    puts "Guess #{guesses} out of 7:\n"
    guess = gets.chomp
  end
end