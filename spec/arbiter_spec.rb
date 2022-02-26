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

    context 'plain movement on empty board' do
            let(:fen_string) { 'rnbqkbnr/8/8/8/8/8/8/8/' }
            let(:board) { Board.new(fen_string) }

            it 'is legal to move rook up' do
              rook_square = [0,0]
              upper_square = [0,7]
              legality = arbiter.legal_move?(rook_square, upper_square)
              expect(legality).to be true
            end

            it 'is legal to move bishop diagonally' do
              bishop_square = [2,0]
              diagonal_end = [7,5]
              legality = arbiter.legal_move?(bishop_square, diagonal_end)
              expect(legality).to be true
            end

            it 'is legal to move knight ' do
              knight_square = [1,0]
              jump = [2,2]
              legality = arbiter.legal_move?(knight_square, jump)
              expect(legality).to be true
            end
    end

    context 'movement on friendly pieces' do
            let(:fen_string) { 'rnbqkbnr/pppppppp/8/8/8/8/8/8/' }
            let(:board) { Board.new(fen_string) }

            it 'is illegal to move rook on friendly pawn' do
              rook_square = [0,0]
              pawn_square = [0,1]
              legality = arbiter.legal_move?(rook_square, pawn_square)
              expect(legality).to be false
            end

            it 'is illegal to move bishop on friendly pawn' do
              bishop_square = [2,0]
              pawn_square = [3,1]
              legality = arbiter.legal_move?(bishop_square, pawn_square)
              expect(legality).to be false
            end

            it 'is illegal to jump on friendly pawn ' do
              knight_square = [1,0]
              pawn_square = [3,1]
              legality = arbiter.legal_move?(knight_square, pawn_square)
              expect(legality).to be false
            end
    end

  end
end
