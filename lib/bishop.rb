# frozen_string_literal: true

require_relative 'piece'

class Bishop < Piece
  CUR_MOVES = ALL_MOVES.select do |move, _v|
    %i[diagonal_l_up diagonal_r_up diagonal_l_down diagonal_r_down].include? move
  end
end
