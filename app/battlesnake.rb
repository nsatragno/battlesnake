# Implementation of battlesnake rules.

require "./app/board.rb"
require "./app/food.rb"
require "./app/snake.rb"

class Battlesnake
  def initialize
    @board = Board.new [10, 10]
    @snakes = [Snake.new(@board, "A"), Snake.new(@board, "B")]
    @snakes.each_index do |i|
      Food.spawn_food(@board)
    end
  end

  def run!
    while true
      system("clear")
      @board.print!
      @snakes.select! do |snake|
        snake.move!
        snake.status != :dead
      end
      sleep 0.5
    end
  end

end
