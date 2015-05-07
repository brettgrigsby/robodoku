require_relative 'section'
require_relative 'spot'


class Solver
  attr_reader :rows, :columns, :squares, :spots

  def initialize(puzzle_string)
    @spots = (puzzle_string.chars - ["\n"]).map { |char| Spot.new(char) }
    @rows = []
    @columns = []
    @squares = []
    @sections = []
  end

  def solve
    make_board
    set_peers
    iterations = 0
    until solved?
      low_hanging_fruit
      find_hidden_singles
      find_naked_pairs
      find_hidden_pairs
      iterations += 1
      if iterations == 30
        raise RuntimeError, 'Sorry, bro'
      end
    end
    answer
  end

  def make_board
    rows_array = @spots.each_slice(9).to_a
    @rows = rows_array.map { |spots| Row.new(spots) }
    columns_array = rows_array.transpose
    @columns = columns_array.map { |spots| Column.new(spots) }
    squares_array = rows_array.each_slice(3).flat_map do |arrays|
      arrays.transpose.flatten
    end.each_slice(9).to_a
    @squares = squares_array.map { |spots| Square.new(spots) }
    @sections = @rows + @columns + @squares
  end

  def find_hidden_singles
    remove_peer_candidates
    @sections.each(&:find_hidden_single)
  end

  def find_naked_pairs
    remove_peer_candidates
    @sections.each(&:find_naked_pair)
  end

  def find_hidden_pairs
    remove_peer_candidates
    @sections.each(&:find_hidden_pair)
  end

  def set_peers
    @sections.each(&:set_peers)
  end

  def unsolved_spots
    @spots.select(&:unsolved?)
  end

  def remove_peer_candidates
    @spots.each(&:remove_peer_candidates)
  end

  def low_hanging_fruit
    remove_peer_candidates
    unsolved_spots.each(&:simple_solve)
  end

  def solved?
    @spots.none?(&:unsolved?)
  end

  def answer
    @rows.map(&:output).join("\n")
  end

end
