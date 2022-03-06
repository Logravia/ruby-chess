# frozen_string_literal: true

require_relative 'piece'
require_relative '../rule_helper'

class Knight < Piece
  JUMPS = [[2, 1], [2, -1], [-2, 1], [-2, -1],
           [1, 2], [-1, 2], [1, -2], [-1, -2]].freeze

  def categorized_possible_moves
    { jumps: rm_friendly_attacks(rm_outside_board(make_jumps)) }
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
