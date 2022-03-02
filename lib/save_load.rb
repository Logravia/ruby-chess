# frozen_string_literal: true

# lib/save_load.rb

module SaveLoad
  def save
    file_name = Time.now.strftime("saves/save_%d-%m-%Y-%H-%M-%S")
    data = Marshal.dump({players: @players, board: @board, turn: @turn})
    File.write(file_name, data)
  end

  def self.load; end
end
