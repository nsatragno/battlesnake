require "securerandom"

class Snake
  STARTING_LENGTH = 3

  attr_reader :id
  attr_reader :status
  attr_accessor :default_symbol
  attr_accessor :next_move
  attr_accessor :health

  def initialize(board, symbol, json = nil)
    @board = board
    @default_symbol = symbol
    @status = :alive

    if json then
      @health = json["health"]
      @body = json["body"].map do |coordinates|
        [coordinates["x"], coordinates["y"]]
      end
      starting_coordinates = @body[0]
      @id = json["id"]
    else
      @health = 100
      starting_coordinates = board.unoccupied_spaces.sample
      @body = (0...STARTING_LENGTH).map do |i|
        starting_coordinates
      end
      @id = SecureRandom.uuid
    end

    @body.each do |part|
      board[part[0]][part[1]] = self
    end
    @next_move = [:left, :right, :up, :down].sample
  end

  def symbol(x, y)
    if x == head[0] and y == head[1]
      case @next_move
      when :left
        "<"
      when :right
        ">"
      when :up
        "^"
      when :down
        "v"
      when :none
        "x"
      end
    else
      @default_symbol
    end
  end

  def choose_move!
    # overloaded by children
    @next_move
  end

  def head
    @body[0]
  end

  def size
    @body.length
  end

  def next_for(direction)
    case direction
    when :left
      [head[0] - 1, head[1]]
    when :right
      [head[0] + 1, head[1]]
    when :up
      [head[0], head[1] + 1]
    when :down
      [head[0], head[1] - 1]
    when :none
      [head[0], head[1]]
    end
  end

  def maybe_kill?(next_move)
    if next_move[0] < 0 or next_move[0] >= @board.size[0] or
       next_move[1] < 0 or next_move[1] >= @board.size[1] or
       @board[next_move[0]][next_move[1]] == self
      # Special case the tail
      if next_move != @body[@body.length - 1]
        return true
      end
    end

    if @board[next_move[0]][next_move[1]].is_a? Snake and
       @board[next_move[0]][next_move[1]] != self
      other_snake = @board[next_move[0]][next_move[1]]

      if other_snake.head == [next_move[0], next_move[1]] then
        # We collided head on. The bigger snake wins.
        # If they're equal, they both die.
        if other_snake.size <= self.size then
          other_snake.die!
        end

        return size <= other_snake.size
      else
        # We collided with the tail of the other snake.
        return true
      end
    end
  end

  def move!
    next_move = next_for @next_move

    if maybe_kill?(next_move) then
      die!
      return
    end

    ate_food = @board[next_move[0]][next_move[1]].is_a? Food

    @body.each do |piece|
      @board[piece[0]][piece[1]] = nil
    end

    @body = @body.each_with_index.map do |piece, index|
      if index == 0 then
        next_move
      else
        @body[index - 1]
      end
    end

    @body.each do |piece|
      @board[piece[0]][piece[1]] = self
    end

    if ate_food then
      @health = 100
      @body << head.clone
    else
      @health -= 1
      if @health <= 0 then
        die!
        return
      end
    end
  end

  def die!
    @status = :dead
  end

  def clone(board)
    hash = {}
    hash["health"] = @health
    hash["body"] = @body.map do |piece|
      body_hash = {}
      body_hash["x"] = piece[0]
      body_hash["y"] = piece[1]
      body_hash
    end
    hash["id"] = @id
    Snake.new(board, @default_symbol, hash)
  end
end
