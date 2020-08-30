# Game board.
class Board

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

  def [](x)
    @board[x]
  end

  def print!
    # Print the top edge
    print "X"
    @board.each_index do |i|
      print "X"
    end
    print "X\n"

    @board.each_index do |i|
      print "X"
      @board[i].each_index do |j|
        if @board[i][j] then
          print @board[i][j].symbol
        else
          print "*"
        end
      end
      print "X\n"
    end

    # Print the bottom edge
    print "X"
    @board.each_index do |i|
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
