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
  attr_reader :cards

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
  include Comparable

  def initialize(cards)
    @cards = []
    @rank_count = Hash.new(0)

    cards.size.times do 
      card = cards.draw
      @cards << card
      @rank_count[card.rank] += 1
    end
  end

  def print
    puts @cards
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  def <=>(other_hand)
    self.value <=> other_hand.value
  end

  def value
    case
    when royal_flush?     then 9
    when straight_flush?  then 8
    when four_of_a_kind?  then 7
    when full_house?      then 6
    when flush?           then 5
    when straight?        then 4
    when three_of_a_kind? then 3
    when two_pair?        then 2
    when pair?            then 1
    else                       0
    end    
  end

  def self.best_5_card_hand(cards)
    five_card_hands = cards.combination(5).map { |cards| self.new(cards) }
    five_card_hands.max
  end

  private

  def royal_flush?
    straight_flush? && @cards.max.rank == "Ace"
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    n_of_a_kind?(4)
  end

  def full_house?
    n_of_a_kind?(3) && n_of_a_kind?(2)
  end

  def flush?
    # all same suit
    suit = @cards.first.suit
    @cards.all? { |card| card.suit == suit }
  end

  def straight?
    return false if @rank_count.any? { |_, count| count > 1 }

    @cards.max.value == @cards.min.value + 4
  end

  def three_of_a_kind?
    n_of_a_kind?(3)
  end

  def two_pair?
    @rank_count.values.count(2) == 2
    # @rank_count.select { |_, count| count == 2 }.size == 2
  end

  def pair?
    n_of_a_kind?(2)
  end

  def n_of_a_kind?(n)
    @rank_count.one? { |_, count| count == n }
  end
end

# hand = PokerHand.new(Deck.new)
# hand.print
# puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

royal_flush = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts royal_flush.evaluate == 'Royal flush'

straight_flush = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts straight_flush.evaluate == 'Straight flush'

four_of_a_kind = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts four_of_a_kind.evaluate == 'Four of a kind'

full_house = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts full_house.evaluate == 'Full house'

flush = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts flush.evaluate == 'Flush'

straight = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts straight.evaluate == 'Straight'

three_of_a_kind = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts three_of_a_kind.evaluate == 'Three of a kind'

two_pair = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts two_pair.evaluate == 'Two pair'

pair = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts pair.evaluate == 'Pair'

high_card = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts high_card.evaluate == 'High card'

cards_including_pair = [
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds'),
  Card.new(7, 'Clubs'),
  Card.new(6, 'Spades')
]
best_hand = PokerHand.best_5_card_hand(cards_including_pair)
puts best_hand.evaluate == 'Pair'
# puts PokerHand.best_5_card_hand(cards_including_pair).evaluate == 'Pair'

cards_including_royal_flush = [
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new(2, 'Clubs'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts'),
  Card.new(7, 'Spades')
]
puts PokerHand.best_5_card_hand(cards_including_royal_flush).evaluate == 'Royal flush'

cards_including_three_of_a_kind = [
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds'),
  Card.new('Ace', 'Diamonds'),
  Card.new(10, 'Clubs')
]
puts PokerHand.best_5_card_hand(cards_including_three_of_a_kind).evaluate == 'Three of a kind'

deck = Deck.new

best_hand = PokerHand.best_5_card_hand(Deck.new.cards)
best_hand.print
puts best_hand.evaluate
