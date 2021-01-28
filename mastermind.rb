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
    @computer_combination = []
  end

  def new_combination
    @computer_combination = generate_combination
    p @computer_combination
  end

  def request_input
    you_lose if @round_counter.zero?
    input = gets.chomp
    if check_valid_input(input) == 'invalid'
      request_input
    else
      edit_layout(input.upcase)
      evaluate_input(input.upcase.split)
    end
  end

  def edit_layout(input)
    @playing_field[@round_counter] = input.split
    create_field
    @round_counter -= 1
  end

  def check_valid_input(input)
    if input.split.length != 4
      puts 'Error: incorrect input length. Please enter four letters.'
      'invalid'
    elsif input.split.any? { |color| COLORS.include?(color) == false }
      puts 'Error: incorrect input. Please enter valid characters.'
      'invalid'
    end
  end

  def evaluate_input(input)
    puts "There are #{right_place(input)} colors in the right place and #{right_color(input)} right colors in the wrong place."
    victory if right_place(input) == 4
  end

  def right_place(input)
    right_place = 0
    input.each_with_index do |letter, index|
      if letter == @computer_combination[index]
        right_place += 1
      end
    end
    right_place
  end

  def right_color(input)
    computer_count = []
    player_count = []
    input.each_with_index do |letter, index|
      if letter != @computer_combination[index] && @computer_combination.include?(letter)
        player_count.push(letter)
        computer_count.push(@computer_combination[index])
      end
    end
    total = computer_count & player_count
    total.length
  end

  # def calc_right_color(array_one, array_two)
  #   same_letters = 0
  #   array_one.each do |letter|
  #     same_letters += 1 if array_two.include?(letter)
  #   end
  #   return 0 if same_letters.zero?

  #   # if sum_array(array_one) <= sum_array(array_two)
  #   #   sum_array(array_one)
  #   # else
  #   #   sum_array(array_two)
  #   # end
  #   p array_one & array_two
  # end

  private

  def generate_combination
    rand_array = []
    4.times do
      rand_array.push(rand(6))
    end
    rand_array.map { |number| COLORS[number] }
  end
end

class Play < Logic
  def play_game
    playing_field = Layout.new
    @round_counter = 11
    puts 'Welcome to Mastermind!'
    playing_field.create_field
    new_combination
    13.times do
      puts 'Please enter four colors.'
      request_input
    end
  end

  def play_again
    puts 'Would you like to play again? (y/n)'
    input = gets.chomp.downcase
    case input
    when 'y' then play_game
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
test.play_game
