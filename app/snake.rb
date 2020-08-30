class Snake
  STARTING_LENGTH = 3

  attr_reader :status

  def initialize(board, symbol)
    @board = board
    @default_symbol = symbol
    @status = :alive
    @health = 100

    starting_coordinates = board.unoccupied_spaces.sample
    @body = (0...STARTING_LENGTH).map do |i|
      starting_coordinates
    end
    board[starting_coordinates[0]][starting_coordinates[1]] = self
    @last_move = [:left, :right, :up, :down].sample
  end

  def symbol(x, y)
    if x == @body[0][0] and y == @body[0][1]
      case @last_move
      when :left
        "<"
      when :right
        ">"
      when :up
        "^"
      when :down
        "v"
      end
    else
      @default_symbol
    end
  end

  def choose_move()
    @last_move
  end

  def move!
    current = @body[0]
    @last_move = choose_move()
    case @last_move
    when :left
      next_move = [current[0] - 1, current[1]]
    when :right
      next_move = [current[0] + 1, current[1]]
    when :up
      next_move = [current[0], current[1] + 1]
    when :down
      next_move = [current[0], current[1] - 1]
    end

    if next_move[0] < 0 or next_move[0] >= @board.size[0] or
       next_move[1] < 0 or next_move[1] >= @board.size[1] then
      die!
      return
    end

    if @board[next_move[0]][next_move[1]] == self
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
      @body << @body[0].clone
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
    @board.remove! self
  end
end
