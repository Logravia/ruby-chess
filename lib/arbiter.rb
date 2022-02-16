# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'board'
# Answers whether a move is legal.
# Does so by looking at the state of the board,
# And asking the relevant piece being moved how it can move.
# Allows castling, en passant and pawns capturing other pieces to be possible.
class Arbiter
  extend RuleHelper

  attr_reader :state, :kings

  def initialize(board)
    @board = board
    @state = board.state
    @kings = board.kings
  end

  def legal_move?(from, to, color)

    @board.temp_move(from, to)

    if check?(@kings[:color])
      @board.reverse_temp_move
      return false
    end


    piece = piece_at(from)
    return legal_for_king?(from, to, piece) if piece.class == King
    return legal_for_pawn?(from, to, piece) if piece.class == Pawn

    # What makes a move legal for most pieces?
    # TODO: Move does not leave King in check (if after move king in check, illegal)
    # TODO: Does not go on top of a friendly piece
    # TODO: Does not go past a piece
    # TODO: Follows all the rules set for the pieces movements
    @board.reverse_temp_move
  end

  def square_under_attack?(by_color, square)
    pieces = all_pieces(by_color)
    pieces.each do |piece|
      piece.possible_moves.each do |_move_name, move_group|
        return true if move_group.include? square
      end
    end
    false
  end

  def check?(king)
    enemy_color = king.color == :white ? :black : :white
    square_under_attack?(king.color, king.location)
  end

  def legal_for_pawn?(from,to,pawn)
    false
  end

  def legal_for_king?(from, to, king)
    false
  end

  def all_pieces(color)
    pieces = []
    state.each do |row|
      row.each do |piece|
        next if piece.nil?
        pieces << piece if piece.color == color
      end
    end
    pieces
  end

end
