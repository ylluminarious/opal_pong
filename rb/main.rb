require 'opal'
require 'opal-browser'
require 'opal-jquery'
require 'native'
require 'math'

require_relative "ball"
require_relative "paddle"
require_relative "global_constants"
require_relative "game"
require_relative "input"

# Game objects
ball = Ball.new

right_paddle = Paddle.new(GlobalConstants::RIGHT_PADDLE_X_POS,
GlobalConstants::RIGHT_PADDLE_Y_POS,
GlobalConstants::RIGHT_HORIZONTAL_SCORE_POS,
GlobalConstants::RIGHT_VERTICAL_SCORE_POS,
ball
)

left_paddle = Paddle.new(GlobalConstants::LEFT_PADDLE_X_POS, GlobalConstants::LEFT_PADDLE_Y_POS,
GlobalConstants::LEFT_HORIZONTAL_SCORE_POS,
GlobalConstants::LEFT_VERTICAL_SCORE_POS,
ball
)

# New instances of Game and Input.
game_methods = Game.new(ball, right_paddle, left_paddle)
event = Input.new(ball, right_paddle, left_paddle)

# Interval that will make the game loop.
game_interval = $$.setInterval(Proc.new { game_methods.tick }, GlobalConstants::MILLESECONDS / GlobalConstants::FPS)

# Keyboard events will run methods from the Input class.
$$.onkeydown = Proc.new do |input_event|
    event.key_down(input_event)
end
$$.onkeyup = Proc.new do |input_event|
    event.key_up(input_event)
end