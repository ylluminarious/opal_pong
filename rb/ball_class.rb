require_remote "rb/global_constants.rb"

class Ball
  
  def initialize
    @x = GameConstants::HORIZONTAL_CENTER_OF_FIELD
    @y = GameConstants::VERTICAL_CENTER_OF_FIELD
    @horizontal_velocity = GameConstants::STOPPED
    @vertical_velocity = GameConstants::STOPPED
  end
  
  def draw
    GameConstants::CONTEXT.fillStyle = "white"
    GameConstants::CONTEXT.beginPath
    GameConstants::CONTEXT.arc(@x, @y, GameConstants::BALL_RADIUS, GameConstants::BALL_START_ANGLE, GameConstants::BALL_END_ANGLE)
    GameConstants::CONTEXT.fill
  end
end