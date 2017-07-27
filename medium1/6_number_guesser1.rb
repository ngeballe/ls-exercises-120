require 'pry'

class PingGame
  GUESSES_ALLOWED = 7

  def user_guesses
    puts
    puts "You have #{@guesses_remaining} guesses remaining."
    guess = nil
    loop do
      print "Enter a number between 1 and 100: "
      guess = gets.chomp
      break if guess =~ /\d+/ && (1..100).include?(guess.to_i)
      print "Invalid guess. "
    end
    @guess = guess.to_i
  end

  def display_guess_feedback
    if @guess < @number
      puts "Your guess is too low"
    elsif @guess > @number
      puts "Your guess is too high"
    end
  end

  def guessed_correctly?
    @guess == @number
  end

  def out_of_guesses?
    @guesses_remaining == 0
  end

  def display_game_result
    if guessed_correctly?
      puts "You win!"
    elsif out_of_guesses?
      puts "You are out of guesses. You lose."
    end
  end

  def reset
    @number = rand(1..100)
    @guess = nil
    @guesses_remaining = GUESSES_ALLOWED
  end

  def play
    reset
    loop do
      user_guesses
      display_guess_feedback
      @guesses_remaining -= 1
      break if guessed_correctly? || out_of_guesses?
    end
    display_game_result
  end
end

game = PingGame.new
game.play

game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# You win!



# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high

# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low

# You have 1 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low
# You are out of guesses. You lose.
