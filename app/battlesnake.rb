# Implementation of battlesnake rules.

require "./app/board.rb"
require "./app/food.rb"

class Battlesnake
  def initialize
    @board = Board.new [10, 10]
    @snakes = [1, 2]
    @snakes.each_index do |i|
      Food.spawn_food(@board)
    end
  end

  def run!
    @board.print!
  end

end
