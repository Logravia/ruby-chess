# frozen_string_literal: true

require_relative 'piece'

class Bishop < Piece
  MOVES = [:up_left, :up_right, :left_down, :right_down]
end
