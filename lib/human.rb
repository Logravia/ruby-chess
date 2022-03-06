# frozen_string_literal: true

# lib/human.rb

require_relative 'input'
require_relative 'player'

class Human < Player
  attr_reader :color

  def initialize(color, game)
    @color = color
    @game = game
    @input = Input.new(game)
  end

  def choice
    @input.choice
  end

  def promotion
    @input.promotion_menu
  end
end
