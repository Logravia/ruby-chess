# frozen_string_literal: true

require_relative 'piece'

class King < Piece
  attr_writer :moved

  def initialize(color, square)
    super
    @moved = false
    @my_row = location[1]
  end

  def moves
    # King can move to castling squares if it hasn't been moved
    unmoved? ? super + castling_squares_as_moves : super
  end

  # TODO: refactor
  def castling_squares_as_moves
    moves = []
    if  castling_line(:left).size == 2 &&
        not board.square_at(rook_squares[:left]).empty? &&
        board.piece_at(rook_squares[:left]).unmoved?
      moves << castling_squares.first
    end
    if castling_line(:right).size == 2 &&
      not board.square_at(rook_squares[:right]).empty? &&
       board.piece_at(rook_squares[:right]).unmoved?
      moves << castling_squares.last
    end
    moves
  end

  # King moves just like a Queen except only one square in all directions
  def categorized_possible_moves
    all_moves = super
    all_moves.each_pair do |move_name, squares|
      all_moves[move_name] = [squares.first]
    end
  end

  def side(direction)
    Coords.new(location).coords_to(direction).plain_arr
  end

  def rook_squares
    { left: [0, @my_row], right: [7, @my_row] }
  end

  def castling_line(direction)
    moves = Piece.instance_method(:categorized_possible_moves).bind(self).call

    if moves[direction].nil?
      return []
    else
      moves[direction][0..1]
    end
  end

  def castling_squares
    [[2, @my_row], [6, @my_row]]
  end

  def enemy_color
    @color == :white ? :black : :white
  end

  def checked?
    square.under_attack?(enemy_color)
  end

  def moved?
    @moved
  end

  def unmoved?
    not @moved
  end

end
