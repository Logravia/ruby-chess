# frozen_string_literal: true

require_relative 'rule_helper'
# Answers whether a move is legal.
# Does so by looking at the state of the board,
# And asking the relevant piece being moved how it can move.
# Allows castling, en passant and pawns capturing other pieces to be possible.
class Arbiter
  extend RuleHelper

  attr_reader :state

  def initialize(state)
    @state = state
  end

  def legal_move?(from, _to)
    from_col, from_row = from
    piece = state[from_row][from_col]
    false
  end
end
