class Solver
  attr_reader :spots, :size, :rows, :columns, :squares

  def initialize(puzzle_text)
    @size = puzzle_text.index("\n")
    @spots = (puzzle_text.chars - ["\n"]).map { |num| Spot.new(num) }
    @chunk = Math.sqrt(size).to_i
    @rows = []
    @columns = []
    @squares = []
  end

  def make_rows
    spots.each_slice(size) { |slice| rows << Row.new(slice)}
  end

  def make_columns
    index = 0
    size.times do |i|
      column_spots = []
      until column_spots.size == size
        column_spots << spots[index]
        index += size
      end
      columns << Column.new(column_spots)
      index = i
    end
  end

  def make_squares
    front = 0
    back = @chunk - 1
    row_index = 0
    square_spots = []
    size.times do |i|
      until square_spots.size == size
        raise ArgumentError, "#{i}, #{squares.size}" if row_index == 9
        square_spots = square_spots + rows[row_index].spots[front..back]
        row_index += 1
      end
      squares << Square.new(square_spots)
      square_spots = []
      if row_index == size - 1
        front += @chunk
        back += @chunk
        row_index = 0
      end
    end
  end

  def first_three
    @chunk.times

  end

end

class Spot
  attr_reader :value, :peers
  def initialize(value)
    @value = value
    @peers = []
  end
end

class Section
  attr_reader :spots
  def initialize(spots)
    @spots = spots
  end
end

class Row < Section
end

class Column < Section
end

class Square < Section
end
