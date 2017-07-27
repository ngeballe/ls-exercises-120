class Card
  attr_reader :rank, :suit
  include Comparable

  FACE_CARD_VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }
  SUIT_VALUES = { 'Spades' => 4, 'Hearts' => 3, 'Clubs' => 2, 'Diamonds' => 1 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other_card)
    case rank_number <=> other_card.rank_number
    when 0 then suit_rank <=> other_card.suit_rank
    when 1 then 1
    else        -1
    end
  end

  def to_s
    "#{@rank} of #{@suit}"
  end
  
  protected

  def rank_number
    FACE_CARD_VALUES.fetch(@rank, @rank)
  end

  def suit_rank
    SUIT_VALUES[@suit]
  end
end

cards = [Card.new(2, 'Hearts'),
         Card.new(10, 'Diamonds'),
         Card.new('Ace', 'Clubs')]
puts cards
puts cards.min == Card.new(2, 'Hearts')
puts cards.max == Card.new('Ace', 'Clubs')

cards = [Card.new(5, 'Hearts')]
puts cards.min == Card.new(5, 'Hearts')
puts cards.max == Card.new(5, 'Hearts')

cards = [Card.new(4, 'Hearts'),
         Card.new(4, 'Diamonds'),
         Card.new(10, 'Clubs')]
puts cards.min.rank == 4
puts cards.min == Card.new(4, 'Diamonds')
puts cards.min != Card.new(4, 'Hearts')
puts cards.max == Card.new(10, 'Clubs')

cards = [Card.new(7, 'Diamonds'),
         Card.new('Jack', 'Diamonds'),
         Card.new('Jack', 'Spades')]
puts cards.min == Card.new(7, 'Diamonds')
puts cards.max.rank == 'Jack'
puts cards.max == Card.new('Jack', 'Spades')
puts cards.max != Card.new('Jack', 'Diamonds')

cards = [Card.new(8, 'Diamonds'),
         Card.new(8, 'Clubs'),
         Card.new(8, 'Spades')]
puts cards.min.rank == 8
puts cards.max.rank == 8
puts cards.min == Card.new(8, 'Diamonds')
puts cards.max == Card.new(8, 'Spades')
puts cards.max != Card.new(8, 'Diamonds')

puts Card.new(4, 'Clubs') > Card.new(4, 'Diamonds')
puts Card.new('Jack', 'Diamonds') < Card.new('Jack', 'Spades')
puts Card.new(8, 'Diamonds') > Card.new(7, 'Spades')
