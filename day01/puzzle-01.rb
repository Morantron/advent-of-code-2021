require 'csv'

input = CSV.new(File.open('input.csv')).read.flatten.map(&:to_i)

inc_count = input.each_with_index.reduce(0) do |acc, pair|
 value, index = pair
 prev = input[index - 1]

 return acc if prev.nil?

 if value > prev
   acc + 1
 else
   acc
 end
end

puts "Result is: #{inc_count}"
