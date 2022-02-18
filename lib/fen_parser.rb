# lib/fen_parser.rb

require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/pawn'
require_relative 'square'

#Takes in FEN notation, spits out chess board with Pieces set-up
module FenParser
  ROW_SEPARATOR = '/'
  PIECE_LETTERS = {r: Rook, n: Knight, b: Bishop, q: Queen, k: King, p: Pawn}

  private_constant :ROW_SEPARATOR, :PIECE_LETTERS

  def make_board(fen)
    board = []
    fen.split(ROW_SEPARATOR).each_with_index do |fen_row, row_num|
      board << build_row(fen_row, row_num)
    end
    board
  end

  def build_row(fen_row, row_num)
    board_row = []
    fen_row.chars.each_with_index do |fen_char, col_num|
      location = [col_num, row_num]
      if fen_char[/[1-8]/]
        fen_char.to_i.times { |num| board_row << build_square([num, row_num])}
      else
      board_row << build_square_with_piece(location, fen_char)
      end
    end
    board_row
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

  ## TODO: modularize and make work
  def make_fen(board)
    fen_string = ""
    board.each do |row|
      nil_count = 0
      row.each do |piece|
        if piece.nil?
         nil_count += 1
        else
          fen_string << nil_count.to_s if nil_count > 0
          nil_count = 0
          fen_string << PIECE_LETTERS.key(piece.class).to_s
        end
      end
      fen_string << ROW_SEPARATOR
    end
    fen_string.chomp(ROW_SEPARATOR)
  end
end
