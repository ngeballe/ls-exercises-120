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
    rank_number <=> other_card.rank_number
  end

  def to_s
    "#{@rank} of #{@suit}"
  end
  
  protected

  def rank_number
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

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
puts drawn.count { |card| card.rank == 5 } == 4
puts drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }

puts drawn != drawn2 # Almost always.
