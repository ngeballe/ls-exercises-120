class Banner
  def initialize(message, width = nil)
    @message = message
    @width = width
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-#{'-' * @message.size}-+"
  end

  def empty_line
    "| #{' ' * @message.size} |"
  end

  def message_line
    message_formatted = @width ? @message.center(@width) : @message
    "| #{message_formatted} |"
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner = Banner.new('')
puts banner

banner = Banner.new("Let's have a ban on Bannon!", 100)
