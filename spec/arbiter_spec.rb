# frozen_string_literal: true

require_relative '../lib/arbiter'
require_relative '../lib/board'
require_relative '../lib/display'

describe Arbiter do
  describe '#legal_move?' do
    subject(:arbiter){ described_class.new(board) }

    context 'legal castling' do
      let(:fen_string) { 'r3k2r/8/8/8/8/8/8/8/' }
      let(:board) { Board.new(fen_string) }


      it 'is legal to castle right' do
        move_king = [4,0]
        to_right_castle_square = [6,0]
        moves_legality = arbiter.legal_move?(move_king, to_right_castle_square)
        expect(moves_legality).to be true
      end

      it 'is legal to castle left' do
        move_king = [4,0]
        to_left_castle_square = [2,0]
        moves_legality = arbiter.legal_move?(move_king, to_left_castle_square)
        expect(moves_legality).to be true
      end
    end

    context 'illegal castling' do

      context 'king checked in various positions' do
          context 'king checked on its square' do
            let(:fen_string) { 'r3k2r/5R2/8/8/8/8/8/8/' }
            let(:board) { Board.new(fen_string) }

            it 'returns false' do
              move_king = [4,0]
              to_right_castle_square = [6,0]
              moves_legality = arbiter.legal_move?(move_king, to_right_castle_square)
              expect(moves_legality).to be false
            end

          end
          context 'king checked after move' do
            let(:fen_string) { 'r3k2r/6R1/8/8/8/8/8/8/' }
            let(:board) { Board.new(fen_string) }

            it 'returns false' do
              move_king = [4,0]
              to_right_castle_square = [6,0]
              moves_legality = arbiter.legal_move?(move_king, to_right_castle_square)
              expect(moves_legality).to be false
            end

          end
          context 'king checked during the move' do
            let(:fen_string) { 'r3k2r/5R2/8/8/8/8/8/8/' }
            let(:board) { Board.new(fen_string) }

            it 'returns false' do
              move_king = [4,0]
              to_right_castle_square = [6,0]
              moves_legality = arbiter.legal_move?(move_king, to_right_castle_square)
              expect(moves_legality).to be false
            end

          end
      end

      context 'king blocked during the move' do
        context 'enemy piece blocking castling'  do
          let(:fen_string) { 'r1B1k2r/8/8/8/8/8/8/8/' }
          let(:board) { Board.new(fen_string) }

          it 'returns false' do
            move_king = [4,0]
            to_left_castle_square = [2,0]
            moves_legality = arbiter.legal_move?(move_king, to_left_castle_square)
            expect(moves_legality).to be false
          end

        end

        context 'friend piece blocking castling on the right'  do

          let(:fen_string) { 'r1n1k2r/8/8/8/8/8/8/8/' }
          let(:board) { Board.new(fen_string) }

          it 'returns false' do
            move_king = [4,0]
            to_left_castle_square = [2,0]
            moves_legality = arbiter.legal_move?(move_king, to_left_castle_square)
            expect(moves_legality).to be false
          end
        end

        context 'friend piece blocking castling on the left'  do

          let(:fen_string) { 'r3kn1r/8/8/8/8/8/8/8/' }
          let(:board) { Board.new(fen_string) }

          it 'returns false' do
            move_king = [4,0]
            to_right_castle_square = [6,0]
            moves_legality = arbiter.legal_move?(move_king, to_right_castle_square)
            expect(moves_legality).to be false
          end

        end

      end

      context 'king or rook have been moved' do
        context 'king has been moved'  do
          let(:fen_string) { 'r3k2r/8/8/8/8/8/8/8/' }
          let(:board) { Board.new(fen_string) }

          it 'returns false' do
            move_king = [4,0]
            to_left_castle_square = [2,0]

            king = board.piece_at(move_king)
            king.moved = true

            moves_legality = arbiter.legal_move?(move_king, to_left_castle_square)
            expect(moves_legality).to be false
          end
        end

        context 'rook has been moved'  do
          let(:fen_string) { 'r3k2r/8/8/8/8/8/8/8/' }
          let(:board) { Board.new(fen_string) }

          it 'returns false' do
            move_king = [4,0]
            to_left_castle_square = [2,0]
            left_rook = board.piece_at([0,0])
            left_rook.moved = true
            moves_legality = arbiter.legal_move?(move_king, to_left_castle_square)
            expect(moves_legality).to be false
          end
        end

      end
    end
  end
end
