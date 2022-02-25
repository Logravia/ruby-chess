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
    categorized_possible_moves = {}
    self.class::CUR_MOVES.each_pair do |move_name, change|
      categorized_possible_moves[move_name] = []
      adjacent_square = sum_coordinates(location, change)

      while RuleHelper.within_board?(adjacent_square)
        categorized_possible_moves[move_name] << adjacent_square
        adjacent_square = sum_coordinates(categorized_possible_moves[move_name].last, change)
      end

      categorized_possible_moves.delete(move_name) if categorized_possible_moves[move_name].empty?
    end

    categorized_possible_moves
  end

  # Reduces movement to squares that do not go past a standing piece
  # If enemy piece allows to go on top of it
  # If friendly pieces allows to just stop next to it
  def cut_move_line(line)
    line.each_with_index do |position, distance|
      next if board.square_at(position).empty?

      piece_to_move_on = board.piece_at(position)
      return line[0...distance] if piece_to_move_on.color == @color
      return line[0..distance] if piece_to_move_on.color != @color
    end
  end

  def sum_coordinates(coord1, coord2)
    [coord1, coord2].transpose.map(&:sum)
  end
end
