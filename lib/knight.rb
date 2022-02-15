# frozen_string_literal: true

require_relative 'piece'
require_relative 'rule_helper'

class Knight < Piece
  CUR_MOVES = ALL_MOVES.select { |move, _v| move == :jumps }

  def possible_moves
    possible_moves = CUR_MOVES.dup
    possible_moves[:jumps].map! { |jump_by| sum_coordinates(location, jump_by) }
    possible_moves[:jumps].select! { |squares| RuleHelper.within_board?(squares) }
    possible_moves
  end
end
