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
    # TODO: consider rewriting moves method for King
    # unmoved? ? super + castling_squares : super
    super
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
    [[6, @my_row],[2, @my_row]]
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
