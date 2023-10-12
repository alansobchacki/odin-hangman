# To-do list
# [] Allow users to save/load their game

# Handles the basic setup rules of our game
class GameSetup
  attr_accessor :random_word, :hints

  def initialize
    @hints = []
    @random_word = ''
  end

  def pick_game_difficulty
    puts "  Let's play a game of Hangman! Pick '1' for an easy ride, '2' for a normal game, and '3' for a challenge!"
    @difficulty_choice = gets.chomp

    case @difficulty_choice
    when '1' then generate_random_word(4, 6)
    when '2' then generate_random_word(7, 10)
    when '3' then generate_random_word(11, 15)
    else
      puts '  Please pick a valid option.'
      pick_game_difficulty
    end
    generate_hints
  end

  def generate_random_word(min_length, max_length)
    @random_word = File.readlines('10000_words.txt').sample.chomp until @random_word.length.between?(min_length, max_length)
  end

  def generate_hints
    @hints.push('_') until @hints.length == @random_word.length
  end
end

# Everything that happens after a game is setup goes here
class Game
  def initialize(random_word, hints)
    @random_word = random_word
    @hints = hints
    @guesses = []
    @failed_tries = 0
    @game_over = false
    @hangman_rope = ' '
    @hangman_head = ' '
    @hangman_upper_body = '   '
    @hangman_lower_body = '   '
  end

  def game_running
    update_display
    @guess = gets.chomp.downcase
    game_running unless @guess.length == 1 && /^[a-z]$/.match?(@guess)
    update_guesses

    @random_word.each_char.with_index do |char, index|
      update_hints(index, @guess) unless @guess != char
    end

    @failed_tries += 1 unless @random_word.include?(@guess) == true
    update_failed_tries

    game_over if @hints.join == @random_word
    game_running unless @game_over == true
  end

  def update_guesses
    @guesses.push(@guess) unless @guesses.include?(@guess)
  end

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
    when 7
      @hangman_lower_body = '/ \\'
      game_over
    end
  end

  def game_over
    @game_over = true
    update_display
    if @failed_tries == 7
      puts 'You just lost the game. Try again? Y/N'
    else
      puts 'You won the game! Play again? Y/N'
    end
    replay?
  end

  def replay?
    @replay = gets.chomp.upcase
    if @replay == 'Y'
      pick_game_difficulty
    elsif @replay == 'N'
      puts '  Thank you for playing "Hangman"!'
    else
      puts '   Invalid input. Please choose between "Y" or "N".'
      replay?
    end
  end

  # The methods below are mostly about updating visual graphics to the player
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
    puts "  You've already tried these letters: #{@guesses}" unless @game_over == true || @guesses.empty?
    puts '  Guess a letter!' unless @game_over == true
  end
end

game_settings = GameSetup.new
game_settings.pick_game_difficulty

newgame = Game.new(game_settings.random_word, game_settings.hints)
newgame.game_running
