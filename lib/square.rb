class Square
  attr_reader :location, :board, :piece

  def initialize(location, board)
    @location = location
    @piece = piece
    @board = board
  end

  def under_attack?(by_color)
    pieces = board.pieces_of_color(by_color)
    pieces.each do |piece|
      piece.possible_moves.each do |_move_name, move_group|
        return true if move_group.include? self.location
      end
    end
    false
  end

  def set_piece(piece_to_set)
   @piece = piece_to_set
  end

  private
  attr_writer :piece

end
