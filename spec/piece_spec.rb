# frozen_string_literal: true

# piece_spec.rb
require_relative '../lib/piece'

describe Piece do
  describe '#possible_moves' do
    context 'square a1' do
      subject(:piece) { described_class.new(:white) }
      let(:placement) { [0, 0] }

      it 'returns correct moves upwards' do
        correct_moves_up = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
        moves_up = piece.possible_moves(placement)[:up]
        expect(moves_up).to eq(correct_moves_up)
      end
      it 'returns correct moves rightwards' do
        correct_rightwards_moves = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
        moves_rightwards = piece.possible_moves(placement)[:right]
        expect(moves_rightwards).to eq(correct_rightwards_moves)
      end

      it 'returns correct moves diagonally right-upwards' do
        correct_moves = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
        received_moves = piece.possible_moves(placement)[:diagonal_r_up]
        expect(received_moves).to eq(correct_moves)
      end

      it "doesn't return any superfluous moves" do
        all_moves = piece.possible_moves(placement)
        move_types = 3
        expect(all_moves.size).to eq(move_types)
      end
    end

    context 'square h8' do
      subject(:piece) { described_class.new(:white) }
      let(:placement) { [7, 7] }

      it 'returns correct moves downwards' do
        correct_moves_down = [[7, 6], [7, 5], [7, 4], [7, 3], [7, 2], [7, 1], [7, 0]]
        moves_received = piece.possible_moves(placement)[:down]
        expect(moves_received).to eq(correct_moves_down)
      end

      it 'returns correct moves leftwards' do
        correct_moves_left = [[6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [1, 7], [0, 7]]
        moves_received = piece.possible_moves(placement)[:left]
        expect(moves_received).to eq(correct_moves_left)
      end

      it 'returns correct moves diagonally left and down' do
        correct_moves_diagonally = [[6, 6], [5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [0, 0]]
        moves_received = piece.possible_moves(placement)[:diagonal_l_down]
        expect(moves_received).to eq(correct_moves_diagonally)
      end

      it "doesn't return any superfluous moves" do
        all_moves = piece.possible_moves(placement)
        move_types = 3
        expect(all_moves.size).to eq(move_types)
      end
    end
  end
end
