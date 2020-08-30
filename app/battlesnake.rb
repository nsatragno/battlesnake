# Implementation of battlesnake rules.

require "./app/board.rb"
require "./app/food.rb"
require "./app/random_snake.rb"
require "./app/snake.rb"

class Battlesnake
  @@random = Random.new
  def self.random
    @@random
  end

  def initialize
    @board = Board.new [12, 8]
    @snakes = [Snake.new(@board, "A"), RandomSnake.new(@board, "R")]
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
      Food.maybe_spawn_food(@board)
      sleep 0.5
    end
  end

end
