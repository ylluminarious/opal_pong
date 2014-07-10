require_remote "rb/global_constants.rb"

class Ball
  attr_accessor :x
  attr_accessor :y
  attr_accessor :horizontal_velocity
  attr_accessor :vertical_velocity
  
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
  
  def updatePosition
    @x += @horizontal_velocity / GameConstants.FPS
    @y += @vertical_velocity / GameConstants.FPS
  end
end