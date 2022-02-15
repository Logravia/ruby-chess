# frozen_string_literal: true

# lib/piece.rb
require_relative 'rule_helper'

# Parent class of all chess pieces.
# As a basic piece it only knows where it can be moved to - possible_moves(from)
# By default this piece moves as a queen.
# Its child classes can easily move as rook, for example.
# Simply modify child classes CUR_MOVES constant to be composed of :up, :down, :left, :right key:value pairs.
# Implementation of child classes: Pawn, King and Knight require modifying possible_moves method.
# The aforementioned pieces have a different movement pattern unlike Queen, Rook, Bishop.
class Piece
  extend RuleHelper
  ALL_MOVES = { up: [0, 1], down: [0, -1], left: [-1, 0], right: [1, 0],
                diagonal_l_up: [-1, 1], diagonal_r_up: [1, 1],
                diagonal_l_down: [-1, -1], diagonal_r_down: [1, -1],
                jumps: [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [-1, 2], [1, -2], [-1, -2]] }.freeze

  CUR_MOVES = ALL_MOVES.reject { |move, _v| move == :jumps }

  attr_reader :color, :ALL_MOVES, :CUR_MOVES
  attr_accessor :location

  def initialize(color, location = nil)
    @color = color
    @location = location
  end

  def possible_moves
  def possible_moves_in_vacuum
    possible_moves = {}
    self.class::CUR_MOVES.each_pair do |move_name, change|
      possible_moves[move_name] = []
      adjacent_square = sum_coordinates(self.location, change)

      while RuleHelper.within_board?(adjacent_square)
        possible_moves[move_name] << adjacent_square
        adjacent_square = sum_coordinates(possible_moves[move_name].last, change)
      end

      possible_moves.delete(move_name) if possible_moves[move_name].empty?
    end

    possible_moves
  end

  def sum_coordinates(coord1, coord2)
    [coord1, coord2].transpose.map(&:sum)
  end
end
