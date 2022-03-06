# frozen_string_literal: true

require_relative 'piece'
require 'pry-byebug'
class Pawn < Piece
  MOVES = %i[up down].freeze
  attr_writer :available_move_distance

  def initialize(color, square)
    super
    @available_move_distance = 2
    @direction = @color == :white ? :down : :up
  end

  def categorized_possible_moves
    all_moves = super.select { |move| move == @direction }
    all_moves[:attack_moves] = attack_moves
    all_moves
  end

  # Used to determine where the en_passant square is located
  def square_behind
    Coords.new(location).coords_to(@direction == :up ? :down : :up).plain_arr
  end

  private

  def cut_move_line(line)
    line.each_with_index do |position, distance|
      return line[0...distance] if distance == @available_move_distance
      return line[0...distance] unless board.square_at(position).empty?
    end
  end

  def attack_moves
    attack_moves = []
    squares = diagonal_squares_in_move_direction
    squares.each do |square|
      attack_moves << square.location if square.en_passant_square? &&
                                         square.connected_en_passant_pawn.color != @color
      next if square.empty?

      attack_moves << square.location if square.piece.color != @color
    end
    attack_moves
  end

  def diagonal_squares_in_move_direction
    coords = Coords.new(location)
    left_side = coords.coords_to(@direction).coords_to(:left).plain_arr
    right_side = coords.coords_to(@direction).coords_to(:right).plain_arr
    # if Pawn is at the start or end of the board it could access square outside of bounds
    # If it did it would get back nil and that can just be compacted
    [board.square_at(left_side), board.square_at(right_side)].compact
  end
end
