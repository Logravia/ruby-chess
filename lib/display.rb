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

  def initialize(game)
    @is_square_black = false
    @focused_piece = nil
    @game = game
  end

  def show_board
    CLI::UI::StdoutRouter.enable
    CLI::UI::Frame.open('{{*}} {{bold:ruby-chess}} {{*}}', timing: false, color: :bold) do
      puts ''
      puts COLUMN_LETTERS

      @game.board.state.each_with_index do |row, row_index|
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

  def show_controls
    CLI::UI::Frame.open('Controls: ', timing: false, color: :bold) do
      puts CLI::UI.fmt "{{bold: q: quit, r: reset, h: help, m: menu, s: save, c: cancel}"
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
    if @focused_piece.nil?
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
    if @focused_piece.moves.include? square.location
      set_font_color(@focused_piece.color)
      print " #{POSSIBLE_MOVE_PIECES[@focused_piece.class]} "
    else
      print " #{PIECES[:Space]} "
    end
  end

  def main_menu
    puts Msg::TITLE

    CLI::UI::Prompt.ask('What would you like to do?') do |handler|
      handler.option('Play against a computer')  { |selection| @game.p_v_ai }
      handler.option('Play against a player')     { |selection| @game.pvp }
      handler.option('Watch AI vs AI')     { |selection| @game.ai_v_ai }
      handler.option('Load game')   { |selection|  list_file_options}
      handler.option('Check rules')   { |selection| show_rules }
      handler.option('Quit') { |_s| exit }
    end
  end

  def list_file_options
    choice = CLI::UI::Prompt.ask('Which file would you like to load?', options: savefile_list)
    @game.load(choice)
  end

  def savefile_list
    file_list = Dir.glob(File.join('saves', "*"))
    file_list.empty? ? ["No files to load! Press enter to continue!"] : file_list.unshift("CANCEL!")
  end

  def show_rules
    clear_screen
    puts CLI::UI.fmt "{{info:These are the rules. Press enter when you are done.}}"
    gets
    clear_screen
    main_menu
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

