class Array
  def average
    reduce(:+).to_f / size
  end
end

seven = [8, 5, 3, 2, 7, -1, 8]

fives = seven.combination(5).to_a

p fives.sort_by { |array| array.average }
