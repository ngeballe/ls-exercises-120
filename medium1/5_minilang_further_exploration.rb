require 'set'

class MinilangRuntimeError < RuntimeError; end
class BadTokenError < MinilangRuntimeError; end
class EmptyStackError < MinilangRuntimeError; end

class Minilang
  ACTIONS = Set.new %w(PUSH ADD SUB MULT DIV MOD POP PRINT SQUARE SQRT)

  def initialize(program)
    @program = program
    @stack = []
    @register = 0
  end

  def eval(substitution_hash = nil)
    if substitution_hash
      specific_program = format(@program, substitution_hash)
    else
      specific_program = @program
    end
    specific_program.split.each { |token| eval_token(token) }
  rescue MinilangRuntimeError => error
    puts error.message
  end

  private

  def eval_token(token)
    if ACTIONS.include?(token)
      send(token.downcase)
    elsif token =~ /\A[-+]?\d+\z/
      @register = token.to_i
    else
      raise BadTokenError, "Invalid token: #{token}"
    end
  end

  def push
    @stack.push(@register)
  end

  def pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @register = @stack.pop
  end

  def add
    @register += pop
  end

  def div
    @register /= pop
  end

  def mod
    @register %= pop
  end

  def mult
    @register *= pop
  end

  def sub
    @register -= pop
  end

  def square
    @register = @register ** 2
  end

  def sqrt
    @register = Math.sqrt(@register)
  end

  def print
    puts @register
  end
end

CENTIGRADE_TO_FAHRENHEIT = '5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'

Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: 100)).eval
# 212
Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: 0)).eval
# 32
Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: -40)).eval
# -40

minilang = Minilang.new(CENTIGRADE_TO_FAHRENHEIT)
minilang.eval(degrees_c: 100)
minilang.eval(degrees_c: 20)
minilang.eval(degrees_c: 0)

FAHRENHEIT_TO_CENTIGRADE = '9 PUSH 5 PUSH 32 PUSH %<degrees_f>d SUB MULT DIV PRINT'
minilang = Minilang.new(FAHRENHEIT_TO_CENTIGRADE)
minilang.eval(degrees_f: 212)
minilang.eval(degrees_f: -40)
minilang.eval(degrees_f: 32)

MPH_TO_KPH = '3 PUSH 5 PUSH %<mph>d MULT DIV PRINT'
minilang = Minilang.new(MPH_TO_KPH)
minilang.eval(mph: 3)
minilang.eval(mph: 1000)
minilang.eval(mph: 300)

RECTANGLE_AREA = '%<width>d PUSH %<height>d MULT PRINT'
rectangle_area = Minilang.new(RECTANGLE_AREA)
rectangle_area.eval(height: 20, width: 7)
rectangle_area.eval(width: 24, height: 5)

HYPOTENUSE_LENGTH = '%<side1>d SQUARE PUSH %<side2>d SQUARE ADD SQRT PRINT'
square = Minilang.new(HYPOTENUSE_LENGTH)
square.eval(side1: 3, side2: 4)
square.eval(side1: 5, side2: 12)
square.eval(side1: 100, side2: 100)
