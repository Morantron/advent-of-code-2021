require 'csv'

input = CSV.new(File.open('input.csv'), col_sep: ' ', converters: %i[numeric
]).read

class Submarine
  def initialize
    @x = 0
    @y = 0
  end

  def up(units)
    self.y -= units
  end

  def down(units)
    self.y += units
  end

  def forward(units)
    self.x += units
  end

  def result
    x * y
  end

  private

  attr_accessor :x, :y
end

submarine = Submarine.new

input.each do |row|
  command, units = row
  units = units.to_i

  puts "#{command} #{units}"

  submarine.send(command, units)
end

puts "Result is #{submarine.result}"
