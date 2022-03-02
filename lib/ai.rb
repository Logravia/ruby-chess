# lib/ai.rb
require_relative 'player'

class AI

  def initialize
    @piece_choice = true
    @piece_location = nil
  end

  def choice
   if piece_choice
     piece_choice = false
     do loop
       piece = random_piece
       # TODO: Possible error site
       location = piece.location
       return location if game.arbiter.piece_has_legal_moves?(piece)
     end
   else
     piece_choice = true
     destination = random_square
     return destination if game.arbiter.legal_move?(piece_location, destination)
   end
  end

  private
  attr_reader :game, :piece_choice, :piece_location

  def random_square
    [rand(0..7), rand(0..7)]
  end

  def random_piece
    pieces = game.board.pieces_of_color(color)
    pieces[rand(0..piece.size)]
  end

end
