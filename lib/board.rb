# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'fen_parser'

# Board moves pieces around and reports where they are
class Board
  extend RuleHelper
  include FenParser

  attr_reader :state, :move_buffer, :kings,  :en_passant_square

  def initialize(fen)
    @state = make_board(fen)
    @move_buffer = {start_square: nil, end_square: nil, destroyed_piece: nil}
    @en_passant_square = nil
    @kings = get_kings
  end

  #TODO: implement moving for castling, en passant.
  def move_piece(starting_point, destination)
    # TODO: After a move, if en passant was not taken advantage of it no longer is available.
    # Currenly en_passan_square is there permanently.

    # Move is saved so that it can be reverted later.
    # Allows to determine whether the move, left King in check,
    # which determines the move's legality.
    # Also, helps with en passant as it regards pawn
    save_move(starting_point, destination)

    piece = square_at(starting_point).remove_piece
    square_at(destination).set_piece(piece)

    # When King and Rook get moved it must be noted that they've been moved.
    # Otherwise, legality of castling can't be determined.
    handle_special_pieces(piece) if not piece.nil?
  end

  def handle_special_pieces(piece)
    if piece.is_a?(King) or piece.is_a?(Rook)
      piece.moved = true
    elsif piece.is_a?(Pawn)
      handle_pawn(piece)
    end
  end

  def handle_pawn(pawn)
    move_distance = calc_y_move_distance
    set_en_passant_square if move_distance == 2
    pawn.available_move_distance = 1
  end

  def set_en_passant_square
    pawn = @move_buffer[:end_square].piece
    square = board.square_at(pawn.square_behind)
    square.set_up_en_passant(pawn)
  end

  def calc_y_move_distance
    y_start = @move_buffer[:start_square].location[1]
    y_end = @move_buffer[:end_square].location[1]
    move_distance = (y_start - y_end).abs
  end

  def save_move(starting_point, destination)
    # TODO: Deal with en_passant saving
    # TODO: Deal with castling saves
    @move_buffer[:start_square] = square_at(starting_point)
    @move_buffer[:end_square] = square_at(destination)
    @move_buffer[:destroyed_piece] = piece_at(destination)
  end

  def undo_move
    # TODO: Deal with en_passant undoing
    # TODO: Deal with castling undoing
    piece_to_restore = @move_buffer[:destroyed_piece]
    moved_piece = @move_buffer[:end_square].piece
    @move_buffer[:end_square].set_piece(piece_to_restore)
    @move_buffer[:start_square].set_piece(moved_piece)
    @en_passant_square = nil
  end

  def piece_at(position)
    square_at(position).piece
  end

  def square_at(position)
    column, row = position
    @state[row][column]
  end

  def get_kings
    kings = {white: nil, black: nil}
    @state.each do |row|
      row.each do |square|
        piece = square.piece
        kings[piece.color] = piece if piece.class == King
      end
    end
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
