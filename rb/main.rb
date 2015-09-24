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

include GlobalConstants

# Game objects
ball = Ball.new

right_paddle = Paddle.new(RIGHT_PADDLE_X_POS,
RIGHT_PADDLE_Y_POS,
RIGHT_HORIZONTAL_SCORE_POS,
RIGHT_VERTICAL_SCORE_POS,
ball
)

left_paddle = Paddle.new(LEFT_PADDLE_X_POS, LEFT_PADDLE_Y_POS,
LEFT_HORIZONTAL_SCORE_POS,
LEFT_VERTICAL_SCORE_POS,
ball
)

# New instances of Game and Input.
game_methods = Game.new(ball, right_paddle, left_paddle)
event = Input.new(ball, right_paddle, left_paddle)

# Interval that will make the game loop.
game_interval = $$.setInterval(Proc.new { game_methods.tick }, MILLESECONDS / FPS)

# Keyboard events will run methods from the Input class.
$$.onkeydown = Proc.new do |input_event|
    event.key_down(input_event)
end
$$.onkeyup = Proc.new do |input_event|
    event.key_up(input_event)
end