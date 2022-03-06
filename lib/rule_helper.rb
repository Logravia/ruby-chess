# frozen_string_literal: true

# lib/rule_helper.rb

module RuleHelper
  X = { min: 0, max: 7 }.freeze
  Y = { min: 0, max: 7 }.freeze

  DEFAULT_BOARD = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'

  def self.within_board?(coordinates)
    coordinates[0].between?(X[:min], X[:max]) and coordinates[1].between?(Y[:min], Y[:max])
  end

  def self.move_type(from, destination, board)
    piece = board.piece_at(from)

    if piece.is_a?(King)
      :castling if piece.unmoved? && piece.castling_squares.values.include?(destination)
    elsif piece.is_a?(Pawn) && board.square_at(destination).en_passant_square?
      :en_passant
    else
      :normal_move
    end
  end
end
