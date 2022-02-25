# frozen_string_literal: true

# lib/rule_helper.rb

module RuleHelper

  X = {min: 0, max: 7}
  Y = {min: 0, max: 7}

  DEFAULT_BOARD = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'

  CASTLING_SQUARES = { white: { [2, 0] => :left, [6, 0] => :right },
                       black: { [2, 7] => :left, [6, 7] => :right } }.freeze

  def self.within_board?(coordinates)
    coordinates[0].between?(X[:min], X[:max]) and coordinates[1].between?(Y[:min], Y[:max])
  end

  def self.move_type(from, to, board)
  def self.move_type(from, destination, board)
    piece = board.piece_at(from)

    if piece.is_a?(King)
      if piece.unmoved? and piece.castling_squares.include? destination
        :castling
      end
    elsif piece.is_a?(Pawn) and board.square_at(destination).en_passant_square?
      :en_passant
    else
      :normal_move
    end

    # TODO: implement en_passant move type check
    # return :en_passant if piece.is_a?(Pawn) and
    :normal_move
  end
end
