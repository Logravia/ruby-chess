# frozen_string_literal: true
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'
require_relative 'rule_helper'

# Board keeps track of pieces
# Moves them without taking into account legality of the move
class Board
  extend RuleHelper

  attr_reader :state

  def initialize
    @state =
      [ranked_row(:white),
       pawn_row(:white),
       Array.new(RuleHelper.WIDTH),
       Array.new(RuleHelper.WIDTH),
       Array.new(RuleHelper.WIDTH),
       Array.new(RuleHelper.WIDTH),
       ranked_row(:black),
       pawn_row(:black),
      ]
  end

  def move_piece(from, to)
    from_col, from_row = from
    to_col, to_row = to

    piece = @state[from_row][from_col]
    @state[to_row][to_col] = piece
    @state[from_row][from_col] = nil

    # Rooks, kings and pawns have :moved
    # It is useful to track that because,
    # it allows us to properly implement:
    # castling, en passant and pawn double move
    piece.moved = true if piece.class.method_defined? :moved
  end

  def ranked_row(color)
   [
    Rook.new(color),
    Knight.new(color),
    Bishop.new(color),
    Queen.new(color),
    King.new(color),
    Bishop.new(color),
    Knight.new(color),
    Rook.new(color)
   ]
  end

  def pawn_row(color)
    Array.new(RuleHelper.WIDTH) { Pawn.new(color) }
  end

end
