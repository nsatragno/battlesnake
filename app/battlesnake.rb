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
    @board = Board.new [20, 20]
    @snakes = [
      RandomSnake.new(@board, "A"), RandomSnake.new(@board, "B"),
      RandomSnake.new(@board, "C"), RandomSnake.new(@board, "D"),
      RandomSnake.new(@board, "E"), RandomSnake.new(@board, "F"),
    ]
    @snakes.each_index do |i|
      Food.spawn_food(@board)
    end
  end

  def run!
    while true
      system("clear")
      @board.print!
      @snakes.each do |snake|
        snake.choose_move!
      end

      @snakes.select! do |snake|
        snake.move!

        if snake.status == :dead
          @board.remove! snake
          false
        else
          true
        end
      end
      Food.maybe_spawn_food(@board)
      sleep 0.1
    end
  end

end
