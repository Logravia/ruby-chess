# knight_spec.rb


require_relative '../lib/pieces/piece'
require_relative '../lib/board'
require_relative '../lib/square'

describe Knight do
  describe '#possible_moves' do

      let(:board){instance_double(Board)}
      let(:square){instance_double(Square)}
      subject(:knight) { described_class.new(:white, square)}

    context 'knight on a1 with empty board' do

      before do
        allow(square).to receive(:empty?).and_return(true)
        allow(square).to receive(:location).and_return([0,0],[1,2])
        allow(square).to receive(:board).and_return(board)
        allow(board).to receive(:square_at).and_return(square)
      end

      it 'returns correct moves' do
        correct_moves = [[2,1],[1,2]]
        knight_jumps = knight.possible_moves[:jumps]
        expect(knight_jumps).to eq(correct_moves)
      end

      it 'returns only one set of moves' do
        move_type_count = knight.possible_moves.keys.size
        expect(move_type_count).to eq(1)
      end

      it 'can make two jumps correctly' do
        correct_moves = [[0,0],[2,0],[3,1],[3,3],[2,4],[0,4]]
        knight.possible_moves
        knight_jumps = knight.possible_moves[:jumps]
        expect(knight_jumps).to match_array(correct_moves)
      end
    end

    context 'white knight on b2 surrounded by friends and enemies' do

      let(:knight_location){[1,1]}

      let(:enemy_piece){instance_double(Piece, color: :black)}
      let(:friend_piece){instance_double(Piece, color: :white)}

      before do
        allow(square).to receive(:empty?).and_return(false)
        allow(square).to receive(:location).and_return(knight_location)
        allow(square).to receive(:board).and_return(board)

        allow(board).to receive(:square_at).and_return(square)
        allow(board).to receive(:piece_at).and_return(enemy_piece, enemy_piece,
                                                      friend_piece, friend_piece)
      end

      it 'can attack enemies' do
        enemy_squares = [[3,2],[3,0]]
        jumps_on_enemy = knight.possible_moves[:jumps]
        expect(jumps_on_enemy).to match_array(enemy_squares)
      end

      it 'cannot attack friends' do
        friend_squares = [[2,3],[0,3]]
        knight_jumps = knight.possible_moves[:jumps]
        expect(knight_jumps).not_to include([2,3],[0,3])
      end

    end
  end
end
