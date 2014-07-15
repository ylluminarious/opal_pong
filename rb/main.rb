require_remote "rb/ball_class.rb"
require_remote "rb/paddle_class.rb"
require_remote "rb/global_constants.rb"
require_remote "rb/game_methods.rb"
require_remote "rb/input.rb"

# Game objects
ball = Ball.new
right_paddle = Paddle.new(GameConstants::RIGHT_PADDLE_X_POS, GameConstants::RIGHT_PADDLE_Y_POS, ball)
left_paddle = Paddle.new(GameConstants::LEFT_PADDLE_X_POS, GameConstants::LEFT_PADDLE_Y_POS, ball)

# New instances of GameMethods and Input.
game_methods = GameMethods.new(ball, right_paddle, left_paddle)
event = Input.new(ball, right_paddle, left_paddle)

game_interval = $$.setInterval(Proc.new { game_methods.tick }, GameConstants::MILLESECONDS / GameConstants::FPS)

# Keyboard events will run methods from the Input class
def key_down (input_event)
  event.key_down(input_event)
end
def key_up (input_event)
  event.key_up(input_event)
end
$$.onkeydown = key_down
$$.onkeyup = key_up