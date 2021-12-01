require 'csv'

input = CSV.new(File.open('input.csv')).read.flatten.map(&:to_i)

def main(input)
  result = input.each_cons(3).map(&:sum).each_cons(2).reduce(0) do |acc, pair|
    prev, current = pair
    acc + (current > prev ? 1 : 0)
  end

  puts "Result is: #{result}"
end

main(input)
