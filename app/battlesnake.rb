# Implementation of battlesnake rules.

require "./app/board.rb"

class Battlesnake
  def initialize
    @board = Board.new [10, 10]
  end

  def run!
    print!
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
          print "P"
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
end
