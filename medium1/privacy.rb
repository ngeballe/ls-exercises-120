class Machine
  def initialize
    stop
  end

  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def switch_status
    puts switch == :on ? "The on/off light seems to be green. The machine must be on." : "The on/off light seems to be red. The machine must be off."
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

machine = Machine.new

machine.switch_status
machine.start

machine.switch_status

machine.stop
machine.switch_status
