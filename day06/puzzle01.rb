class LanternFish
  def initialize(timer_val, world)
    puts "timer_val: #{timer_val}"
    self.timer = timer_val
    self.world = world
  end

  def to_s
    timer.to_s
  end

  def tick
    breed if should_breed?

    self.timer = (self.timer - 1) % breed_cycle
  end

  private

  attr_accessor :timer, :world

  def breed_cycle
    7
  end

  def should_breed?
    timer.zero?
  end

  def breed
    world.add(build_child)
  end

  def build_child
    LanternFish.new(breed_cycle + 1, world)
  end
end

class World
  def initialize
    self.pool = []
    self.day = 0
    feed_input
    print_state
  end

  def add(item)
    pool << item
  end

  def tick
    pool.each(&:tick)
    self.day += 1
    print_state
  end

  private

  attr_accessor :pool, :day

  def print_state
    puts "After day #{day}: #{pool.join(",")}"
  end

  def input
    [3,4,3,1,2]
  end

  def feed_input
    input.map { |item| self.add(LanternFish.new(item, self)) }
  end
end

world = World.new
puts "==="
2.times { world.tick }
