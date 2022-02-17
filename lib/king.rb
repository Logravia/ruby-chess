# frozen_string_literal: true

require_relative 'piece'

# TODO: Write tests for King, because its movements differ significantly from other classes
# King moves just like a Queen or rather Piece except only one square in all directions
class King < Piece
  CUR_MOVES = ALL_MOVES.reject { |move, _v| move == :jumps }

  def possible_moves
    all_moves = super
    all_moves.each_pair do |move_name, squares|
      all_moves[move_name] = squares.first
    end
  end
  # TODO: track whether king has moved to determine castling legality
  # TODO: Add checked? method to king using square.under_attack?(color)
end
