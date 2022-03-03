# frozen_string_literal: true

# lib/fen_parser.rb

require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/pawn'
require_relative 'square'

# Takes in FEN notation, spits out chess board with Pieces set-up
module FenParser
  ROW_SEPARATOR = '/'
  PIECE_LETTERS = { r: Rook, n: Knight, b: Bishop, q: Queen, k: King, p: Pawn }.freeze

  private_constant :ROW_SEPARATOR, :PIECE_LETTERS

  def make_board(fen)
    board = []
    fen.split(ROW_SEPARATOR).each_with_index do |fen_row, row_num|
      board << build_row(fen_row, row_num)
    end
    board
  end

  def build_row(fen_row, row_num)
    row = []
    fen_row.chars.each do |fen_char|
      if fen_char[/[1-8]/]
        fen_char.to_i.times { |num| row << build_square([row.size, row_num]) }
      else
        row << build_square_with_piece([row.size, row_num], fen_char)
      end
    end
    row
  end

  def build_square_with_piece(location, fen_char)
    square = build_square(location)
    piece = build_piece(fen_char, square)
    square.set_piece(piece)
    square
  end

  def piece_color(piece_char)
    piece_char.capitalize == piece_char ? :white : :black
  end

  def build_square(location)
    Square.new(location, self)
  end

  def build_piece(piece_char, square)
    color = piece_color(piece_char)
    PIECE_LETTERS[piece_char.downcase.to_sym].new(color, square)
  end
end
