# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'board'
# Answers whether a move is legal, illegal
class Arbiter
  extend RuleHelper

  attr_reader :state, :kings, :board

  def initialize(board)
    @board = board
  end

  def pawn_promotion?(destination)
    if board.piece_at(destination).is_a?(Pawn)
      return true if destination[1]%7 == 0
    end
  end

  def no_legal_moves_for?(color)
    !any_legal_moves_for?(color)
  end

  def any_legal_moves_for?(color)
    board.pieces_of_color(color).each do |piece|
      return true if piece_has_legal_moves?(piece)
    end
    return false
  end

  def piece_has_legal_moves?(piece)
    location = piece.location
    moves = piece.moves
    moves.each do |move|
      return true if legal_move?(location, move)
    end
    false
  end

  def legal_move?(from, to)
    return false unless board.piece_at(from).moves.include? to
    return false if king_checked_after_move?(from, to)

    if RuleHelper.move_type(from, to, board) == :castling
      return legal_castling?(from, to)
    end

    true
  end

  def king_checked_after_move?(from, to)
    kings_color = board.piece_at(from).color
    board.move(from, to)
    if board.kings[kings_color].checked?
      board.undo_move
      true
    else
      board.undo_move
      false
    end
  end

  def legal_castling?(from, destination)
    # King may not castle out of, through, or into check.
    # (Last already check before calling this method)
    king = board.piece_at(from)
    direction = destination.sum > king.location.sum ? :right : :left
    return false if king.checked?
    return false if castling_line_checked?(king, direction)
    true
  end

  def castling_line_checked?(king, direction)
    king.castling_line(direction).each do |point|
      return true if board.square_at(point).under_attack?(king.enemy_color)
    end
    false
  end
end
