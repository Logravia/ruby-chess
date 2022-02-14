# frozen_string_literal: true

require_relative 'piece'

# King moves just like a Queen or rather Piece except only one square
class King < Piece
  CUR_MOVES = ALL_MOVES.reject { |move, _v| move == :jumps }
  attr_accessor :moved

  def initialize(color)
    super
    @moved = false
  end

  def possible_moves(from)
    all_moves = super
    all_moves.each_pair do |move_name, squares|
      all_moves[move_name] = squares.first
    end
  end
end

pp King.new(:white).possible_moves([0, 0])
