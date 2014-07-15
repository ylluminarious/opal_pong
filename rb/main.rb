require_remote "rb/ball_class.rb"
require_remote "rb/paddle_class.rb"
require_remote "rb/global_constants.rb"
require_remote "rb/game_methods.rb"

# Game objects
ball = Ball.new
right_paddle = Paddle.new(GameConstants::RIGHT_PADDLE_X_POS, GameConstants::RIGHT_PADDLE_Y_POS, ball)
left_paddle = Paddle.new(GameConstants::LEFT_PADDLE_X_POS, GameConstants::LEFT_PADDLE_Y_POS, ball)

game_methods = GameMethods.new(ball, right_paddle, left_paddle)

game_interval = $$.setInterval(Proc.new { game_methods.tick }, GameConstants::MILLESECONDS / GameConstants::FPS)