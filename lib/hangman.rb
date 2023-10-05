def hangman_drawing
  puts '   ______'
  puts '   |    |'
  puts '   O    |'
  puts '  /|\   |'
  puts '  / \   |'
  puts '        |'
end

def pick_game_difficulty
  choice = gets.chomp

  case choice
  when '1' then generate_random_word(5, 7)
  when '2' then generate_random_word(8, 11)
  when '3' then generate_random_word(12, 16)
  else
    puts '  Please pick a valid option.'
    pick_game_difficulty
  end
end

def generate_random_word(min_length, max_length)
  random_word = ''
  random_word = File.readlines('10000_words.txt').sample.chomp until random_word.length.between?(min_length, max_length)
end

puts 'Pick your game difficulty.'
pick_game_difficulty
hangman_drawing