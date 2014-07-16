require_remote "rb/global_constants.rb"
require_remote "rb/global_variables.rb"

class Paddle
  
  attr_accessor :x_pos
  attr_accessor :y_pos
  attr_accessor :width
  attr_accessor :height
  attr_accessor :velocity
  attr_accessor :score
  
  def initialize (x_pos, y_pos, ball)
    @x_pos = x_pos
    @y_pos = y_pos
    @width = GameConstants::PADDLE_WIDTH
    @height = GameConstants::PADDLE_HEIGHT
    @velocity = GameConstants::STOPPED
    @score = $game_variables[:score]
    @ball = ball
  end
  
  def draw
    GameConstants::CONTEXT.fillRect(@x_pos, @y_pos, @width, @height)
  end
  
  # Method to update the paddle's position.
  def update_position
    
    # If the paddle is not stopped, update position.
    if @ball.horizontal_velocity != GameConstants::STOPPED && @ball.vertical_velocity != GameConstants::STOPPED
      # Update position.
      @y_pos += @velocity / GameConstants::FPS
      
      # If the paddle hits the top wall or the bottom wall...
      if @y_pos < GameConstants::TOP_WALL || (@y_pos + @height) > GameConstants::BOTTOM_WALL
        @velocity = GameConstants::STOPPED
      end
    end
    
    def AI_update_position
      # -------------------- Start of AI code --------------------
      
      # AI constants; these can't go into GameConstants because they use instance variables.
      CENTER_OF_PADDLE = @y_pos + @height / 2
      BOTTOM_OF_PADDLE = @y_pos + @height
      
      # If the ball is not stopped, update position and look through the code for the AI.
      if @ball.horizontal_velocity != GameConstants::STOPPED && @ball.vertical_velocity != GameConstants::STOPPED
        # Update position.
        @y_pos += @velocity / GameConstants::FPS
        
        # If the ball's center is above the paddle's center...
        if @ball.y_pos < CENTER_OF_PADDLE
          # ... make the paddle go upwards.
          @velocity = -GameConstants::LEFT_PADDLE_VELOCITY
        end
        
        # If the ball's center is below the paddle's center...
        if @ball.y_pos > CENTER_OF_PADDLE
          # ... make the paddle go downwards.
          @velocity = GameConstants::LEFT_PADDLE_VELOCITY
        end
        
        # If the paddle is touching the top wall and the ball's center is above the paddle's center (so that the paddle will not stay stopped once the ball goes below it)...
        if @y_pos < GameConstants::TOP_WALL && @ball.y_pos < CENTER_OF_PADDLE
          # ... stop the paddle.
          @velocity = GameConstants::STOPPED
        end
        
        # If the paddle is touching the bottom wall and the ball's center is above the paddle's center (again, so that the paddle will not stay stopped once the ball goes above it)...
        if BOTTOM_OF_PADDLE > GameConstants::BOTTOM_WALL && @ball.y_pos > CENTER_OF_PADDLE
          # ... stop the paddle.
          @velocity = GameConstants::STOPPED
        end
      end
    end
  end
end