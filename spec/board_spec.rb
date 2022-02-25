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

    context 'en passant' do

      let(:fen_string) { 'p7/8/1P6/8/8/8/8/8/' }
      subject(:board) { described_class.new(fen_string) }

      it 'sets en_passant square after pawns double move' do
        black_pawn = [0,0]
        two_squares_down = [0,2]
        en_passant_square = [0,1]
        board.move(black_pawn, two_squares_down)
        expect(board.square_at(en_passant_square)).to be_en_passant_square
      end

      it 'does not not set en_passant square after single pawn move' do
        black_pawn = [0,0]
        one_square_down = [0,1]
        en_passant_square = [0,0]
        board.move(black_pawn, one_square_down)
        expect(board.square_at(en_passant_square)).not_to be_en_passant_square
      end

      it 'removes en_passant square if it has not been taken advantage of' do
        black_pawn = [0,0]
        white_pawn = [1,2]
        two_squares_down = [0,2]
        one_square_up = [1,1]
        en_passant_location = [0,1]

        board.move(black_pawn, two_squares_down)
        board.move(white_pawn, one_square_up)
        board.move([0,2], [0,3])
        en_passant_status = board.square_at(en_passant_location).en_passant_square?
        expect(en_passant_status).to be false
      end

      it 'removes piece after pawn moves on en_passant square' do
        black_pawn = [0,0]
        white_pawn = [1,2]
        two_squares_down = [0,2]
        en_passant_location = [0,1]

        board.move(black_pawn, two_squares_down)
        board.move(white_pawn, en_passant_location)
        expect(board.square_at(two_squares_down)).to be_empty

      end

      context 'Bishop attempting to do en_passant' do
        let(:fen_string) { 'p7/8/1B6/8/8/8/8/8/' }
        subject(:board) { described_class.new(fen_string) }

        it 'does not remove piece when a piece other than enemy pawn moves on it' do
        black_pawn = [0,0]
        white_bishop = [1,2]
        two_squares_down = [0,2]
        en_passant_location = [0,1]

        board.move(black_pawn, two_squares_down)
        board.move(white_bishop, en_passant_location)
        expect(board.square_at(two_squares_down)).not_to be_empty
        Display.new.show_board(board.state)

        end
      end

    end
  end
end
