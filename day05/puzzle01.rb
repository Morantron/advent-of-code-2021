require 'matrix'

def parse_input
  File.open("input.txt").read.split("\n").map do |raw_line|
    from, to = raw_line.split(" -> ")
    from = from.split(",").map(&:to_i)
    to = to.split(",").map(&:to_i)

    [from, to]
  end
end

lines = parse_input

points = lines.flatten(1)
w = points.map {|e| e[0] }.max + 1
h = points.map {|e| e[1] }.max + 1

m = Matrix.build(w, h) { 0 }

lines
  .filter do |line|
    x1, y1, x2, y2 = line.flatten

    x1 == x2 || y1 == y2
  end
  .each do |line|
    from, to = line

    x_range = Range.new(*[from[0], to[0]].sort)
    y_range = Range.new(*[from[1], to[1]].sort)

    puts "from #{from}"
    puts "to #{to}"
    puts "x_range #{x_range}"
    puts "y_range #{y_range}"

    x_range.each do |x|
      y_range.each do |y|
        m[x, y] += 1
      end
    end
  end

result = m.filter { |e| e > 1 }.count
puts "Result is #{result}"
