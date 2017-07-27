require 'pry'

25.downto(-25) do |num|
  begin
    puts num
    puts 100 / num
  rescue 
    # puts "Can't divide by 0"
    binding.pry
  end
end
