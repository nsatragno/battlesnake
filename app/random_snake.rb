require "./app/snake.rb"

class RandomSnake < Snake
  def choose_move()
    [:left, :right, :up, :down].sample
  end
end
