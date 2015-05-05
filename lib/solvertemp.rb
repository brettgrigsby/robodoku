

class Solver

  def initialize(puzzle_text)
    size = puzzle_text.index("\n")
    spots = puzzle_text.chars - ["\n"]
    @board = Board.new(spots, size)

  end

  def solve
    @board.populate
    # row = Row.new(@puzzle_text[0..8])
    # row.solve

  end

end

class Board
  attr_reader :rows

  def initialize(spots, size)
    @spots = spots
    @size = size
    @rows = []

  end

  def populate
    @spots.each_slice(@size) { |slice| @rows << Row.new(slice) }
    print @rows
  end

end

class Row

  def initialize(spots)
    @row_numbers = spots
  end

  def populate
  end

  def solve
    number = find_missing[0]
    string = @row_numbers.join
    puts string.gsub(/ /, number)
  end

  def find_missing
    full_row = (1..9).to_a.map(&:to_s)
    missing = full_row - @row_numbers

  end


end

