class Person
  attr_accessor :secret

  # def secret=(string)
  #   @secret = string
  # end

  # def secret
  #   @secret
  # end
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
puts person1.secret
