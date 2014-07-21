require_remote "rb/ball.rb"
require_remote "rb/paddle.rb"
require_remote "rb/global_constants.rb"
require_remote "rb/game.rb"
require_remote "rb/input.rb"

# Game objects
ball = Ball.new

right_paddle = Paddle.new(GameConstants::RIGHT_PADDLE_X_POS,
GameConstants::RIGHT_PADDLE_Y_POS,
GameConstants::RIGHT_HORIZONTAL_SCORE_POS,
GameConstants::RIGHT_VERTICAL_SCORE_POS,
ball
)

left_paddle = Paddle.new(GameConstants::LEFT_PADDLE_X_POS, GameConstants::LEFT_PADDLE_Y_POS,
GameConstants::LEFT_HORIZONTAL_SCORE_POS,
GameConstants::LEFT_VERTICAL_SCORE_POS,
ball
)

# New instances of Game and Input.
game_methods = Game.new(ball, right_paddle, left_paddle)
event = Input.new(ball, right_paddle, left_paddle)

# Interval that will make the game loop.
game_interval = $$.setInterval(Proc.new { game_methods.tick }, GameConstants::MILLESECONDS / GameConstants::FPS)

# Keyboard events will run methods from the Input class.
$$.onkeydown = Proc.new do |input_event|
  event.key_down(input_event)
end
$$.onkeyup = Proc.new do |input_event|
  event.key_up(input_event)
end