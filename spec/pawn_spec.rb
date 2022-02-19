# pawn_spec.rb

require_relative '../lib/pieces/piece'
require_relative '../lib/board'
require_relative '../lib/square'


describe Pawn do
  describe '#possible_moves' do
    context 'white pawn on a2 with empty board' do
      let(:board){instance_double(Board)}
      let(:square){instance_double(Square)}
      subject(:pawn) { described_class.new(:white, square) }

      before do
        allow(board).to receive(:piece_at).and_return(nil)
        allow(board).to receive(:square_at).and_return(square)
        allow(square).to receive(:location).and_return([0,1])
        allow(square).to receive(:board).and_return(board)
        allow(square).to receive(:empty?).and_return(true)
      end

      it 'can move two squares upwards' do
        pawn_moves = pawn.possible_moves[:up]
        correct_moves = [[0,2],[0,3]]
        expect(pawn_moves).to eq(correct_moves)
      end

      it 'can move only one piece upwards after being moved' do
        pawn.moved = true
        pawn_moves = pawn.possible_moves[:up]
        correct_moves = [[0,2]]
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
      let(:board){instance_double(Board)}
      let(:square){instance_double(Square)}
      subject(:pawn) { described_class.new(:black, square) }

      before do
        allow(board).to receive(:piece_at).and_return(nil)
        allow(board).to receive(:square_at).and_return(square)
        allow(square).to receive(:location).and_return([0,6])
        allow(square).to receive(:board).and_return(board)
        allow(square).to receive(:empty?).and_return(true)
      end

      it 'can move two squares downwards' do
        pawn_moves = pawn.possible_moves[:down]
        correct_moves = [[0,5],[0,4]]
        expect(pawn_moves).to eq(correct_moves)
      end

      it 'can move only one piece downwards after being moved' do
        pawn.moved = true
        pawn_moves = pawn.possible_moves[:down]
        correct_moves = [[0,5]]
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

    context 'white pawn on a2 with a piece above it' do

      let(:board){instance_double(Board, square_at: other_squares)}

      let(:my_location){[0,1]}
      let(:enemy_location){[0,2]}

      let(:my_square){instance_double(Square, location: my_location, board: board)}
      subject(:my_piece) { described_class.new(:white, my_square) }

      let(:enemy_piece){instance_double(Piece, color: :black, location: enemy_location)}
      let(:other_squares){instance_double(Square)}


      it 'it does not allow to jump on enemy piece right above it' do
        allow(other_squares).to receive(:empty?).and_return(false, true)
        allow(board).to receive(:piece_at).and_return(enemy_piece)

        correct_moves = []
        moves_up = my_piece.possible_moves[:up]
        expect(moves_up).to eq(correct_moves)
      end

      it 'it does not allow to jump on enemy piece two squares away from it' do
        allow(other_squares).to receive(:empty?).and_return(true, false)
        allow(board).to receive(:piece_at).and_return(enemy_piece)

        correct_moves = [[0,2]]
        moves_up = my_piece.possible_moves[:up]
        expect(moves_up).to eq(correct_moves)
      end

    end

  end
end
