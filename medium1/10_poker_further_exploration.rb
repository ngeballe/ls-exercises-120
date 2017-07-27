require 'pry'

class Card
  attr_reader :rank, :suit
  include Comparable

  FACE_CARD_VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other_card)
    value <=> other_card.value
  end

  def to_s
    "#{@rank} of #{@suit}"
  end
  
  def value
    FACE_CARD_VALUES.fetch(rank, rank)
  end
end

class Deck
  RANKS = (2..10).to_a + %w(Jack Queen King Ace).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    reset
  end

  def draw
    reset if @cards.none?
    @cards.shift
  end

  private

  def reset
    @cards = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        @cards << Card.new(rank, suit)
      end
    end
    @cards.shuffle!
  end
end

class PokerHand
  def initialize(cards)
    @cards = []
    @rank_count = Hash.new(0)

    5.times do 
      card = cards.draw
      @cards << card
      @rank_count[card.rank] += 1
    end
  end

  def print
    puts @cards
  end

  # def evaluate
  #   case
  #   when royal_flush?     then 'Royal flush' # 
  #   when straight_flush?  then 'Straight flush' #
  #   when four_of_a_kind?  then 'Four of a kind' #
  #   when full_house?      then 'Full house' #
  #   when flush?           then 'Flush' #
  #   when straight?        then 'Straight' #
  #   when three_of_a_kind? then 'Three of a kind' #
  #   when two_pair?        then 'Two pair' #
  #   when pair?            then 'Pair' #
  #   else                       'High card'
  #   end
  # end

  def self.flush?(cards)
    cards.map { |card| card.suit }.uniq.size == 1
  end

  def self.two_pair?(cards)
    self.rank_counts(cards).values.count(2) == 2
  end

  def self.pair?(cards)
    self.rank_counts(cards).values.count(2) == 1
  end

  def self.three_of_a_kind?(cards)
    self.rank_counts(cards).values.include?(3)
  end

  def self.four_of_a_kind?(cards)
    self.rank_counts(cards).values.include?(4)
  end

  def self.full_house?(cards)
    self.rank_counts(cards).values.sort == [2, 3]
  end

  def self.straight?(cards)
    values = cards.map(&:value)
    values.sort == values.min.step(values.max, 1).to_a
  end

  def self.straight_flush?(cards)
    self.flush?(cards) && self.straight?(cards)
  end

  def self.royal_flush?(cards)
    self.straight_flush?(cards) && cards.max.rank == 'Ace'
  end

  def self.high_card?(cards)
    !self.flush?(cards) && !self.straight?(cards) &&
      self.rank_counts(cards).all? { |_, v| v == 1 }
  end

  private

  def self.rank_counts(cards)
    counts = Hash.new(0)
    cards.each do |card|
      counts[card.rank] += 1
    end
    counts
  end

  # def royal_flush?
  #   straight_flush? && @cards.max.rank == "Ace"
  # end

  # def straight_flush?
  #   flush? && straight?
  # end

  # def four_of_a_kind?
  #   n_of_a_kind?(4)
  # end

  # def full_house?
  #   n_of_a_kind?(3) && n_of_a_kind?(2)
  # end

  # def flush?
  #   # all same suit
  #   suit = @cards.first.suit
  #   @cards.all? { |card| card.suit == suit }
  # end

  # def straight?
  #   return false if @rank_count.any? { |_, count| count > 1 }

  #   @cards.max.value == @cards.min.value + 4
  # end

  # def three_of_a_kind?
  #   n_of_a_kind?(3)
  # end

  # def two_pair?
  #   @rank_count.values.count(2) == 2
  #   # @rank_count.select { |_, count| count == 2 }.size == 2
  # end

  # def pair?
  #   n_of_a_kind?(2)
  # end

  # def n_of_a_kind?(n)
  #   @rank_count.one? { |_, count| count == n }
  # end
end

hand = PokerHand.new(Deck.new)
# hand.print
# puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

## class method testing

puts PokerHand.flush?([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])

puts PokerHand.pair?([
  Card.new(10,      'Hearts'),
  Card.new(10,      'Spades'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('Jack',  'Hearts')
])

puts PokerHand.two_pair?([
  Card.new(10,      'Hearts'),
  Card.new(10,      'Spades'),
  Card.new('Ace',   'Hearts'),
  Card.new('Ace', 'Clubs'),
  Card.new('Jack',  'Hearts')
])

puts PokerHand.three_of_a_kind?([
  Card.new(10,      'Hearts'),
  Card.new(10,      'Spades'),
  Card.new(10,   'Diamonds'),
  Card.new('Ace', 'Clubs'),
  Card.new('Jack',  'Hearts')
])

puts PokerHand.full_house?([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])

puts PokerHand.four_of_a_kind?([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])

puts PokerHand.straight?([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])

puts PokerHand.straight_flush?([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])

puts PokerHand.royal_flush?([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])

puts PokerHand.high_card?([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])


##

# hand = PokerHand.new([
#   Card.new(10,      'Hearts'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Queen', 'Hearts'),
#   Card.new('King',  'Hearts'),
#   Card.new('Jack',  'Hearts')
# ])
# puts hand.evaluate == 'Royal flush'

# hand = PokerHand.new([
#   Card.new(8,       'Clubs'),
#   Card.new(9,       'Clubs'),
#   Card.new('Queen', 'Clubs'),
#   Card.new(10,      'Clubs'),
#   Card.new('Jack',  'Clubs')
# ])
# puts hand.evaluate == 'Straight flush'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(3, 'Diamonds')
# ])
# puts hand.evaluate == 'Four of a kind'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Full house'

# hand = PokerHand.new([
#   Card.new(10, 'Hearts'),
#   Card.new('Ace', 'Hearts'),
#   Card.new(2, 'Hearts'),
#   Card.new('King', 'Hearts'),
#   Card.new(3, 'Hearts')
# ])
# puts hand.evaluate == 'Flush'

# hand = PokerHand.new([
#   Card.new(8,      'Clubs'),
#   Card.new(9,      'Diamonds'),
#   Card.new(10,     'Clubs'),
#   Card.new(7,      'Hearts'),
#   Card.new('Jack', 'Clubs')
# ])
# puts hand.evaluate == 'Straight'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(6, 'Diamonds')
# ])
# puts hand.evaluate == 'Three of a kind'

# hand = PokerHand.new([
#   Card.new(9, 'Hearts'),
#   Card.new(9, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(8, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Two pair'

# hand = PokerHand.new([
#   Card.new(2, 'Hearts'),
#   Card.new(9, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(9, 'Spades'),
#   Card.new(3, 'Diamonds')
# ])
# puts hand.evaluate == 'Pair'

# hand = PokerHand.new([
#   Card.new(2,      'Hearts'),
#   Card.new('King', 'Clubs'),
#   Card.new(5,      'Diamonds'),
#   Card.new(9,      'Spades'),
#   Card.new(3,      'Diamonds')
# ])
# puts hand.evaluate == 'High card'

