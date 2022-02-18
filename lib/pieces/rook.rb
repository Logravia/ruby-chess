# frozen_string_literal: true

require_relative 'piece'

class Rook < Piece
  CUR_MOVES = ALL_MOVES.select do |move, _v|
    %i[up down left right].include? move
  end
end
