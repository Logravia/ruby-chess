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

end
