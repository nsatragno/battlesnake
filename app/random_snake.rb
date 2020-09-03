require "./app/snake.rb"

class RandomSnake < Snake
  def choose_move!
    available_moves = [:left, :right, :up, :down]
    while not available_moves.empty?
      @next_move = available_moves.sample
      return @next_move unless will_probably_die?(next_for(@next_move))
      available_moves.delete(@next_move)
    end
    @next_move
  end

  def will_probably_die?(next_move)
    # Special case the tail
    if next_move == @body[@body.length - 1]
      return false
    end

    next_move[0] < 0 or next_move[0] >= @board.size[0] or
    next_move[1] < 0 or next_move[1] >= @board.size[1] or
    @board[next_move[0]][next_move[1]].is_a? Snake
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
    RandomSnake.new(board, @default_symbol, hash)
  end
end
