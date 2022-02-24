#!/usr/bin/env ruby
# frozen_string_literal: true
require_relative 'board'


class Display
  SYMBOLS = {Bishop => :♝, King => :♚, Knight => :♞, Pawn => :♟, Queen => :♛, Rook => :♜, NilClass => '　'}
  BACKGROUND = { RED: "\e[41m", GREEN: "\e[42m", YELLOW: "\e[43m", BLUE: "\e[44m", PURPLE: "\e[45m", CYAN: "\e[46m", BLACK: "\e[40m",
                 WHITE: "\e[47m", RESET: "\e[0m" }.freeze
  FONT = {Black: "\e[30m", Red: "\e[31m", Green: "\e[32m", Yellow: "\e[33m", Blue: "\e[34m", Magenta: "\e[35m", Cyan: "\e[36m", White: "\e[37m"}


  # TODO: Seperate into more readable methods
  def show(state)
    puts COLUMN_LETTERS
    is_black = true
    state.each_with_index do |row, row_index|
      line_num(row_index)
      row.each do |square|
        set_background(is_black)
        square.empty? ? show_square(square) : show_piece(square.piece)
        print RESET
        is_black = !is_black
      end
      line_num(row_index)
      is_black = !is_black
      puts ''
    end
    puts COLUMN_LETTERS
  end

  def show_square(square)
    print " #{SYMBOLS[:Space]} "
  end

  def show_piece(piece)
    pieces_symbol = SYMBOLS[piece.class]
    piece.color == :white ? print(FONT[:Blue]) : (print FONT[:Red])
    print " #{pieces_symbol} "
  end

  def set_background(is_black)
    is_black ? print(BACKGROUND[:IS_BLACK]) : print(BACKGROUND[:WHITE])
  end

  def line_num(row_index)
    print " #{(row_index-8).abs} "
  end

end

b = Board.new
Display.new.show(b.state)
