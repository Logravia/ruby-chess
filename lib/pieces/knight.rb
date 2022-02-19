# frozen_string_literal: true

require_relative 'piece'
require_relative '../rule_helper'

# TODO: Write test cases, because Knight's movements differ from all the other pieces
class Knight < Piece
  CUR_MOVES = ALL_MOVES[:jumps]

  def possible_moves
    my_location = location
    moves = {}

    possible_jumps = CUR_MOVES.map(&:clone)
    possible_jumps.map! { |jump_by| sum_coordinates(my_location, jump_by) }
    possible_jumps.select! { |squares| RuleHelper.within_board?(squares) }

    moves[:jumps] = rm_friendly_attacks(possible_jumps)
    moves
  end
  end
end
