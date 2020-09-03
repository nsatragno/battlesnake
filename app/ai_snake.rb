require "./app/snake.rb"

class AiSnake < Snake
  MAX_DEPTH = 6

  def initialize(game, *params)
    @game = game
    super(*params)
  end

  def choose_move!
    available_moves = [:up, :down, :left, :right]

    tree_head = {
      children: {},
      score: score(@game),
      game: @game.clone,
    }

    add_level(tree_head, 0)
    @next_move = find_best_path(tree_head)[:move]
  end

  def add_level(node, current_depth)
    return if current_depth >= MAX_DEPTH
    
    available_moves = [:up, :down, :left, :right]
    available_moves.each do |move|
      next_game = node[:game].clone
      our_copy = next_game.snakes.find do |snake|
        snake.next_move = :none
        snake.id == @id
      end
      our_copy.next_move = move
      next_game.run_step!(false, false)

      next_score = score(next_game)
      if next_score > 0 then
        node[:children][move] = {
          children: {},
          score: score(next_game, current_depth),
          game: next_game,
        }
        add_level(node[:children][move], current_depth + 1)
      end
    end
  end

  def score(game, depth = 0)
    our_snake = game.snakes.find do |snake|
      snake.id == @id
    end
    return 0 unless our_snake
    
    calc_score = 200
    if our_snake.health < 20 then
      calc_score -= (20 - our_snake.health) * 5
    end

    other_snakes = game.snakes.select do |snake|
      snake != self
    end

    other_snakes.each do |snake|
      if (snake.head[0] - our_snake.head[0]).abs <= depth and
          (snake.head[1] - our_snake.head[1]).abs <= depth then
        calc_score -= MAX_DEPTH - depth
      end
    end

    calc_score
  end

  def find_best_path(node, original = nil)
    if node[:children].size == 0 then
      return {
        move: original,
        score: node[:score],
      }
    end

    scores = node[:children].map do |move, child|
      this_move = original
      if original.nil? then
        this_move = move
      end

      find_best_path(child, this_move)
    end

    best_score = scores[0]
    scores.each do |score|
      if score[:score] > best_score[:score]
        best_score = score
      end
    end

    best_score
  end
end
