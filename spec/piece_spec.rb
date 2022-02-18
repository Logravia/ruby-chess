# frozen_string_literal: true

require_relative '../lib/piece'
require_relative '../lib/board'
require_relative '../lib/square'

describe Piece do
  describe '#possible_moves' do
    context 'square a1 with empty board' do
      let(:board){instance_double(Board)}
      let(:square){instance_double(Square)}
      subject(:piece) { described_class.new(:white, square) }

      before do
        allow(board).to receive(:piece_at).and_return(nil)
        allow(board).to receive(:square_at).and_return(square)
        allow(square).to receive(:location).and_return([0,0])
        allow(square).to receive(:board).and_return(board)
        allow(square).to receive(:empty?).and_return(true)
      end

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

      it 'returns correct moves diagonally right-upwards' do
        correct_moves = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
        received_moves = piece.possible_moves[:diagonal_r_up]
        expect(received_moves).to eq(correct_moves)
      end

      it "doesn't return any superfluous moves" do
        all_moves = piece.possible_moves
        move_types = 3
        expect(all_moves.size).to eq(move_types)
      end
    end

    context 'square h8 with empty board' do
      let(:board){instance_double(Board)}
      let(:square){instance_double(Square)}
      subject(:piece) { described_class.new(:white, square) }

      before do
        allow(board).to receive(:piece_at).and_return(nil)
        allow(board).to receive(:square_at).and_return(square)
        allow(square).to receive(:location).and_return([7,7])
        allow(square).to receive(:board).and_return(board)
        allow(square).to receive(:empty?).and_return(true)
      end

      it 'returns correct moves downwards' do
        correct_moves_down = [[7, 6], [7, 5], [7, 4], [7, 3], [7, 2], [7, 1], [7, 0]]
        moves_received = piece.possible_moves[:down]
        expect(moves_received).to eq(correct_moves_down)
      end

      it 'returns correct moves leftwards' do
        correct_moves_left = [[6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [1, 7], [0, 7]]
        moves_received = piece.possible_moves[:left]
        expect(moves_received).to eq(correct_moves_left)
      end

      it 'returns correct moves diagonally left and down' do
        correct_moves_diagonally = [[6, 6], [5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [0, 0]]
        moves_received = piece.possible_moves[:diagonal_l_down]
        expect(moves_received).to eq(correct_moves_diagonally)
      end

      it "doesn't return any superfluous moves" do
        all_moves = piece.possible_moves
        move_types = 3
        expect(all_moves.size).to eq(move_types)
      end
    end

    context 'piece on a1 with single enemy piece above' do
      let(:board){instance_double(Board, square_at: other_squares)}

      let(:my_location){[0,0]}
      let(:my_square){instance_double(Square, location: my_location, board: board)}
      subject(:my_piece) { described_class.new(:white, my_square) }

      let(:enemy_piece){instance_double(Piece, color: :black)}
      let(:other_squares){instance_double(Square)}


      it 'allows to jump on enemy piece right above it, but no further' do
        allow(other_squares).to receive(:empty?).and_return(false, true)
        allow(board).to receive(:piece_at).and_return(enemy_piece)

        correct_moves = [[0,1]]
        moves_up = my_piece.possible_moves[:up]
        expect(moves_up).to eq(correct_moves)
      end

      it 'allows to jump on enemy piece two squares away, but no further' do
        allow(other_squares).to receive(:empty?).and_return(true, false)
        allow(board).to receive(:piece_at).and_return(enemy_piece)

        correct_moves = [[0,1], [0,2]]
        moves_up = my_piece.possible_moves[:up]
        expect(moves_up).to eq(correct_moves)
      end

  end

    context 'piece on a1 with single friendly piece above' do
      let(:board){instance_double(Board, square_at: other_squares)}

      let(:my_location){[0,0]}
      let(:my_square){instance_double(Square, location: my_location, board: board)}
      subject(:my_piece) { described_class.new(:white, my_square) }

      let(:friendly_piece){instance_double(Piece, color: :white)}
      let(:other_squares){instance_double(Square)}


      it 'forbids a jump on friendly piece right above it' do
        allow(other_squares).to receive(:empty?).and_return(false, true)
        allow(board).to receive(:piece_at).and_return(friendly_piece)

        moves_up = my_piece.possible_moves[:up]
        expect(moves_up).to be_empty
      end

      it 'forbids jump on friendly piece two squares away' do
        allow(other_squares).to receive(:empty?).and_return(true, false)
        allow(board).to receive(:piece_at).and_return(friendly_piece)

        correct_moves = [[0,1]]
        moves_up = my_piece.possible_moves[:up]
        expect(moves_up).to eq(correct_moves)
      end

    end
  end
end
