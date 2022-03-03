# frozen_string_literal: true

require_relative 'piece'

class Rook < Piece
  MOVES = [:up, :down, :left, :right].freeze

  attr_accessor :moved

  def initialize(color, square)
    super
    @moved = false
  end

  def moved?
    @moved
  end

  def unmoved?
    not @moved
  end

  def side
    location[0] > 4 ? :right : :left
  end

  def line_towards_king
   towards_king = side == :left ? :right : :left
   categorized_possible_moves[towards_king]
  end

end
