#!/usr/bin/ruby

require "sinatra"

require "./app/battlesnake.rb"

before do
  content_type :json
end

after do
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Methods"] = "GET, POST"
  response.headers["Access-Control-Allow-Headers"] = "content-type"
end

get "/" do
  {
   "apiversion": "1",
   "author": "eriNa_",
   "color": "#00cafe",
   "head": "silly",
   "tail": "bwc-present",
  }.to_json
end

options "/" do
end

post "/start" do
  {}.to_json
end

options "/start" do
end

post "/move" do
  payload = JSON.parse(request.body.read)
  game = Battlesnake.new payload

  our_snake_id = payload["you"]["id"]
  our_snake = game.snakes.find do |snake|
    snake.id == our_snake_id
  end
  unless our_snake
    puts "Error: could not find snake #{our_snake_id}}"
    return
  end

  our_snake.default_symbol = "N"

  next_move = our_snake.choose_move!.to_s

  puts "Receiving move"
  puts "Board status:"
  game.board.print!
  puts "Move: #{next_move}"

  {
    move: next_move
  }.to_json
end

options "/move" do
end

post "/end" do
  {}.to_json
end

options "/end" do
end
