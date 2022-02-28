# frozen_string_literal: true

# Allows to easily get location of an upper or lower or diagonal square location from currect location
class Coords
  DIRECTIONS = { up: [0, 1], down: [0, -1], left: [-1, 0], right: [1, 0],
                 up_left: [-1, 1], up_right: [1, 1],
                 left_down: [-1, -1], right_down: [1, -1] }.freeze

  X = { min: 0, max: 7 }.freeze
  Y = { min: 0, max: 7 }.freeze

  attr_reader :coords

  def initialize(coords)
    @coords = coords
  end

  def x_pos
    coords[0]
  end

  def y_pos
    coords[1]
  end

  def coords_to(direction)
    Coords.new(sum_coordinates(DIRECTIONS[direction]))
  end

  def sum_coordinates(movement_to)
    [coords, movement_to].transpose.map(&:sum)
  end

  def within_board?
    coords[0].between?(X[:min], X[:max]) &&
      coords[1].between?(Y[:min], Y[:max])
  end

  def plain_arr
    coords
  end
end
