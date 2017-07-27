class Animal
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new('Black')
cat1.color

p cat1.class.ancestors
lookup = [Cat, Animal]

p eval(lookup[0].to_s + ".new")
