# Implementation of battlesnake rules.

require "./app/board.rb"
require "./app/food.rb"
require "./app/random_snake.rb"
require "./app/snake.rb"

class Battlesnake
  @@random = Random.new

  attr_reader :board
  attr_reader :snakes

  def self.random
    @@random
  end

  def initialize(json = nil)
    if json then
      @board = Board.new [json["board"]["width"], json["board"]["height"]]
      @snakes = json["board"]["snakes"].map do |snake_json|
        RandomSnake.new @board, "E", snake_json
      end
      json["board"]["food"].each do |food_json|
        @board[food_json["x"]][food_json["y"]] = Food.new
      end
      return
    end

    # default initialization
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
