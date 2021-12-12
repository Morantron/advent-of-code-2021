require 'csv'

list = CSV.new(File.open('sample.csv')).read.flatten

class BaseRating
  def initialize(list)
    self.list = list
    self.position = 0
  end

  def calculate
    while list.length > 1
      self.list = filter_list_where(value: filter_value) 
      self.position += 1

      @bit_count = nil
    end

    list.first.to_i(2)
  end

  protected
  
  attr_accessor :list, :remaining, :bit_count, :position

  def filter_value
    raise NotImplementedError
  end

  def bit_count
    @bit_count ||= list.map { |item| item[position] }.tally
  end

  def draw?
    bit_count["0"] == bit_count["1"]
  end

  def filter_list_where(value:)
    list.select { |item| item[position] == value }
  end
end

class OxygenGeneratorRating < BaseRating
  def filter_value
    if draw?
      '1'
    else
      bit_count.max_by { |k, v| v }[0]
    end
  end
end

class CO2ScrubingRating < BaseRating
  def filter_value
    if draw?
      '0'
    else
      bit_count.min_by { |k, v| v }[0]
    end
  end
end

result = OxygenGeneratorRating.new(list).calculate * CO2ScrubingRating.new(list).calculate

puts "Result is: #{result}"
