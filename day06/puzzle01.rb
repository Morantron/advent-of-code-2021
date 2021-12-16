require 'csv'

class LanternFish
  def initialize(timer_val, world)
    self.timer = timer_val
    self.world = world
  end

  def to_s
    timer.to_s
  end

  def tick
    breed if should_breed?

    self.timer = case timer
                 when 8
                   7
                 when 7
                   6
                 else
                   (timer - 1) % breed_cycle
                 end
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
    pool.size.times do |index|
      fish = pool[index]
      fish.tick
    end
    self.day += 1
    print_state
  end

  attr_accessor :pool

  private

  attr_accessor :day

  def print_state
    puts "After day #{day.to_s.rjust(2)}"
    #puts "After day #{day.to_s.rjust(2)}: #{pool.join(",")}"
  end

  def input
    @input ||= CSV.new(File.open('sample.csv'), converters: %i[numeric]).read.flatten
  end

  def feed_input
    input.map { |item| self.add(LanternFish.new(item, self)) }
  end
end


n_days = 80
world = World.new
puts "==="
n_days.times { world.tick }

puts "After #{n_days} days, the fish population is #{world.pool.length}"
