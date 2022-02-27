#!/usr/bin/env ruby
# frozen_string_literal: true

# Asks player for input in algabraic notion ('a2') and returns it in numeric [7,1]
# In case of special input, e.g. q or h or s, lets the game handle that.
class Input
  LEGIT_COORDINATE_INPUT = /^[A-Za-z][0-9]$/.freeze
  SPECIAL_INPUT = /^[qhs]$/.freeze

  def initialize(game)
    @game = game
  end

  def choice
    to_numeric_coordinates(algrabeic_coordinates)
  end

  private

  def algrabeic_coordinates
    loop do
      input = gets.chomp
      special_input_sender(input)
      return input if input.match?(LEGIT_COORDINATE_INPUT)

      puts 'Sorry incorrect input. Try again.'
    end
  end

  def special_input_sender(input)
    if input.match?(SPECIAL_INPUT)
      @game.handle_special_input(input)
      return
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