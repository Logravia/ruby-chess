# frozen_string_literal: true

# board_spec.rb

require_relative '../lib/board'
require_relative '../lib/square'
require_relative '../lib/display'

# TODO: Add tests

describe Board do

  describe '#move' do

    context 'castling' do
      let(:fen_string) { 'R3K2R/8/8/8/8/8/8/8/' }
      subject(:board) { described_class.new(fen_string) }
      it 'moves piece from [0,0] to [1,0]' do
        from = [0, 0]
        to = [1, 0]
        piece_to_move = board.piece_at(from)
        board.move(from, to)
        expect(board.piece_at(to)).to be(piece_to_move)
      end

      it 'performs castling rightwards' do
        kings_location = [4,0]
        right_castle_square = [6,0]
        where_rook_should_be = [5,0]

        board.move(kings_location, right_castle_square)

        expect(board.piece_at(right_castle_square).class).to be(King)
        expect(board.piece_at(where_rook_should_be).class).to be(Rook)
      end

      it 'performs castling leftwards' do
        kings_location = [4,0]
        right_castle_square = [2,0]
        where_rook_should_be = [3,0]

        board.move(kings_location, right_castle_square)

        expect(board.piece_at(right_castle_square).class).to be(King)
        expect(board.piece_at(where_rook_should_be).class).to be(Rook)
      end
    end

  end
