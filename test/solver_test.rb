require "minitest"
require "minitest/autorun"
require './lib/solver'

class SolverTest < Minitest::Test

  def test_it_can_make_a_row
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_rows
    assert_equal 9, solver.rows.size
    assert_equal Row, solver.rows[0].class
    assert_equal 9, solver.rows[3].spots.size
  end

  def test_it_makes_rows_correctly
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_rows
    row = solver.rows[0]
    assert_equal ' ', row.spots[0].value
    assert_equal '2', row.spots[1].value
    assert_equal '6', row.spots[2].value
    assert_equal '5', row.spots[3].value
    assert_equal '9', row.spots[4].value
    assert_equal '4', row.spots[5].value
    assert_equal '3', row.spots[6].value
    assert_equal '1', row.spots[7].value
    assert_equal '7', row.spots[8].value
  end

  def test_it_can_make_columns
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_columns
    assert_equal 9, solver.columns.size
    assert_equal Column, solver.columns[0].class
    assert_equal 9, solver.columns[5].spots.size
  end

  def test_it_makes_columns_correctly
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_columns
    column = solver.columns[0]
    assert_equal ' ', column.spots[0].value
    assert_equal '7', column.spots[1].value
    assert_equal '3', column.spots[2].value
    assert_equal '1', column.spots[3].value
    assert_equal '9', column.spots[4].value
    assert_equal '2', column.spots[5].value
    assert_equal '5', column.spots[6].value
    assert_equal '4', column.spots[7].value
    assert_equal '6', column.spots[8].value
  end

  def test_it_can_make_squares
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_rows
    solver.make_squares
    assert_equal 9, solver.squares.size
    assert_equal Square, solver.squares[0].class
    assert_equal 9, solver.squares[5].spots.size
  end



end
