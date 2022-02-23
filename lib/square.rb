# frozen_string_literal: true

class Square
  attr_reader :location, :board, :piece

  def initialize(location, board)
    @location = location
    @piece = piece
    @board = board

    @en_passant_square = false
    @connected_en_passant_pawn = nil
  end

  def under_attack?(by_color)
    return true if !@piece.nil? && (@piece.color == by_color)

    pieces = board.pieces_of_color(by_color)
    pieces.each do |piece|
      piece.possible_moves.each do |_move_name, move_group|
        return true if move_group.include? location
      end
    end
    false
  end

  def empty?
    @piece.nil?
  end

  def set_piece(piece_to_set)
    @piece = piece_to_set
  end

  def remove_piece
    removed_piece = piece
    @piece = nil
    removed_piece
  end

  def set_up_en_passant(pawn)
    @en_passant_square = true
    @connected_en_passant_pawn = pawn
  end

  def remove_en_passant_status
    @en_passant_square = false
    @connected_en_passant_pawn = nil
  end

  def en_passant_square?
    @en_passant_square
  end
end
