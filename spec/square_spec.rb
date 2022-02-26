# frozen_string_literal: true

# square_spec.rb
require_relative '../lib/square'
require_relative '../lib/board'
require_relative '../lib/pieces/rook'

describe Square do
  describe '#under_attack?' do
    let(:location) { [0, 0] }
    let(:board) { instance_double(Board) }
    subject(:square_under_attack) { described_class.new(location, board) }

    let(:rook) { instance_double(Rook) }

    before do
      allow(board).to receive(:pieces_of_color).and_return([rook])
    end

    it 'returns true when rook can land on square' do
      rooks_moves = [[0, 0]]
      allow(rook).to receive(:moves).and_return(rooks_moves)
      expect(square_under_attack).to be_under_attack(:w)
    end

    it 'returns false when rook cannot land on square' do
      rooks_moves = [[1, 1]]
      allow(rook).to receive(:moves).and_return(rooks_moves)
      expect(square_under_attack).not_to be_under_attack(:w)
    end

    it 'returns false when rook cannot land on square' do
      rooks_moves = [[0, 1], [1, 0]]
      allow(rook).to receive(:moves).and_return(rooks_moves)
      expect(square_under_attack).not_to be_under_attack(:w)
    end
  end
end
