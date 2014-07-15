require_remote "rb/global_constants.rb"

class GameMethods
  
  def initialize (ball, right_paddle, left_paddle)
    @ball = ball
    @right_paddle = right_paddle
    @left_paddle = left_paddle
  end
  
  
  def draw
    GameConstants::CONTEXT[:fillStyle] = "white"
    @ball.draw
    @right_paddle.draw
    @left_paddle.draw
  end
  
  def update
    @ball.update_position(@right_paddle, @left_paddle)
    @right_paddle.update_position
    @left_paddle.update_position
  end
  
  def tick
    GameConstants::CONTEXT.clearRect(GameConstants::ORIGIN, GameConstants::ORIGIN, GameConstants::RIGHT_WALL, GameConstants::BOTTOM_WALL)
    update
    draw
  end
end