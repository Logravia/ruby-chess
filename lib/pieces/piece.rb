# frozen_string_literal: true

# lib/piece.rb
require_relative '../rule_helper'
require 'pry-byebug'

# Parent class of all chess pieces.
# As a it only knows where it can be moved to - possible_moves(from)
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
  MOVES = [:up, :down, :left, :right,
           :up_left, :up_right, :left_down, :right_down].freeze

  attr_reader :color, :square, :ALL_MOVES, :CUR_MOVES
  attr_writer :square

  def initialize(color, square)
    @color = color
    @square = square
  end

  def moves
    categorized_possible_moves.values.flatten(1)
  end

  def categorized_possible_moves
    categorized_possible_moves = categorized_possible_moves_in_vacuum
    categorized_possible_moves.each do |move_name, move_line|
      categorized_possible_moves[move_name] = cut_move_line(move_line)
    end
    categorized_possible_moves
  end

  def location
    square.location
  end

  private

  def board
    square.board
  end

  def categorized_possible_moves_in_vacuum
    categorized_moves = {}

    self.class::MOVES.each do |direction|
      moves = possible_moves_in(direction)
      categorized_moves[direction] = moves if not moves.empty?
    end

    categorized_moves
  end

      categorized_possible_moves.delete(move_name) if categorized_possible_moves[move_name].empty?
  def possible_moves_in(direction)
    start = Coords.new(location)

    return [] if not start.coords_to(direction).within_board?
    moves = [start.coords_to(direction)]

    while moves.last.coords_to(direction).within_board?
      moves << moves.last.coords_to(direction)
    end

    moves.map{ |coords| coords.plain_arr }
  end

  # Forbid move line going past pieces
  # Allow jumping on enemy pieces, but not friend pieces
  def cut_move_line(line)
    line.each_with_index do |position, distance|
      next if board.square_at(position).empty?

      piece_to_move_on = board.piece_at(position)
      return line[0...distance] if piece_to_move_on.color == @color
      return line[0..distance] if piece_to_move_on.color != @color
    end
  end

end
