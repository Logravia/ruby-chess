# frozen_string_literal: true

# lib/rule_helper.rb

module RuleHelper

  X = {min: 0, max: 7}
  Y = {min: 0, max: 7}

  DEFAULT_BOARD = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'

  CASTLING_SQUARES = { white: { [2, 0] => :left, [6, 0] => :right },
                       black: { [2, 7] => :left, [6, 7] => :right } }.freeze

  def self.within_board?(coordinates)
    coordinates[0].between?(X[:min], X[:max]) and coordinates[1].between?(Y[:min], Y[:max])
  end
  end
end
