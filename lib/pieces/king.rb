# frozen_string_literal: true

require_relative 'piece'

class King < Piece
  def initialize(color, square)
    super
    @moved = false
    @enemy_color = @color == :white ? :black : :white
  end

  def possible_moves
    all_moves = super
    all_moves.each_pair do |move_name, squares|
      # King moves just like a Queen except only one square in all directions
      all_moves[move_name] = squares.first
    end
  end

  def checked?
    square.under_attack?(@enemy_color)
  end

end
