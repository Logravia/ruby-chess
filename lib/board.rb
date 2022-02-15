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
       Array.new(RuleHelper::WIDTH),
       Array.new(RuleHelper::WIDTH),
       Array.new(RuleHelper::WIDTH),
       Array.new(RuleHelper::WIDTH),
       pawn_row(:black),
       ranked_row(:black)
      ]
      give_pieces_location
  end

  def move_piece(from, to)
    from_col, from_row = from
    to_col, to_row = to

    return if state[from_row][from_col].nil?

    piece = @state[from_row][from_col]
    @state[to_row][to_col] = piece
    @state[from_row][from_col] = nil
    piece.location = to

    # Rooks, kings and pawns have :moved
    # It is useful to track that because,
    # it allows us to properly implement:
    # castling, en passant and pawn double move
    piece.moved = true if piece.class.method_defined? :moved
  end

  def ranked_row(color)
    [
      Rook.new(color,self),
      Knight.new(color,self),
      Bishop.new(color,self),
      Queen.new(color,self),
      King.new(color,self),
      Bishop.new(color,self),
      Knight.new(color,self),
      Rook.new(color,self)
    ]
  end

  def pawn_row(color)
    Array.new(RuleHelper::WIDTH) { Pawn.new(color, self) }
  end

  def give_pieces_location
    state.each_with_index do |row, row_num|
      row.each_with_index do |piece, piece_num|
        next if piece.nil?
        piece.location = [row_num, piece_num]
      end
    end
  end

  def piece_at(position)
    column, row = position
    @state[row][column]
  end
end
