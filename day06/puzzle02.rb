require 'csv'
require 'minitest/autorun'
require 'singleton'
require 'debug'

class LanternFishCache
  include Singleton

  def build(timer_val, days)
    self.cache ||= Hash.new do |h, k|
      h[k] = LanternFish.new(*k)
    end

    self.cache[[timer_val, days]]
  end

  private

  attr_accessor :cache
end

class LanternFish
  def initialize(timer_val, days)
    self.timer = timer_val
    self.days = days
    self.children = []
  end

  def to_s
    timer.to_s
  end

  def descendents_count
    @count ||= begin
      days.downto(1) { |remaining_days| tick(remaining_days) }

      children.length + children.map(&:descendents_count).sum
    end
  end

  def tick(remaining_days)
    breed(remaining_days) if should_breed?

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

  attr_accessor :timer, :world, :children, :days

  def breed_cycle
    7
  end

  def should_breed?
    timer.zero?
  end

  def breed(remaining_days)
    children << build_child(remaining_days)
  end

  def build_child(remaining_days)
    LanternFishCache.instance.build(breed_cycle + 1, remaining_days - 1)
  end
end

class Puzzle02
  def initialize(days:, input:)
    self.days = days
    self.input = input
    self.pool = []
    feed_input
  end

  def solution
    pool.size + pool.map(&:descendents_count).sum
  end

  private

  attr_accessor :days, :pool, :input

  def add(item)
    pool << item
  end

  def feed_input
    input.map { |timer| self.add(LanternFish.new(timer, days)) }
  end
end

describe Puzzle02 do
  it 'returns correct solution for first sample' do
    puzzle = Puzzle02.new(days: 18, input: [3,4,3,1,2])

    _(puzzle.solution).must_equal(26)
  end

  it 'returns correct solution for second sample' do
    puzzle = Puzzle02.new(days: 80, input: [3,4,3,1,2])

    _(puzzle.solution).must_equal(5934)
  end
end

puzzle = Puzzle02.new(days: 256, input: CSV.new(File.open('input.csv'), converters: %i[numeric]).read.flatten)

puts "Solution is #{puzzle.solution}"
