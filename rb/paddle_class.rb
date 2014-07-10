require_remote "rb/global_constants.rb"
class Paddle
  def initialize (x_pos, y_pos, ball)
    @x_pos = x_pos
    @y_pos = y_pos
    @width = GameConstants::PADDLE_WIDTH
    @height = GameConstants::PADDLE_HEIGHT
    @velocity = GameConstants::STOPPED
    @ball = ball
  end
  
  def draw
    GameConstants::CONTEXT[:fillStyle] = "white"
    GameConstants::CONTEXT.fillRect(@x_pos, @y_pos, @width, @height)
  end
  
  # Method to update the paddle's position.
  def update_position
    
    # If the paddle is not stopped, update position.
    if @ball.horizontal_velocity != GameConstants::STOPPED && @ball.vertical_velocity != GameConstants::STOPPED
      
      # Update position.
      @y_pos += @velocity / GameConstants::FPS
      
      # If the paddle hits the top wall or the bottom wall...
      if @y_pos < GameConstants::TOP_WALL || (@y + @height) > GameConstants::BOTTOM_WALL
        @velocity = GameConstants::STOPPED
      end
      
    end
  end
end