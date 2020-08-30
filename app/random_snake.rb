require "./app/snake.rb"

class RandomSnake < Snake
  def choose_move!
    available_moves = [:left, :right, :up, :down]
    while not available_moves.empty?
      @next_move = available_moves.sample
      return unless will_probably_die?(next_for(@next_move))
      available_moves.delete(@next_move)
    end
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
end
