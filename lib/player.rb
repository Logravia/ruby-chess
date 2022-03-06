# frozen_string_literal: true

class Player
  attr_reader :color

  def initialize(color, game)
    @color = color
    @game = game
  end

  def choice; end

  def promotion; end
end
