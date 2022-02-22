# frozen_string_literal: true

require_relative 'piece'

class Rook < Piece

  CUR_MOVES = ALL_MOVES.select do |move, _v|
    %i[up down left right].include? move
  end

  attr_accessor :moved

  def initialize(color, square)
    super
    @moved = false
  end
end
