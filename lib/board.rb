# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'fen_parser'

# Board moves pieces around and reports where they are
class Board
  extend RuleHelper
  include FenParser

  attr_reader :state, :kings, :move_buffer

  def initialize(state=make_board(RuleHelper::DEFAULT_BOARD))
    @state = state
    @move_buffer = {start_square: nil, end_square: nil, destroyed_piece: nil}
  end

  def move_piece(starting_point, destination)
    save_move(starting_point, destination)
    piece_to_move = square_at(starting_point).remove_piece
    square_at(destination).set_piece(piece_to_move)
  end

  def save_move(starting_point, destination)
    @move_buffer[:start_square] = square_at(starting_point)
    @move_buffer[:end_square] = square_at(destination)
    @move_buffer[:destroyed_piece] = piece_at(destination)
  end

  def undo_move
    piece_to_restore = @move_buffer[:destroyed_piece]
    moved_piece = @move_buffer[:end_square].piece
    @move_buffer[:end_square].set_piece(piece_to_restore)
    @move_buffer[:start_square].set_piece(moved_piece)
  end

  def piece_at(position)
    square_at(position).piece
  end

  def square_at(position)
    column, row = position
    @state[row][column]
  end

  def pieces_of_color(color)
    pieces = []
    state.each do |row|
      row.each do |square|
        next if square.empty?
        piece = square.piece
        pieces << piece if piece.color == color
      end
    end
    pieces
  end
end
