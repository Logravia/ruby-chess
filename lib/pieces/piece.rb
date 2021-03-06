# frozen_string_literal: true

# lib/piece.rb
require_relative '../coords'

# Parent class of all chess pieces.
# As a it only knows where it can be moved to - possible_moves(from)
# By default this piece moves as a queen.
# Its child classes can easily move as rook, for example.
# Simply modify child classes CUR_MOVES constant to be composed of :up, :down, :left, :right key:value pairs.
# Implementation of child classes: Pawn, King and Knight require modifying possible_moves method.
# The aforementioned pieces have a different movement pattern unlike Queen, Rook, Bishop.
class Piece
  MOVES = %i[up down left right
             up_left up_right left_down right_down].freeze

  attr_accessor :square
  attr_reader :color, :ALL_MOVES, :CUR_MOVES

  def initialize(color, square)
    @color = color
    @square = square
  end

  def moves
    categorized_possible_moves.values.flatten(1).compact
  end

  def categorized_possible_moves
    moves = categorized_possible_moves_in_vacuum
    moves.each do |move_name, move_line|
      moves[move_name] = cut_move_line(move_line)
    end
    moves
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
      categorized_moves[direction] = moves unless moves.empty?
    end

    categorized_moves
  end

  def possible_moves_in(direction)
    start = Coords.new(location)

    return [] unless start.coords_to(direction).within_board?

    moves = [start.coords_to(direction)]

    moves << moves.last.coords_to(direction) while moves.last.coords_to(direction).within_board?

    moves.map(&:plain_arr)
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
