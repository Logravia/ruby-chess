# frozen_string_literal: true

# lib/rule_helper.rb

module RuleHelper
  X_MIN = 0
  X_MAX = 7
  Y_MIN = 0
  Y_MAX = 7

  HEIGHT = 8
  WIDTH = 8

  DEFAULT_BOARD = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

  attr_reader :X_MIN, :X_MAX, :Y_MIN, :Y_MAX, :WIDTH, :HEIGHT

  def self.within_board?(coordinates)
    coordinates[0].between?(X_MIN, X_MAX) and coordinates[1].between?(Y_MIN, Y_MAX)
  end
end
