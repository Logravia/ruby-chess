# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'fen_parser'

# Board moves pieces around and reports where they are
class Board
  extend RuleHelper
  include FenParser

  attr_reader :state, :move_buffer, :kings, :en_passant_square

  def initialize(fen = RuleHelper::DEFAULT_BOARD)
    @state = make_board(fen)
    @previous_state = nil
    @move_buffer = { start_square: nil, end_square: nil }
    @remove_en_passant_this_turn = false
    @en_passant_square = nil
    @kings = get_kings
  end

  def move(start, target)
    move_type = RuleHelper.move_type(start, target, self)

    note_move(start, target)
    save_state
    move_piece(start, target)

    if move_type == :castling
      castle(start, target)
    elsif move_type == :en_passant
      pawn_to_remove = @en_passant_square.connected_en_passant_pawn
      pawn_to_remove.square.remove_piece
    end

    if @remove_en_passant_this_turn
     @en_passant_square.remove_en_passant_status if @en_passant_square
     @en_passant_square = nil
    else
      @remove_en_passant_this_turn = true
    end

  end

  def castle(start, target)
    # Castling left means target is [y,2], right [y,6] kings start on [y,4]
    castling_direction = target.sum > start.sum ? :right : :left
    # Rook must be placed on Kings right or left side depending on castling direction
    correct_side = castling_direction == :left ? :right : :left

    king = piece_at(target)
    kings_side = king.side(correct_side)
    rooks_location = king.rook_squares[castling_direction]

    move_piece(rooks_location, kings_side)
  end

  def move_piece(start, target)
    piece = square_at(start).remove_piece
    end_square = square_at(target)

    end_square.set_piece(piece)
    piece.square = end_square
    # King, Pawn and Rook require special attention.
    handle_special_pieces(piece) unless piece.nil?
  end

  def handle_special_pieces(piece)
    case piece
    when King, Rook
      piece.moved = true
    when Pawn
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
    square = square_at(pawn.square_behind)
    square.en_passant(pawn)
    @en_passant_square = square
    @remove_en_passant_this_turn = false
  end

  def calc_y_move_distance
    y_start = @move_buffer[:start_square].location[1]
    y_end = @move_buffer[:end_square].location[1]
    move_distance = (y_start - y_end).abs
  end

  def save_state
    @previous_state = Marshal.load(Marshal.dump(@state))
    @previous_en_passant_square = @en_passant_square
  end

  def note_move(start, target)
    @move_buffer[:start_square] = square_at(start)
    @move_buffer[:end_square] = square_at(target)
  end

  def undo_move
    @state = @previous_state
    @en_passant_square = find_en_passant_square
    @kings = get_kings
  end

  def piece_at(position)
    return nil if !RuleHelper.within_board?(position)
    square_at(position).piece
  end

  def square_at(position)
    return nil if !RuleHelper.within_board?(position)
    column, row = position
    @state[row][column]
  end

  def get_kings
    kings = { white: nil, black: nil }
    @state.each do |row|
      row.each do |square|
        piece = square.piece
        kings[piece.color] = piece if piece.instance_of?(King)
      end
    end
    kings
  end

  def find_en_passant_square
    state.each do |row|
      row.each do |square|
        return square if square.en_passant_square?
      end
    end
    nil
  end

  def each_square
    @state.each do |row|
      row.each do |square|
        yield(square)
      end
    end
  end

  def each_piece
    each_square do |sq|
      yield(sq.piece) if not sq.empty?
    end
    nil
  end

  # returns all black or white pieces
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
