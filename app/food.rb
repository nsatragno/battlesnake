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

  def self.maybe_spawn_food(board)
    has_food = board.any? do |column|
      column.any? do |element|
        element.is_a? Food
      end
    end

    if not has_food or Battlesnake.random.rand < @@spawn_chance then
      self.spawn_food(board)
    end
  end

  def symbol
    "O"
  end
end
