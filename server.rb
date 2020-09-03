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
  game = Battlesnake.new JSON.parse(request.body.read)

  puts "Receiving move"
  puts "Board status:"
  game.board.print!

  {
    move: "up",
  }.to_json
end

options "/move" do
end

post "/end" do
  {}.to_json
end

options "/end" do
end
