class CircularQueue
  attr_reader :queue, :in_order_added

  def initialize(buffer_size)
    @buffer_size = buffer_size
    @queue = Array.new(@buffer_size)
    @in_order_added = []
  end

  def enqueue(new_object)
    dequeue if @queue.compact.size == @buffer_size
    if queue.any?(&:nil?)
      first_nil = queue.index(nil)
      queue[first_nil] = new_object
    end
    @in_order_added << new_object
  end

  def dequeue
    if @queue.empty?
      nil
    else
      oldest = in_order_added.first
      queue[queue.index(oldest)] = nil
      in_order_added.delete(oldest)
      oldest
    end
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
