#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cli/ui'

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

  COLUMN_LETTERS = '    A　B　C　D　E　F　G　H'

  RESET = "\e[0m"

  private_constant :PIECES, :BACKGROUND, :FONT, :COLUMN_LETTERS
  attr_reader :focused_piece

  def initialize
    @is_square_black = false
    @focused_piece = nil
  end

  def show_board(state)
    CLI::UI::StdoutRouter.enable
    CLI::UI::Frame.open('{{*}} {{bold:ruby-chess}} {{*}}', timing: false, color: :bold) do
      puts ''
      puts COLUMN_LETTERS

      state.each_with_index do |row, row_index|
        @is_square_black = !@is_square_black
        show_index(row_index)
        show_row(row)
        show_index(row_index)
        puts ''
      end

      puts COLUMN_LETTERS
      puts ''
    end
    puts ''
  end

  def show_turn(color)
    CLI::UI::Frame.open('Current turn for:  ', timing: false, color: :bold) do
      puts CLI::UI.fmt "{{bold:* #{color} *}}"
    end
    puts ''
  end

  def show_row(row)
    row.each do |square|
      @is_square_black = !@is_square_black # Changes color after every square shown
      set_background(@is_square_black)
      square.empty? ? show_empty(square) : show_piece(square.piece)
      print RESET
    end
  end

  def show_empty(square)
    if focused_piece.nil?
      print(" #{PIECES[:Space]} ")
    else
      show_possible_move_dot(square)
    end
  end

  def show_piece(piece)
    pieces_symbol = PIECES[piece.class]
    set_font_color(piece.color)
    print " #{pieces_symbol} "
  end

  def show_possible_move_dot(square)
    if focused_piece.moves.include? square.location
      set_font_color(focused_piece.color)
      print " #{POSSIBLE_MOVE_PIECES[focused_piece.class]} "
    else
      print " #{PIECES[:Space]} "
    end
  end

  def set_font_color(color)
    color == :white ? print(FONT[:Blue]) : (print FONT[:Red])
  end

  def set_background(is_black)
    is_black ? print(BACKGROUND[:Black]) : print(BACKGROUND[:White])
  end

  def show_index(row_index)
    print " #{(row_index - 8).abs} "
  end

  def clear_screen
    puts "\e[H\e[2J"
  end

  def focus_piece(piece)
    @focused_piece = piece
    self
  end

  def unfocus_piece
    @focused_piece = nil
    self
  end

end

