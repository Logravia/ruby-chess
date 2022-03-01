# lib/game.rb

require_relative 'board'
require_relative 'display'
require_relative 'arbiter'
require_relative 'input'

class Game

  attr_reader :board, :input, :display, :arbiter

  def initialize
    @board = Board.new
    @display = Display.new
    @arbiter = Arbiter.new(@board)
    @input = Input.new(self)
  end

  def play
    loop do
      update_screen
      make_turn
    end
  end

  def choose_piece
    loop do
      choice = input.choice
      # TODO: deal with trying to move piece from empty square
      return choice if !board.square_at(choice).empty? &&
                       !board.piece_at(choice).moves.empty?
      update_screen
      puts 'No legal moves are available from that square.'
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
    end
  end

  def update_screen
    display.clear_screen
    display.show_board(board.state)
  end
end

Game.new.play
