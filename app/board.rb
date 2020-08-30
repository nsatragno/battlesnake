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
end
