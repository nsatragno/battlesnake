# Game board.
class Board

  attr_accessor :board

  # |size|: array with [rows, columns]
  def initialize(size)
    @board = Array.new(size[0])
    @board.each_index do |i|
      @board[i] = Array.new(size[1])
    end
  end

  def each_index(&block)
    @board.each_index &block
  end

  def clone
    other = Board.new(size)
    other.board.each_index do |i|
      other.board.each_index do |j|
        if @board[i][j].is_a? Food then
          other.board[i][j] = Food.new
        end
      end
    end
    other
  end

  def remove!(removed_element)
    @board.each do |row|
      row.map! do |element|
        if element == removed_element
          nil
        else
          element
        end
      end
    end
  end

  def [](x)
    @board[x]
  end

  def any?(&block)
    @board.any? &block
  end

  def size
    [@board.length, @board[0].length]
  end

  def flatten
    @board.flatten
  end

  def print!
    # Print the top edge
    print "X"
    @board.each do |i|
      print "X"
    end
    print "X\n"

    (size[1] - 1).downto(0).each do |j|
      print "X"
      0.upto(size[0] - 1).each do |i|
        if @board[i][j] then
          print @board[i][j].symbol(i, j)
        else
          print "*"
        end
      end
      print "X\n"
    end

    # Print the bottom edge
    print "X"
    @board.each do |i|
      print "X"
    end
    print "X\n"
  end

  def unoccupied_spaces
    (0...@board.length).map do |i|
      (0...@board[i].length).map do |j|
        [i, j]
      end
    end.flatten(1).select do |coordinates|
      not @board[coordinates[0]][coordinates[1]]
    end
  end
end
