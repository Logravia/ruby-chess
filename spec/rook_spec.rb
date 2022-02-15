# rook_spec.rb
require_relative '../lib/rook.rb'
describe Rook do
  describe '#possible_moves' do
    context "rook on a1 square" do
      subject(:piece) { described_class.new(:white, [0,0]) }

      it 'returns correct moves upwards' do
        correct_moves_up = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
        moves_up = piece.possible_moves[:up]
        expect(moves_up).to eq(correct_moves_up)
      end

      it 'returns correct moves rightwards' do
        correct_rightwards_moves = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
        moves_rightwards = piece.possible_moves[:right]
        expect(moves_rightwards).to eq(correct_rightwards_moves)
      end

      it "doesn't return any superfluous moves" do
        all_moves = piece.possible_moves
        move_types = 2
        expect(all_moves.size).to eq(move_types)
      end

    end
  end
end
