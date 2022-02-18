# frozen_string_literal: true

require_relative 'piece'

# TODO: Write tests for King, because its movements differ significantly from other classes
# King moves just like a Queen or rather Piece except only one square in all directions
class King < Piece
  CUR_MOVES = ALL_MOVES.reject { |move, _v| move == :jumps }

  def initialize(color, square)
    super
    @moved = false
    @enemy_color = @color == :white ? :black : :white
  end

  def possible_moves
    all_moves = super
    all_moves.each_pair do |move_name, squares|
      all_moves[move_name] = squares.first
    end
  end

  def checked?
    square.under_attack?(@enemy_color)
  end

end
