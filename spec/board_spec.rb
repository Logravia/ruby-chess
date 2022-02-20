# board_spec.rb

require_relative '../lib/board'
require_relative '../lib/square'

describe Board do
  let(:start_square){instance_double(Square)}
  let(:empty_square){instance_double(Square)}
  let(:end_square){instance_double(Square)}

  let(:state){[[start_square, empty_square, end_square]]}
  subject(:board){described_class.new(state)}

  describe '#move_piece' do
    context 'small simulated board' do
      it 'moves piece from [0,0] to [1,0]' do
        from = [0,0]
        to = [2,0]
        piece_to_move = 'X'

        expect(end_square).to receive(:piece).and_return(piece_to_move)
        expect(start_square).to receive(:remove_piece).and_return(piece_to_move)
        expect(end_square).to receive(:set_piece).with(piece_to_move)

        board.move_piece(from,to)
      end
    end
  end

  describe '#save_move' do
    it 'saves state of the board before the move' do
      from = [0,0]
      to = [2,0]
      piece_to_destroy = 'Y'
      correct_save_state = {start_square: start_square,
                            end_square: end_square,
                            destroyed_piece: piece_to_destroy}

      allow(end_square).to receive(:piece).and_return(piece_to_destroy)

      board.save_move(from,to)
      expect(board.move_buffer).to eq(correct_save_state)
    end
  end

  describe '#undo_move' do
    it 'undos the move' do
      from = [0,0]
      to = [2,0]
      piece_to_restore = 'Y'
      moved_piece = 'X'

      allow(end_square).to receive(:piece).and_return(piece_to_restore)
      board.save_move(from,to)

      expect(end_square).to receive(:piece).and_return(moved_piece)
      expect(end_square).to receive(:set_piece).with(piece_to_restore)
      expect(start_square).to receive(:set_piece).with(moved_piece)
      board.undo_move
    end
  end
end
