#!/usr/bin/ruby

require "./app/battlesnake.rb"
require "./app/ai_snake.rb"

game = Battlesnake.new
ai_snake = AiSnake.new(game, game.board, "A")
game.add_food!
game.add_snake!(ai_snake)
game.add_snake!()
game.add_snake!()
game.add_snake!()

winner = game.run!(true)

if winner == ai_snake then
  puts "AI snake is the winner!"
else
  puts "Random snake won :("
end
