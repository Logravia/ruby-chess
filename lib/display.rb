#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'board'

# Prints out the state of the board
class Display
  PIECES = { Bishop => :♝, King => :♚, Knight => :♞, Pawn => :♟,
             Queen => :♛, Rook => :♜, Space: '⠀'}.freeze

  POSSIBLE_MOVE_PIECES = { Bishop => :♗, King => :♕, Knight => :♘, Pawn => :♗,
                           Queen => :♕, Rook => :♖ }.freeze

  BACKGROUND = { Red: "\e[41m", Green: "\e[42m", Yellow: "\e[43m", Blue: "\e[44m",
                 Purple: "\e[45m", Cyan: "\e[46m", Black: "\e[40m", White: "\e[47m" }.freeze

  FONT = { Black: "\e[30m", Red: "\e[31m", Green: "\e[32m", Yellow: "\e[33m", Blue: "\e[34m",
           Magenta: "\e[35m", Cyan: "\e[36m", White: "\e[37m" }.freeze

  COLUMN_LETTERS = '   A　B　C　D　E　F　G　H'

  RESET = "\e[0m"

  private_constant :PIECES, :BACKGROUND, :FONT, :COLUMN_LETTERS
  attr_accessor :focused_piece

  def initialize
    @is_square_black = false
    @focused_piece = nil
  end

  def show_board(state)
    puts COLUMN_LETTERS

    state.each_with_index do |row, row_index|
      @is_square_black = !@is_square_black
      show_index(row_index)
      show_row(row, row_index)
      show_index(row_index)
      puts ''
    end

    puts COLUMN_LETTERS
  end

  def show_row(row, _row_index)
    row.each do |square|
      @is_square_black = !@is_square_black
      set_background(@is_square_black)
      square.empty? ? show_square(square, focused_piece) : show_piece(square.piece)
      print RESET
    end
  end

  def show_square(square, focused_piece)
    # TODO: Line too long
    focused_piece.nil? ? print(" #{PIECES[:Space]} ") : show_possible_move_dot(focused_piece, square)
  end

  def show_possible_move_dot(piece, square)
    # TODO: piece.possible_moves returns array likes this: [[[loc1],[loc2]]]
    # Fix that
    if piece.categorized_possible_moves.values.flatten(1).include? square.location
      set_font_color(piece.color)
      print " #{POSSIBLE_MOVE_PIECES[piece.class]} "
    else
      print " #{PIECES[:Space]} "
    end
  end

  def set_font_color(color)
    color == :white ? print(FONT[:Blue]) : (print FONT[:Red])
  end

  def show_piece(piece)
    pieces_symbol = PIECES[piece.class]
    set_font_color(piece.color)
    print " #{pieces_symbol} "
  end

  def set_background(is_black)
    is_black ? print(BACKGROUND[:Black]) : print(BACKGROUND[:White])
  end

  def show_index(row_index)
    print " #{(row_index - 8).abs} "
  end
end

b = Board.new
d = Display.new
p = b.piece_at([1, 0])
d.focused_piece = p
d.show_board(b.state)
