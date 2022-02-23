# frozen_string_literal: true

require_relative 'piece'

class King < Piece
  attr_writer :moved

  def initialize(color, square)
    super
    @moved = false
    @my_row = location[1]
  end

  # King moves just like a Queen except only one square in all directions
  def possible_moves
    all_moves = super
    all_moves.each_pair do |move_name, squares|
      all_moves[move_name] = squares.first
    end
  end

  def rook_squares
    { left: board.square_at([0, @my_row]), right: board.square_at([-1, @my_row]) }
  end

  def castling_line(direction)
    line = []
    2.times { line << sum_coordinates(location, ALL_MOVES[direction]) }
    line
  end

  def checked?
    enemy_color = @color == :white ? :black : :white
    square.under_attack?(enemy_color)
  end

  def moved?
    @moved
  end
end
