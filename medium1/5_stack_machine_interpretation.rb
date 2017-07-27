# require 'pry'

class Minilang
  def initialize(commands)
    @commands = commands
    @stack = []
    @register = 0
  end

  def eval
    words = @commands.split
    words.each do |word|
      case word
      when /\d+/
        @register = word.to_i
      when "PUSH"
        @stack << @register
      when "ADD"
        @register += pop_stack
      when "SUB"
        @register -= pop_stack
      when "MULT"
        @register *= pop_stack
      when "DIV"
        @register /= pop_stack
      when "MOD"
        @register %= pop_stack
      when "POP"
        @register = pop_stack
      when "PRINT"
        puts @register
      else
        puts "Invalid token: #{word}"
        return
      end
    end
  end

  private

  def pop_stack
    if @stack.empty?
      puts "Empty stack!"
      return
    else
      @stack.pop
    end
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
