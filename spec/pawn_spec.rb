# frozen_string_literal: true

# pawn_spec.rb

require_relative '../lib/pieces/piece'
require_relative '../lib/board'
require_relative '../lib/square'

describe Pawn do
  describe '#possible_moves' do
    let(:a2) { [0, 1] }
    let(:a7) { [0, 6] }

    context 'white pawn on a2 with empty board' do
      let(:fen_string) { '8/P7/8/8/8/8/8/8/' }
      let(:board) { Board.new(fen_string) }
      subject(:pawn) { board.piece_at(a2) }

      it 'can move two squares upwards' do
        pawn_moves = pawn.possible_moves[:up]
        correct_moves = [[0, 2], [0, 3]]
        expect(pawn_moves).to eq(correct_moves)
      end

      it 'can move only one piece upwards after being moved' do
        pawn.available_move_distance = 1
        pawn_moves = pawn.possible_moves[:up]
        correct_moves = [[0, 2]]
        expect(pawn_moves).to eq(correct_moves)
      end

      it 'has empty attack moves' do
        attack_moves = pawn.possible_moves[:attack_moves]
        expect(attack_moves).to be_empty
      end

      it 'cannot moves downwards' do
        expect(pawn.possible_moves[:down]).to be_nil
      end

      it 'only has two possible move types' do
        move_type_count = pawn.possible_moves.keys.size
        expect(move_type_count).to be(2)
      end
    end

    context 'black pawn on a7 with empty board' do
      let(:fen_string) { '8/8/8/8/8/8/p7/8/' }
      let(:board) { Board.new(fen_string) }
      subject(:pawn) { board.piece_at(a7) }

      it 'can move two squares downwards' do
        pawn_moves = pawn.possible_moves[:down]
        correct_moves = [[0, 5], [0, 4]]
        expect(pawn_moves).to eq(correct_moves)
      end

      it 'can move only one piece downwards after being moved' do
        pawn.available_move_distance = 1
        pawn_moves = pawn.possible_moves[:down]
        correct_moves = [[0, 5]]
        expect(pawn_moves).to eq(correct_moves)
      end

      it 'has empty attack moves' do
        attack_moves = pawn.possible_moves[:attack_moves]
        expect(attack_moves).to be_empty
      end

      it 'cannot moves upwards' do
        expect(pawn.possible_moves[:up]).to be_nil
      end

      it 'only has two possible move types' do
        move_type_count = pawn.possible_moves.keys.size
        expect(move_type_count).to be(2)
      end
    end

    context 'white pawn on a2 with piece above it' do
      let(:fen_string) { '8/P7/p7/8/8/8/8/8/' }
      let(:board) { Board.new(fen_string) }
      subject(:pawn) { board.piece_at(a2) }

      it 'it does not allow to jump on enemy piece right above it' do
        moves_up = pawn.possible_moves[:up]
        expect(moves_up).to be_empty
      end
    end

    context 'white pawn on a2 with a piece two squares away' do
      let(:fen_string) { '8/P7/8/p7/8/8/8/8/' }
      let(:board) { Board.new(fen_string) }
      subject(:pawn) { board.piece_at(a2) }

      it 'it does not allow to jump on enemy piece two squares away from it' do
        correct_moves = [[0, 2]]
        moves_up = pawn.possible_moves[:up]
        expect(moves_up).to eq(correct_moves)
      end
    end

    context 'black pawn on a7 with piece below it' do
      let(:fen_string) { '8/8/8/8/8/P7/p7/8/' }
      let(:board) { Board.new(fen_string) }
      subject(:pawn) { board.piece_at(a7) }

      it 'it does not allow to jump on enemy piece right below it' do
        correct_moves = []
        moves_up = pawn.possible_moves[:down]
        expect(moves_up).to eq(correct_moves)
      end
    end

    context 'black pawn on a7 with piece below it' do
      let(:fen_string) { '8/8/8/8/P7/8/p7/8/' }
      let(:board) { Board.new(fen_string) }
      subject(:pawn) { board.piece_at(a7) }

      it 'it does not allow to jump on enemy piece two squares below it' do
        correct_moves = [[0, 5]]
        moves_up = pawn.possible_moves[:down]
        expect(moves_up).to eq(correct_moves)
      end
    end

    context 'white pawn on a2 with piece above and to the right of it' do
      let(:fen_string) { '8/P7/Pp6/8/8/8/8/8/' }
      let(:board) { Board.new(fen_string) }
      subject(:pawn) { board.piece_at(a2) }

      it 'include enemy pieces location in its attack_moves' do
        attack_moves = pawn.possible_moves[:attack_moves]
        enemy_location = [1, 2]
        expect(attack_moves).to include(enemy_location)
      end

      it 'it does not include friendly piece in its attack_moves' do
        attack_moves = pawn.possible_moves[:attack_moves]
        friend_location = [0, 2]
        expect(attack_moves).not_to include(friend_location)
      end
    end
  end
end
