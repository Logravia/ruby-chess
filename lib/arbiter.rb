# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'board'
# Answers whether a move is legal, illegal
class Arbiter
  extend RuleHelper
  CASTLING_SQUARES = { white: { [0, 2] => :left, [0, 6] => :right },
                       black: { [7, 2] => :left, [7, 6] => :right } }.freeze

  attr_reader :state, :kings, :board

  private_constant :CASTLING_SQUARES

  def initialize(board)
    @board = board
    @kings - board.kings
  end

  def legal_move?(from, to)
    return false if from == to
    return false unless squares_within_board?(from, to)
    return false if square_empty?(from)
    return false if king_checked_after_move?(from, to)

    piece = board.piece_at(from)

    if move_type(from, to) == :castling
      legal_castling?(from, to, piece)
    else
      piece.categorized_possible_moves.values.include? destination
    end
  end

  def squares_within_board?(from, to)
    (RuleHelper.within_board?(from) and RuleHelper.within_board?(to))
  end

  def square_empty?(location)
    !board.square_at(location).empty?
  end

  def king_checked_after_move?(from, to)
    kings_color = board.piece_at(from).color
    board.move_piece(from, to)

    board.undo_move
    if kings[kings_color].checked?
      false
    else
      true
    end
  end

  def move_type(from, to_destination)
    piece = board.piece_at(from)
    if piece.is_a?(King) && (piece.moved == false) && CASTLING_SQUARES[king.color].values.include?(to_destination)
      return :castling
    end

    # TODO: implement en_passant move type check
    # return :en_passant if piece.is_a?(Pawn) and
    :normal_move
  end

  def legal_castling?(_from, to, king)
    return false if king.moved?

    direction = CASTLING_SQUARES[king.color][to]
    # 1. One may not castle out of, through, or into check.
    return false if king.checked?
    return false if castling_line_checked?(king, direction)

    # 2. Rook must be able to reach king's side without having been moved.
    rooks_square = king.rook_squares[direction]
    rook = rooks_square.piece
    return false if rooks_square.empty? || (rook.class != Rook)
    return false if rook.moved

    kings_side_square = king.castling_line(direction).first
    rook.categorized_possible_moves[direction].include? kings_side_square
  end

  def castling_line_checked?(king, direction)
    king.castling_line(direction).each do |point|
      board.square_at(point).under_attack?
    end
  end
end
