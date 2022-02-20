# frozen_string_literal: true

require_relative 'piece'
require_relative '../rule_helper'

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

  private

  def rm_friendly_attacks(jumps)
    good_jumps = []
    jumps.each do |jump|
      (good_jumps << jump; next) if board.square_at(jump).empty?
      good_jumps << jump if board.piece_at(jump).color !=  @color
    end
    good_jumps
  end
end
