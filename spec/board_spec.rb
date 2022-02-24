# frozen_string_literal: true

# board_spec.rb

require_relative '../lib/board'
require_relative '../lib/square'

# TODO: Add tests

describe Board do
  let(:fen_string) { 'R6r/8/8/8/8/8/8/8/' }
  subject(:board) { described_class.new(fen_string) }

  describe '#move_piece' do
    it 'moves piece from [0,0] to [1,0]' do
      from = [0, 0]
      to = [1, 0]
      piece_to_move = board.piece_at(from)
      board.move_piece(from, to)
      expect(board.piece_at(to)).to be(piece_to_move)
    end

    it 'moves piece to a square when there is another pieces there' do
    end
  end

  describe '#note_move' do
    it 'saves state of the board before the move' do
    end
  end

  describe '#undo_move' do
    it 'undos the move' do
    end
  end
end
