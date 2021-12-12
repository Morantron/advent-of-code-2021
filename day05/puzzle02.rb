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
  .each do |line|
    from, to = line
    x1, y1, x2, y2 = line.flatten

    length = [x1 - x2, y1 - y2].map(&:abs).max + 1

    xd = (x2 <=> x1)
    yd = (y2 <=> y1)

    length.times do |i|
      m[x1 + xd * i, y1 + yd * i] += 1
    end
  end

result = m.filter { |e| e > 1 }.count
puts "Result is #{result}"
