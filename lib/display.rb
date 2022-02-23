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
    puts '   A　B　C　D　E　F　G　H'
    black = true
    state.each_with_index do |row, index|
      print "#{(index-8).abs} "
      row.each do |square|
        print FONT[:Blue]
        background = black ? print(BACKGROUND[:BLACK]) : print(BACKGROUND[:WHITE])
        print " #{SYMBOLS[square.piece.class]} "
        print BACKGROUND[:RESET]
        black = !black
      end
      print " #{(index-8).abs}"
      black = !black
      puts ''
    end
  puts '   A　B　C　D　E　F　G　H'
  end
end

b = Board.new
Display.new.show(b.state)
