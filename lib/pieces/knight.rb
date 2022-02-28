# frozen_string_literal: true

require_relative 'piece'
require_relative '../rule_helper'

class Knight < Piece
  JUMPS = [[2, 1], [2, -1], [-2, 1], [-2, -1],
           [1, 2], [-1, 2], [1, -2], [-1, -2]].freeze

  def categorized_possible_moves
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
    jumps.select do |jump|
      board.square_at(jump).empty? ||
        board.piece_at(jump).color != @color
    end
  end

  def rm_outside_board(jumps)
    jumps.select { |jump| RuleHelper.within_board?(jump) }
  end

  def make_jumps
    jumps = []
    start = location
    JUMPS.each { |jump| jumps << [jump, start].transpose.map(&:sum) }
    jumps
  end

end
