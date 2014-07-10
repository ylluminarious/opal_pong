require_remote "rb/paddle_class.rb"
require_remote "rb/global_constants.rb"
require_remote "rb/ball_class.rb"
ball = Ball.new
right_paddle = Paddle.new(GameConstants::RIGHT_PADDLE_X_POS, GameConstants::RIGHT_PADDLE_Y_POS)
left_paddle = Paddle.new(GameConstants::LEFT_PADDLE_X_POS, GameConstants::LEFT_PADDLE_Y_POS)
ball.draw
right_paddle.draw
left_paddle.draw