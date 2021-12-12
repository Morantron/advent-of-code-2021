require 'csv'
require 'matrix'

input = CSV.new(File.open('input.csv')).read.flatten


m = Matrix[*input.map { |row| row.split('').map(&:to_i) }]

gamma = ''
epsilon = ''

m.column_vectors.each do |vec|
  most_common = vec.tally.max_by { |k, v| v }.first
  least_common = 1 - most_common

  gamma += most_common.to_s
  epsilon += least_common.to_s
end

result = gamma.to_i(2) * epsilon.to_i(2)
puts "Result is: #{result}"
