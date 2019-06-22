require "./class/player"
require "./class/dealer"
require "./class/bank"
require "./class/cards"
require "./class/ui_game"
require "./class/engine_game"

# игра black jack
game = EngineGame.new
game.start_game