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
    @round_counter = 12
  end

  def request_input
    input = gets.chomp
    check_valid_input(input)
    p input
    edit_layout(input.upcase)
    puts "Your colors are: #{input.upcase}."
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
end


class Play < Logic
  def play_game
    puts 'Welcome to Mastermind!'
    create_field
    12.times do
      puts 'Please enter four colors.'
      request_input
    end
  end
end

test = Play.new
test.play_game
