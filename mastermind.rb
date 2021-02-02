class Layout
  COLORS = %w[R G B Y P W r g b y p w].freeze

  def initialize
    @playing_field = Array.new(12, %w[o o o o])
  end

  def create_field
    @playing_field.each do |array|
      puts "| #{array[0]} #{array[1]} #{array[2]} #{array[3]} |"
    end
  end
end

class Logic < Layout
  def initialize
    super
    @round_counter = 11
    @combination = []
  end

  def new_combination
    @combination = generate_combination
  end

  def request_input
    you_lose if @round_counter.zero?
    input = gets.chomp
    if check_valid_input(input) == 'invalid'
      request_input
    else
      edit_layout(input.upcase.split)
      evaluate_input(input.upcase.split)
    end
  end

  def request_player_code
    puts 'Please create a code for the computer to guess. You can use any of the following colors: R, G, B, Y, P, W.'
    code = gets.chomp
    check_valid_input(code)
    @combination = code.split
  end

  def edit_layout(input)
    @playing_field[@round_counter] = input
    create_field
    @round_counter -= 1
  end

  def check_valid_input(input)
    if input == 'exit' then exit
    elsif input.split.length != 4
      puts 'Error: incorrect input length. Please enter four characters.'
      'invalid'
    elsif input.split.any? { |color| COLORS.include?(color) == false }
      puts 'Error: incorrect input. Please enter valid characters.'
      'invalid'
    end
  end

  def evaluate_input(input)
    puts "Colors in the right place: #{right_place(input)}. Right colors, but in the wrong place: #{right_color(input)}."
    victory if right_place(input) == 4
  end

  def right_place(input)
    right_place = 0
    input.each_with_index do |letter, index|
      if letter == @combination[index]
        right_place += 1
      end
    end
    right_place
  end

  def wrong_place_index(input)
    wrong_index = []
    input.each_with_index do |letter, index|
      if letter != @combination[index]
        wrong_index.push(index)
      end
    end
    wrong_index
  end

  def right_color(input)
    computer_count = []
    player_count = []
    input.each_with_index do |letter, index|
      if letter != @combination[index] && @combination.include?(letter)
        player_count.push(letter)
        computer_count.push(@combination[index])
      end
    end
    total = computer_count & player_count
    total.length
  end

  private

  def generate_combination
    rand_array = []
    4.times do
      rand_array.push(rand(6))
    end
    rand_array.map { |number| COLORS[number] }
  end
end

class Computer < Logic
  def computer_play
    i = 1
    n = initial_guess
    until n == @combination
      filter_guess(n, wrong_place_index(n))
      i += 1
    end
    i
  end

  def filter_guess(guess, index_array)
    index_array.each { |index| guess[index] = generate_letter }
  end

  def generate_letter
    COLORS[rand(6)]
  end

  def initial_guess
    rand_array = []
    4.times do
      rand_array.push(rand(6))
    end
    rand_array.map { |number| COLORS[number] }
  end
end

class Play < Computer
  def game_start
    explain_rules
    choose_game_mode
  end

  def explain_rules
    puts 'Welcome to Mastermind!'
    puts 'Which mode would you like to play?'
    puts '1. you crack the computer\'s code'
    puts '2. create your own code and have the computer crack it'
  end

  def choose_game_mode
    choice = gets.chomp
    case choice
    when '1' then player_guesses
    when '2' then computer_guesses
    else
      puts 'Please type in either 1 or 2.'
      choose_game_mode
    end
  end

  def player_guesses
    @round_counter = 11
    @playing_field = Array.new(12, %w[o o o o])
    create_field
    new_combination
    13.times do
      puts 'Please enter four colors. (Available colors are: R, G, B, Y, P, W)'
      request_input
    end
  end

  def computer_guesses
    request_player_code
    puts "It took the computer #{computer_play} guesses to break your code!"
    play_again
  end

  def play_again
    puts 'Would you like to play again? (y/n)'
    input = gets.chomp.downcase
    case input
    when 'y' then game_start
    when 'n' then exit
    else
      puts "Please enter either 'y' (yes) or 'n' (no)."
      play_again
    end
  end

  def victory
    puts "Congratulations, you win! It took you #{11 - @round_counter} guesses."
    play_again
  end

  def you_lose
    puts 'Unfortunately you have run out of guesses, so you lose. But why not try gain!'
    play_again
  end
end

test = Play.new
test.game_start