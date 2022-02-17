# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'fen_parser'

# Board moves pieces around and reports where they are
# TODO: Consider splitting it into two classes:
# PieceMover and Board
class Board
  extend RuleHelper
  include FenParser

  attr_reader :state, :kings

  def initialize
    @state = make_board(RuleHelper::DEFAULT_BOARD)
    @kings = {white: @state[4][0], black: @state[4][7]}
    @move_holder = {start_square: nil, end_square: nil, destroyed_piece: nil}
  end

  def move_piece(starting_point, destination)
    piece_to_move = piece_at(starting_point)
    square_at(starting_point).remove_piece
    end_square = square_at(destination)
    end_square.set_piece(piece_to_move)
  end

  def save_square_state(starting_point, destination)
    @move_holder[:start_square] = square_at(starting_point)
    @move_holder[:end_square] = square_at(destination)
    @move_holder[:destroyed_piece] = piece_at(destination)
  end

  # Used to help check whether a move is legal
  def temp_move(starting_point, destination)
    save_square_state(starting_point, destination)
    move_piece(starting_point, destination)
  end

  def revert_temp_move
    piece_to_restore = @move_holder[:destroyed_piece]
    moved_piece = @move_holder[:end_square].piece

    @move_holder[:end_square].set_piece(piece_to_restore)
    @move_holder[:start_square].set_piece(moved_piece)
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
