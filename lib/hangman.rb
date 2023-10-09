
class Hangman
  def initialize
    @hints = []
    @failed_tries = 0
    @random_word = ''
    @hangman_rope = ' '
    @hangman_head = ' '
    @hangman_upper_body = '   '
    @hangman_lower_body = '   '
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
  end

  def game_running
    update_display
    @guess = gets.chomp

    @random_word.each_char.with_index do |char, index|
      update_hints(index, @guess) unless @guess != char
    end

    @failed_tries += 1 unless @random_word.include?(@guess) == true

    update_failed_tries
    game_running
  end

  # The methods below will only handle interface updates

  def update_hints(index, letter)
    @hints.delete_at(index)
    @hints.insert(index, letter)
  end

  def update_failed_tries
    case @failed_tries
    when 1 then @hangman_rope = '|'
    when 2 then @hangman_head = 'O'
    when 3 then @hangman_upper_body = '/  '
    when 4 then @hangman_upper_body = '/| '
    when 5 then @hangman_upper_body = '/|\\'
    when 6 then @hangman_lower_body = '/  '
    when 7 then @hangman_lower_body = '/ \\'
    end
  end

  def hangman_drawing
    puts '       ______'
    puts "       #{@hangman_rope}    |"
    puts "       #{@hangman_head}    |"
    puts "      #{@hangman_upper_body}   |"
    puts "      #{@hangman_lower_body}   |"
    puts '            |'
  end

  def update_display
    hangman_drawing
    puts ''
    puts @hints.join(' ')
    puts ''
    puts '  Guess a letter!'
  end
end

playing_hangman = Hangman.new
playing_hangman.hangman_drawing
playing_hangman.pick_game_difficulty
playing_hangman.game_running
