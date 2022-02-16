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

  def move_piece(from, to)
    from_col, from_row = from
    to_col, to_row = to

    piece = piece_at(from)

    state[to_row][to_col] = piece
    state[from_row][from_col] = nil
    piece.location = to
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

  def give_pieces_location
    state.each_with_index do |row, row_num|
      row.each_with_index do |piece, piece_num|
        next if piece.nil?
        piece.location = [piece_num, row_num]
      end
    end
  end

  def piece_at(position)
    column, row = position
    @state[row][column]
  end
end
