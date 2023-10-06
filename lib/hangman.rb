
class Hangman
  def initialize
    @random_word = ''
    @hints = []
    @failed_tries = 0
  end

  def hangman_drawing
    puts '   ______'
    puts '   |    |'
    puts '   O    |'
    puts '  /|\   |'
    puts '  / \   |'
    puts '        |'
  end

  def pick_game_difficulty
    puts "  Let's play a game of Hangman! Pick '1' for an easy ride, '2' for a normal game, and '3' for a challenge!"
    @choice = gets.chomp

    case @choice
    when '1' then generate_word_and_hints(4, 6)
    when '2' then generate_word_and_hints(7, 10)
    when '3' then generate_word_and_hints(11, 15)
    else
      puts '  Please pick a valid option.'
      pick_game_difficulty
    end
  end

  def generate_word_and_hints(min_length, max_length)
    @random_word = File.readlines('10000_words.txt').sample.chomp until @random_word.length.between?(min_length, max_length)
    @hints.push('_') until @hints.length == @random_word.length
    p @random_word
    p @hints
  end

  def game_running
    puts '  Guess a letter!'
    @guess = gets.chomp
    @random_word.each_char.with_index do |char, index|
      if @guess == char then update_hints(index, @guess)
      end
    end

    game_running
  end

  def update_hints(index, letter)
    @hints.delete_at(index)
    @hints.insert(index, letter)
  end
end

playing_hangman = Hangman.new
playing_hangman.pick_game_difficulty
playing_hangman.game_running
