# lib/game.rb

require_relative 'board'
require_relative 'display'
require_relative 'arbiter'
require_relative 'input'

class Game

  def choose_piece
    loop do
      choice = input.choice
      # TODO: deal with trying to move piece from empty square
      return choice if board.piece_at(choice).moves.size > 0
      puts 'No legal moves are available from that square.'
    end
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
    end
  end

  def update_screen
    display.clear_screen
    display.show_board(board.state)
  end

  def focus_piece(piece)
    display.focused_piece = board.piece_at(piece)
  end

  def unfocus_piece
    display.focused_piece = nil
  end

end
