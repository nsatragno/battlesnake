# Implementation of battlesnake rules.

require "./app/board.rb"
require "./app/food.rb"
require "./app/random_snake.rb"
require "./app/snake.rb"

class Battlesnake
  @@random = Random.new

  attr_accessor :board
  attr_accessor :snakes

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
    @snakes = []
  end

  def add_snake!(snake = RandomSnake.new(@board, "R"))
    @snakes << snake
  end

  def add_food!
    @snakes.each_index do |i|
      Food.spawn_food(@board)
    end
  end

  def run_step!(display = false, spawn_food = true)
    if display then
      @board.print!
    end
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
    Food.maybe_spawn_food(@board) if spawn_food
    #sleep 0.1 if display
  end

  def run!(display = false)
    while @snakes.size > 1
      run_step!(display)
    end

    return @snakes[0] if @snakes.size > 0
  end

  def clone
    other = Battlesnake.new
    other.board = @board.clone
    @snakes.each do |snake|
      other.add_snake!(snake.clone(board))
    end
    other
  end
end
