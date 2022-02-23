# frozen_string_literal: true

require_relative 'piece'
require 'pry-byebug'

class Pawn < Piece
  CUR_MOVES = ALL_MOVES.select { |move| %i[up down].include? move }
  attr_writer :available_move_distance

  def initialize(color, square)
    super
    @available_move_distance = 2
    @direction = @color == :white ? :up : :down
  end

  def possible_moves
    all_moves = super.select { |move| move == @direction }
    all_moves[:attack_moves] = attack_moves
    all_moves
  end

  # Used to determine where the en_passant square is located
  def square_behind
    if @direction == :up
      sum_coordinates(location, ALL_MOVES[:down])
    else
      sum_coordinates(location, ALL_MOVES[:up])
    end
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
      attack_moves << square.location if square.en_passant_square?
      next if square.empty?

      attack_moves << square.location if square.piece.color != @color
    end
    attack_moves
  end

  def diagonal_squares_in_move_direction
    if @direction == :up
      left_side = sum_coordinates(location, ALL_MOVES[:diagonal_l_up])
      right_side = sum_coordinates(location, ALL_MOVES[:diagonal_r_up])
    else
      left_side = sum_coordinates(location, ALL_MOVES[:diagonal_l_down])
      right_side = sum_coordinates(location, ALL_MOVES[:diagonal_r_down])
    end
    [board.square_at(left_side), board.square_at(right_side)]
  end
end
