# frozen_string_literal: true
require_relative 'arbiter'
# lib/save_load.rb

module SaveLoad
  def save
    Dir.mkdir('saves') unless File.directory?('saves')
    file_name = Time.now.strftime("saves/save_%d-%m-%Y-%H-%M-%S")
    data = Marshal.dump({players: @players, board: @board, turn: @turn})
    File.write(file_name, data)
  end

  def load(file_name)
    if file_name[-1] == '!'
      display.clear_screen
      display.main_menu
    end
    data = Marshal.load(File.open(file_name).read)
    @players = data[:players]
    @board = data[:board]
    @turn = data[:turn]
    @cur_player = @players[@turn%2]
    play
  end
end
