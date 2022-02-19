# frozen_string_literal: true

require_relative 'piece'
require 'pry-byebug'

class Pawn < Piece
  CUR_MOVES = ALL_MOVES.select { |move| %i[up down].include? move }
  attr_writer :moved

  def initialize(color, square)
    super
    @moved = false
    @direction = @color == :white ? :up : :down
  end

  def possible_moves
    all_moves = super.select { |move| move == @direction }
    # Pawn can move one square up/down or two depending whether it had moved
    all_moves[@direction] = @moved ? [all_moves[@direction][0]] : all_moves[@direction][0..1]
    #TODO: forbid pawn from jumping on enemy piece or friendly piece for that matter.
    all_moves[:attack_moves] = attack_moves
    all_moves
  end

  def attack_moves
    attack_moves = []
    neighboring_pieces = diagonal_neighbors_in_move_direction.compact
    neighboring_pieces.each do |piece|
      attack_moves << piece.location if piece.color != @color
    end
    attack_moves
  end

  def diagonal_neighbors_in_move_direction
    if @direction == :up
      left_side = sum_coordinates(location, ALL_MOVES[:diagonal_l_up])
      right_side = sum_coordinates(location, ALL_MOVES[:diagonal_r_up])
    else
      left_side = sum_coordinates(location, ALL_MOVES[:diagonal_l_down])
      right_side = sum_coordinates(location, ALL_MOVES[:diagonal_r_down])
    end
    [board.piece_at(left_side), board.piece_at(right_side)]
  end

end
