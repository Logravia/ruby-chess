# lib/ai.rb
require_relative 'player'

class AI < Player

  def initialize(color, game)
    super
    @piece_choice = true
    @piece_location = nil
  end

  def choice
    if @piece_choice
      @piece_choice = false
      loop do
        piece = random_piece
        @piece_location = piece.location.dup
        return @piece_location if @game.arbiter.piece_has_legal_moves?(piece)
      end
    else
      loop do
        # TODO: I could just sample random move from the piece
        @piece_choice = true
        destination = random_square
        return destination if @game.arbiter.legal_move?(@piece_location, destination)
      end
    end
  end

  def random_square
    [rand(0..7), rand(0..7)]
  end

  def random_piece
    @game.board.pieces_of_color(color).sample
  end
end
