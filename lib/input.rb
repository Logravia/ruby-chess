#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cli/ui'

# Asks player for input in algabraic notion ('a2') and returns it in numeric [7,1]
# In case of special input, e.g. q or h or s, lets the game handle that.
class Input
  LEGIT_COORDINATE_INPUT = /^[A-Za-z][0-9]$/.freeze
  SPECIAL_INPUT = /^[qslhc]$/.freeze
  PROMPT = "\n> "

  def initialize(game)
    @game = game
  end

  def choice
    to_numeric_coordinates(algrabeic_coordinates)
  end

  def main_menu
    puts Msg::TITLE

    CLI::UI::Prompt.ask('What would you like to do?') do |handler|
      handler.option('Play against a computer')  { |selection| selection }
      handler.option('Play against a player')     { |selection| @game.play }
      handler.option('Watch AI vs AI')     { |selection| @game.play }
      handler.option('Load game')   { |selection|  list_file_options}
      handler.option('Check rules')   { |selection| show_rules }
      handler.option('Quit') { |_s| exit }
    end
end
  end

  def list_file_options
    choice = CLI::UI::Prompt.ask('Which file would you like to load?', options: savefile_list)
    @game.load(choice)
  end

  def savefile_list
    file_list = Dir.glob(File.join('saves', "*"))
    file_list.empty? ? ["No files to load! Press enter to continue!"] : file_list.unshift("CANCEL!")
  end

  def show_rules
    puts "These are the rules. Press enter to return"
    gets
    main_menu
  end

  private

  def algrabeic_coordinates
    loop do
      print CLI::UI.fmt '{{bold:~> }}'
      input = gets.chomp
      was_special_input = special_input_sender(input)
      return input if input.match?(LEGIT_COORDINATE_INPUT)

      puts 'Sorry incorrect input. Try again.' unless was_special_input
    end
  end

  def special_input_sender(input)
    if input.match?(SPECIAL_INPUT)
      @game.handle_special_input(input)
      return true
    end
  end

  def to_numeric_coordinates(algrabeic_coords)
    letter, str_number = algrabeic_coords.split('')
    x_coord = letter.upcase.codepoints.pop % 65
    # y_coord must be flipped as a1 must mean [0,7]
    # The white pieces are at the bottom of the array, not the start.
    y_coord = (str_number.to_i - 8).abs
    [x_coord, y_coord]
  end

end
