# lib/game.rb

require_relative 'board'
require_relative 'display'
require_relative 'arbiter'
require_relative 'input'

class Game

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
