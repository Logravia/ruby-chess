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

  def legal_move?(from, to)
    piece = piece_at(from)

    return legal_for_king?(from, to) if piece.class == King
    return legal_for_pawn?(from, to) if piece.class == Pawn

    # What makes a move legal for most pieces?
    # TODO: Does not go past a piece
    # TODO: Does not go on top of a friendly piece
    # TODO: Follows all the rules set for the pieces movements
    # TODO: Move does not leave King in check (if after move king in check, illegal)
  end

  def legal_for_pawn?(from,to)
    false
  end

  def legal_for_king?(from, to)
    false
  end

  # Reduces movement to squares that do not go past a standing piece
  def cut_move_line(line)
    line.each_with_index do |point, distance|
      return line[0..distance] if piece_at(point)
    end
  end

  def piece_at(position)
    column, row = position
    state[row][column]
  end
end