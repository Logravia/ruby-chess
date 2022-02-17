# frozen_string_literal: true

require_relative 'rule_helper'
require_relative 'fen_parser'

# Board keeps track of pieces
# Moves them without taking into account legality of the move
class Board
  extend RuleHelper
  include FenParser

  attr_reader :state, :kings

  def initialize
    @state = make_board(RuleHelper::DEFAULT_BOARD)
    @kings = {white: @state[4][0], black: @state[4][7]}
    @temp_move_holder = {from: nil, to: nil, destroyed_piece: nil}
  end

  def move_piece(starting_point, destination)
    piece_to_move = piece_at(starting_point)
    square_at(starting_point).remove_piece
    end_square = square_at(destination)
    end_square.set_piece(piece_to_move)
  end

  # Used to help check whether a move is legal
  def temp_move(from, to)
    @temp_move_holder[:from] = from
    @temp_move_holder[:to] = to
    @temp_move_holder[:destroyed_piece] = piece_at(to)
    move_piece(from, to)
  end

  def reverse_temp_move
    # TODO: Ugly as hell, refactor
    move_piece(@temp_move_holder[:to], @temp_move_holder[:from])
    destroyed_piece_col, destroyed_piece_row = @temp_move_holder[:to]
    @state[destroyed_piece_row][destroyed_piece_col] = @temp_move_holder[:destroyed_piece]
    @temp_move_holder = {from: nil, to: nil, destroyed_piece: nil}
  end

  def piece_at(position)
    square_at(position).piece
  end

  def square_at(position)
    column, row = position
    @state[row][column]
  end

  def pieces_of_color(color)
    pieces = []
    state.each do |row|
      row.each do |square|
        next if square.empty?
        piece = square.piece
        pieces << piece if piece.color == color
      end
    end
    pieces
  end
end
