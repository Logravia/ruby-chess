# lib/game.rb

require_relative 'board'
require_relative 'display'
require_relative 'arbiter'
require_relative 'input'
require_relative 'messages'

class Game

  attr_reader :board, :input, :display, :arbiter
  extend Msg

  def initialize
    @board = Board.new
  def initialize(board = Board.new)
    @board = board
    @display = Display.new
    @arbiter = Arbiter.new(@board)
    @input = Input.new(self)
  def start
    input.main_menu
  end

  def play
    loop do
      update_screen
      make_turn
    end
  end

  def choose_piece
  def victory
    update_screen
    puts CLI::UI.fmt "{{bold:CHECK MATE! #{@players.first.capitalize} #{Msg::VICTORY}}}"
  end

    loop do
      choice = input.choice
      # TODO: deal with trying to move piece from empty square
      return choice if !board.square_at(choice).empty? &&
                       !board.piece_at(choice).moves.empty?
      update_screen
      puts Msg::NO_LEGAL_MOVES
    end
  end

  def make_turn
      piece = choose_piece
      display.focus_piece(board.piece_at(piece))
      update_screen

      destination = choose_destination_for(piece)

      board.move(piece, destination)
      display.unfocus_piece
  end

  def choose_destination_for(chosen_piece)
    loop do
      destination = input.choice
      return destination if arbiter.legal_move?(chosen_piece, destination)
      puts "Sorry, that is an illegal move."
    end
  end

  def cancel_choice
    display.unfocus_piece
    @players.rotate!
    update_screen
    play
  end

  def handle_special_input(input)
    case input
    when 'q'
      exit
    when 's'
      save_state
    when 'l'
      load_state
    when 'h'
      show_help
    when 'c'
      cancel_choice
    end
  end

  def update_screen
    display.clear_screen
    display.show_board(board.state)
  end
end

Game.new.play
