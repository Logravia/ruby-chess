# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'board'
# Answers whether a move is legal, illegal
class Arbiter
  extend RuleHelper

  attr_reader :state, :kings, :board

  def initialize(board)
    @board = board
    @kings = board.kings
  end

  def legal_move?(from, to)
    return false if from == to
    return false unless squares_within_board?(from, to)
    return false if square_empty?(from)
    return false if king_checked_after_move?(from, to)
    piece = board.piece_at(from)

    if RuleHelper.move_type(from, to, board) == :castling
      legal_castling?(to, piece)
    else
      piece.moves.include? to
    end
  end

  def squares_within_board?(from, to)
    (RuleHelper.within_board?(from) and RuleHelper.within_board?(to))
  end

  def square_empty?(location)
    board.square_at(location).empty?
  end

  def king_checked_after_move?(from, to)
    kings_color = board.piece_at(from).color
    board.move(from, to)

    if kings[kings_color].checked?
      board.undo_move
      true
    else
      board.undo_move
      false
    end
  end

  def legal_castling?(destination, king)
    return false if king.moved?

    direction = destination.sum > king.location.sum ? :right : :left
    # 1. One may not castle out of, through, or into check.
    return false if king.checked?
    return false if castling_line_checked?(king, direction)

    # 2. Rook must be able to reach king's side without having been moved.
    rooks_square = board.square_at(king.rook_squares[direction])
    rook = rooks_square.piece
    return false if rooks_square.empty? || (rook.class != Rook)
    return false if rook.moved
    kings_side_square = king.castling_line(direction).first

    towards_king = direction == :left ? :right : :left
    rook.categorized_possible_moves[towards_king].include? kings_side_square
  end

  def castling_line_checked?(king, direction)
    king.castling_line(direction).each do |point|
      return true if board.square_at(point).under_attack?(king.enemy_color)
    end
    false
  end
end
