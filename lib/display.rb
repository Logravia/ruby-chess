#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'board'

class Display
  SYMBOLS = { Bishop => :♝, King => :♚, Knight => :♞, Pawn => :♟, Queen => :♛, Rook => :♜, Space: '　', Dot: '♙' }.freeze
  BACKGROUND = { Red: "\e[41m", Green: "\e[42m", Yellow: "\e[43m", Blue: "\e[44m", Purple: "\e[45m", Cyan: "\e[46m", Black: "\e[40m",
                 White: "\e[47m" }.freeze
  FONT = { Black: "\e[30m", Red: "\e[31m", Green: "\e[32m", Yellow: "\e[33m", Blue: "\e[34m", Magenta: "\e[35m",
           Cyan: "\e[36m", White: "\e[37m" }.freeze
  COLUMN_LETTERS = '   A　B　C　D　E　F　G　H'
  RESET = "\e[0m"

  private_constant :SYMBOLS, :BACKGROUND, :FONT, :COLUMN_LETTERS

  # TODO: Seperate into more readable methods
  def show(state, piece_to_move = nil)
    puts COLUMN_LETTERS
    is_black = true
    state.each_with_index do |row, row_index|
      line_num(row_index)
      row.each do |square|
        set_background(is_black)
        square.empty? ? show_square(square, piece_to_move) : show_piece(square.piece)
        print RESET
        is_black = !is_black
      end
      line_num(row_index)
      is_black = !is_black
      puts ''
    end
    puts COLUMN_LETTERS
  end

  def show_square(square, piece_to_move)
  def show_row(row, _row_index)
    row.each do |square|
      @is_square_black = !@is_square_black
      set_background(@is_square_black)
      square.empty? ? show_square(square, focused_piece) : show_piece(square.piece)
      print RESET
    end
  end

    # TODO: Line too long
    piece_to_move.nil? ? print(" #{SYMBOLS[:Space]} ") : show_possible_move_dot(piece_to_move, square)
  end

  def show_possible_move_dot(piece, square)
    # TODO: piece.possible_moves returns array likes this: [[[loc1],[loc2]]]
    # Fix that
    if piece.possible_moves.values.flatten(1).include? square.location
      set_font_color(piece.color)
      # TODO: Print transparent piece version instead
      print " #{SYMBOLS[:Dot]} "
    else
      print " #{SYMBOLS[:Space]} "
    end
  end

  def set_font_color(color)
    color == :white ? print(FONT[:Blue]) : (print FONT[:Red])
  end

  def show_piece(piece)
    pieces_symbol = SYMBOLS[piece.class]
    set_font_color(piece.color)
    print " #{pieces_symbol} "
  end

  def set_background(is_black)
    is_black ? print(BACKGROUND[:Black]) : print(BACKGROUND[:White])
  end

  def line_num(row_index)
    print " #{(row_index - 8).abs} "
  end
end

b = Board.new
Display.new.show(b.state, b.piece_at([1,0]))
