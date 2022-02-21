# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'board'
# Answers whether a move is legal, illegal
class Arbiter
  extend RuleHelper
  CASTLING_SQUARES = {white: {[0,2] => :left, [0,6] => :right},
                      black: {[7,2] => :left, [7,6] => :right}}

  attr_reader :state, :kings, :board
  private_constant :CASTLING_SQUARES

  def initialize(board)
    @board = board
    @state = board.state
    @kings = board.kings
  end

  # TODO: Implement legal_move?
  def legal_move?(from, to, color)
    # What makes a move legal for most pieces?
    #   Move does not leave King in check (if after move king in check, illegal)
    #   Does not go on top of a friendly piece
    #   Does not go past a piece
    #   Follows all the rules set for the pieces movements
  def king_checked_after_move?(from, to)
    kings_color = board.piece_at(from).color
    board.move_piece(from, to)

    if kings[kings_color].checked?
      board.undo_move
      false
    else
      board.undo_move
      true
    end

  end

  def piece_can_move_to?(destination, piece)
    piece.possible_moves.values.include? destination
  end

  end

  def castling_line_checked?(king, direction)
    king.castling_line(direction).each do |point|
     board.square_at(point).under_attack?
   end
  end

end
