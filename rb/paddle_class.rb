require_remote "rb/global_constants.rb"
class Paddle
  def initialize (x_pos, y_pos, ball)
    @x_pos = x_pos
    @y_pos = y_pos
    @width = GameConstants::PADDLE_WIDTH
    @height = GameConstants::PADDLE_HEIGHT
  end
  
  def draw
    GameConstants::CONTEXT[:fillStyle] = "white"
    GameConstants::CONTEXT.fillRect(@x_pos, @y_pos, @width, @height)
  end
  
end