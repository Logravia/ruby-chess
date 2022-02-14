# frozen_string_literal: true

require_relative 'piece'

class Knight < Piece
  CUR_MOVES = ALL_MOVES.select { |move, _v| move == :jumps }

  def possible_moves(from)
    possible_moves = CUR_MOVES.dup
    possible_moves[:jumps].map! { |jump_by| sum_coordinates(from, jump_by) }
    possible_moves[:jumps].select! { |squares| within_board?(squares) }
    possible_moves
  end
end
