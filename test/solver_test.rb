require "minitest"
require "minitest/autorun"
require './lib/solver'
require './lib/spot'

class SolverTest < Minitest::Test
  def test_it_can_make_a_row
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    assert_equal 9, solver.rows.size
    assert_equal Row, solver.rows[0].class
    assert_equal 9, solver.rows[3].spots.size
  end

  def test_it_makes_rows_correctly
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
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
    solver.make_board
    assert_equal 9, solver.columns.size
    assert_equal Column, solver.columns[0].class
    assert_equal 9, solver.columns[5].spots.size
  end

  def test_it_makes_columns_correctly
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
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
    solver.make_board
    assert_equal 9, solver.squares.size
    assert_equal Square, solver.squares[0].class
    assert_equal 9, solver.squares[5].spots.size
  end

  def test_it_makes_squares_correctly
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    square = solver.squares[0]
    assert_equal ' ', square.spots[0].value
    assert_equal '7', square.spots[1].value
    assert_equal '3', square.spots[2].value
    assert_equal '2', square.spots[3].value
    assert_equal '1', square.spots[4].value
    assert_equal '9', square.spots[5].value
    assert_equal '6', square.spots[6].value
    assert_equal '5', square.spots[7].value
    assert_equal '4', square.spots[8].value
  end

  def test_can_assign_peers
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    solver.set_peers
    assert_equal 24, solver.spots[0].peers.size
    assert_equal Spot, solver.spots[0].peers[0].class
  end

  def test_spots_can_tell_if_they_have_been_determined
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    assert solver.spots[0].unsolved?
    refute solver.spots[1].unsolved?
  end

  def test_spots_can_find_candidates
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    solver.set_peers
    solver.spots.each(&:remove_peer_candidates)
    assert_equal ['8'], solver.spots[0].candidates
  end

  def test_returns_unsolved_spots
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    assert_equal 1, solver.unsolved_spots.size
    assert_equal Spot, solver.unsolved_spots[0].class
  end

  def test_spots_can_solve_their_value_if_its_uniq
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    solver.set_peers
    solver.low_hanging_fruit
    assert_equal "8", solver.spots[0].value
  end

  def test_solves_puzzles_missing_1_value
    puzzle_text = File.read('./puzzles/easy_sample.txt')
    solver = Solver.new(puzzle_text)
    assert_equal "826594317\n715638942\n394721865\n163459278\n948267153\n257813694\n531942786\n482176539\n679385421", solver.solve
  end

  def test_solves_easy_puzzles
    puzzle_text = File.read('./puzzles/super_easy.txt')
    solver = Solver.new(puzzle_text)
    assert_equal "826594317\n715638942\n394721865\n163459278\n948267153\n257813694\n531942786\n482176539\n679385421", solver.solve
  end

  def test_sections_can_tell_a_spot_its_peers_possibilities
    puzzle_text = File.read('./puzzles/hidden_single.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    solver.set_peers
    solver.remove_peer_candidates
    row = solver.rows[2]
    assert_equal ['3','4','7','9'], row.sibling_candidates(row.spots[3])
  end

  def test_finds_hidden_singles
    puzzle_text = File.read('./puzzles/hidden_single.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    solver.set_peers
    solver.remove_peer_candidates
    solver.low_hanging_fruit
    solver.find_hidden_singles
    row = solver.rows[2]
    assert_equal '6', row.spots[3].value
  end

  def test_finds_naked_pairs
    puzzle_text = File.read('./puzzles/naked_pair.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    solver.set_peers
    solver.remove_peer_candidates
    square = solver.squares[4]
    square.find_naked_pair
    solver.low_hanging_fruit
    assert_equal '5', square.spots[0].value
  end

  def test_finds_hidden_pairs
    puzzle_text = File.read('./puzzles/hidden_pair.txt')
    solver = Solver.new(puzzle_text)
    solver.make_board
    solver.set_peers
    solver.remove_peer_candidates
    square = solver.squares[0]
    square.find_hidden_pair

    assert_equal ['4','7'], square.spots[0].candidates
    assert_equal ['4','7'], square.spots[3].candidates
  end

end
