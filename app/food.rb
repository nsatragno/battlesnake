# The pellets of food that spawn.
class Food
  @@spawn_chance = 0.15

  def initialize
  end

  def self.spawn_food(board)
    spaces = board.unoccupied_spaces
    return if spaces.empty?
    coordinates = spaces.sample
    board[coordinates[0]][coordinates[1]] = Food.new
  end

  def symbol
    "O"
  end
end
