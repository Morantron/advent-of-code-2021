require 'matrix'

class Board
  def self.parse(board)
    rows = board.split("\n")
                .map { |row| row.split(/ +/).map(&:to_i) }
    
    self.new(Matrix[*rows])
  end

  def initialize(matrix)
    self.matrix = matrix
  end

  def mark(number)
    position = matrix.find_index(number)

    return if position.nil?

    matrix[*position] = nil
  end
  
  def win?
    any_completely_marked?(matrix.column_vectors) ||
    any_completely_marked?(matrix.row_vectors)
  end

  def score
    matrix.reduce(0) { |acc, cell| acc + (cell || 0) }
  end

  private
  
  attr_accessor :matrix

  def any_completely_marked?(vectors)  
    vectors.any? { |vec| vec.all?(&:nil?) }
  end
end

def parse_input
  sequence, *boards = File.open("input.txt").read.split("\n\n")

  sequence = sequence.split(",").map(&:to_i)
  boards = boards.map { |board| Board.parse(board) }

  [sequence, boards]
end

class BingoSystem
  def initialize
    sequence, boards = parse_input
    self.sequence = sequence
    self.boards = boards
  end

  def score
    play!
    winning_board.score * number
  end

  private

  attr_accessor :sequence, :boards, :number, :winning_board

  def play!
    sequence.each do |number|
      self.number = number

      boards.each do |board|
        board.mark(number)

        if board.win?
          self.winning_board = board
          return
        end
      end
    end
  end
end

result = BingoSystem.new.score

puts "Result: #{result}"
