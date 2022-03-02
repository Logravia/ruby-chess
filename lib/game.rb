# lib/game.rb

require_relative 'board'
require_relative 'display'
require_relative 'arbiter'
require_relative 'input'
require_relative 'messages'
require_relative 'save_load'
require_relative 'human'
require_relative 'ai'
# TODO: Add draw condition
class Game

  attr_reader :board, :input, :display, :arbiter
  extend Msg
  include SaveLoad

  def initialize(board = Board.new)
    @board = board
    @display = Display.new(self)
    @arbiter = Arbiter.new(@board)
    @turn = 0
    @players = [Human.new(:white, self), Human.new(:black, self)]
    @cur_player = nil
  end

  def start
    display.main_menu
  end

  def play
    until arbiter.no_legal_moves_for?(@cur_player.color)
      make_turn(@cur_player.color)
      @turn += 1
      @cur_player = @players[@turn%2]
    end

    victory
  end

  def victory
    update_screen
    # BUG: Incorrect player declared victorious
    puts CLI::UI.fmt "{{bold:CHECK MATE! #{@cur_player.color} #{Msg::VICTORY}}}"
  end

  def choose_square
    loop do
      choice = @cur_player.choice
      return choice if !board.square_at(choice).empty? &&
                       !board.piece_at(choice).moves.empty?
      update_screen
      puts Msg::NO_LEGAL_MOVES
    end
  end

    def get_pieces_loc_of(color)
      loop do
        pieces_location = choose_square
        return pieces_location if board.piece_at(pieces_location).color == color
        update_screen
        puts CLI::UI.fmt "{{red:Can't move enemy's piece!}}"
      end
    end

  def make_turn(color)
      update_screen
      puts CLI::UI.fmt "{{info:Choose a piece.}}"
      pieces_loc = get_pieces_loc_of(color)

      display.focus_piece(board.piece_at(pieces_loc))
      update_screen

      puts CLI::UI.fmt '{{info:Choose destination or press c to cancel selection.}}'
      destination = choose_destination_for(pieces_loc)

      board.move(pieces_loc, destination)
      display.unfocus_piece
  end

  def choose_destination_for(chosen_start)
    loop do
      destination = @cur_player.choice
      return destination if arbiter.legal_move?(chosen_start, destination)
      update_screen
      puts CLI::UI.fmt "{{red:Sorry, that is an illegal move.}}"
    end
  end

  def cancel_choice
    display.unfocus_piece
    update_screen
    play
  end

  def handle_special_input(input)
    case input
    when 'q'
      display.clear_screen
      puts CLI::UI.fmt "{{green:Game has exited sucessfully!}}"
      exit
    when 's'
      save
      puts CLI::UI.fmt "{{green:Game has been saved!}}"
    when 'h'
      display.show_help
    when 'c'
      cancel_choice
    end
  end

  def ai_v_ai
    @players = [AI.new(:white, self), AI.new(:black, self)]
    @cur_player = @players.first
    play
  end

  def pvp
    @players = [Human.new(:white, self), Human.new(:black, self)]
    @cur_player = @players.first
    play
  end

  def update_screen
    display.clear_screen
    display.show_board
    display.show_turn(@players[@turn%2].color)
  end
end

Game.new.ai_v_ai
