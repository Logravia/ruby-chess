# frozen_string_literal: true

require_relative '../lib/arbiter'
require_relative '../lib/board'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/king'

describe Arbiter do
  describe '#legal_move?' do
    context 'king checked and unchecked' do
      it "returns false when king tries to move into rook's square" do
      end

      it 'returns false when king checked by knight and a piece tries to move' do
      end

      it 'returns true when move prevents check' do
      end

      it 'returns false when move allows check' do
      end
    end
  end
end
