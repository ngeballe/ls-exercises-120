class Pet
  attr_reader :species, :name

  def initialize(species, name)
    @species = species
    @name = name
  end

  def to_s
    "a #{species} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_pet(pet)
    @pets << pet
  end

  def number_of_pets
    pets.size
  end

  def print_pets
    pets.each { |pet| puts pet }
  end
end

class Shelter
  attr_accessor :owners, :unadopted_pets

  def initialize
    # @owners = []
    @owners = {}
    @unadopted_pets = []
  end
  
  def adopt(owner, pet)
    # owners << owner unless owners.include?(owner)
    # owner.add_pet(pet)

    owner.add_pet(pet)
    @owners[owner.name] ||= owner
  end

  def add_unadopted(pet)
    @unadopted_pets << pet
  end

  def print_unadopted_pets
    puts "The Animal Shelter has the following unadopted pets:"
    puts @unadopted_pets
  end

  def number_of_unadopted_pets
    @unadopted_pets.size
  end

  def print_adoptions
    owners.each do |name, owner|
      puts "#{name} has adopted the following pets:"
      # puts owner.pets
      owner.print_pets
      puts
    end
  end
end  

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

asta       = Pet.new('dog', 'Asta')
laddie     = Pet.new('dog', 'Laddie')
fluffy     = Pet.new('cat', 'Fluffy')
kat        = Pet.new('cat', 'Kat')
ben        = Pet.new('cat', 'Ben')
chatterbox = Pet.new('parakeet', 'Chatterbox')
bluebell   = Pet.new('parakeet', 'Bluebell')
shelter.add_unadopted(asta)
shelter.add_unadopted(laddie)
shelter.add_unadopted(fluffy)
shelter.add_unadopted(kat)
shelter.add_unadopted(ben)
shelter.add_unadopted(chatterbox)
shelter.add_unadopted(bluebell)

shelter.print_unadopted_pets
shelter.print_adoptions
puts "The Animal Shelter has #{shelter.number_of_unadopted_pets} unadopted pets."
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."

