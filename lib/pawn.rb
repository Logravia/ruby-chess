# frozen_string_literal: true

require_relative 'piece'
require 'pry-byebug'

class Pawn < Piece
  CUR_MOVES = ALL_MOVES.select { |move| %i[up down].include? move }
  attr_accessor :moved

  def initialize(color,board,location=nil)
    super
    @moved = false
    @direction = @color == :white ? :up : :down
  end

  def possible_moves
    all_moves = super.select { |move| move == @direction }
    # Pawn can move one square up/down or two depending whether it had moved
    all_moves[@direction] = @moved ? all_moves[@direction][0] : all_moves[@direction][0..1]
    all_moves
  end
end
