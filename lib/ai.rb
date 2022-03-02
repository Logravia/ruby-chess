# lib/ai.rb
require_relative 'player'

class AI

  def initialize
    @piece_choice = true
    @piece_location = nil
  end

  def choice
    sleep(0.2)
    if @piece_choice
      @piece_choice = false
      loop do
        piece = random_piece
        @piece_location = piece.location.dup
        return @piece_location if @game.arbiter.piece_has_legal_moves?(piece)
      end
    else
      loop do
        @piece_choice = true
        destination = random_square
        return destination if @game.arbiter.legal_move?(@piece_location, destination)
      end
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
