# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'board'
# Answers whether a move is legal.
# Does so by looking at the state of the board,
# And asking the relevant piece being moved how it can move.
# Allows castling, en passant and pawns capturing other pieces to be possible.
class Arbiter
  extend RuleHelper

  attr_reader :state, :kings, :board

  def initialize(board)
    @board = board
    @state = board.state
    @kings = board.kings
  end

  def legal_move?(from, to, color)
    # What makes a move legal for most pieces?
    # TODO: Move does not leave King in check (if after move king in check, illegal)
    # TODO: Does not go on top of a friendly piece
    # TODO: Does not go past a piece
    # TODO: Follows all the rules set for the pieces movements
  end
end
