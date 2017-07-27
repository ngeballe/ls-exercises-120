class PingGame
  DEFAULT_RANGE = 1..100
  RESULT_MESSAGE = {
    high: 'Your number is too high.',
    lose: 'You are out of guesses. You lose.',
    low: 'Your number is too low.',
    win: 'You win!'
  }.freeze

  def initialize(low_value = nil, high_value = nil)
    @range = (low_value || DEFAULT_RANGE.min)..(high_value || DEFAULT_RANGE.max)
    @max_guesses = Math.log2(@range.size).to_i + 1
  end

  def play
    reset
    @max_guesses.downto(1) do |remaining_guesses|
      display_guesses_remaining(remaining_guesses)
      result = check_guess(obtain_guess)
      puts RESULT_MESSAGE[result]
      return if result == :win
    end

    puts "\n", RESULT_MESSAGE[:lose]
  end

  private

  def reset
    @number = rand(@range)
  end

  def display_guesses_remaining(remaining)
    puts
    if remaining == 1
      puts "You have 1 guess remaining."
    else
      puts "You have #{remaining} guesses remaining."
    end
  end

  def obtain_guess
    loop do
      print "Enter a number between #{@range.first} and #{@range.last}: "
      guess = gets.chomp.to_i
      return guess if @range.cover?(guess)
      print "Invalid guess. "
    end
  end

  def check_guess(guess)
    return :win if guess == @number
    return :low if guess < @number
    :high
  end
end

# game = PingGame.new
# game.play

# game = PingGame.new(101, 150)
# game.play

game = PingGame.new(501, 1500)
game.play
game.play
