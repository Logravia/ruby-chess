# lib/fen_parser.rb

require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'

#Takes in FEN notation, spits out chess board with Pieces
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
      if fen_char[/[1-8]/]
        fen_char.to_i.times {board_row << nil}
        next
      end
      board_row << build_piece(fen_char, [row_num, col_num])
    end
    board_row
  end

  def piece_color(piece_char)
    piece_char.capitalize == piece_char ? :white : :black
  end

  def build_piece(piece_char, location)
    color = piece_color(piece_char)
    PIECE_LETTERS[piece_char.downcase.to_sym].new(color, self, location)
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