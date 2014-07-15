require_remote "rb/global_constants.rb"

class Ball
  
  # Make the instance variables accessible
  attr_accessor :x_pos
  attr_accessor :y_pos
  attr_accessor :horizontal_velocity
  attr_accessor :vertical_velocity
  
  def initialize
    @x_pos = GameConstants::HORIZONTAL_CENTER_OF_FIELD
    @y_pos = GameConstants::VERTICAL_CENTER_OF_FIELD
    @horizontal_velocity = GameConstants::STOPPED
    @vertical_velocity = GameConstants::STOPPED
  end
  
  def draw
    GameConstants::CONTEXT.fillStyle = "white"
    GameConstants::CONTEXT.beginPath
    GameConstants::CONTEXT.arc(@x_pos, @y_pos, GameConstants::BALL_RADIUS, GameConstants::BALL_START_ANGLE, GameConstants::BALL_END_ANGLE)
    GameConstants::CONTEXT.fill
  end
  
  def update_position (right_paddle, left_paddle)
    # Update position.
    @x_pos += @horizontal_velocity / GameConstants::FPS
    @y_pos += @vertical_velocity / GameConstants::FPS
    
    # -------------------- Start of ball collision code --------------------
    
    # Ball collision constants (these can't go into GameConstants because they use objects unknown to GameConstants, i.e., right_paddle and left_paddle)
    TOP_OF_BALL = @y_pos - GameConstants::BALL_RADIUS
    BOTTOM_OF_BALL = @y_pos + GameConstants::BALL_RADIUS
    RIGHT_SIDE_OF_BALL = @x_pos + GameConstants::BALL_RADIUS
    LEFT_SIDE_OF_BALL = @x_pos - GameConstants::BALL_RADIUS
    FRONT_SIDE_OF_RIGHT_PADDLE = right_paddle.x_pos
    TOP_OF_RIGHT_PADDLE = right_paddle.y_pos
    BOTTOM_OF_RIGHT_PADDLE = right_paddle.y_pos + right_paddle.height
    FRONT_SIDE_OF_LEFT_PADDLE = left_paddle.x_pos + left_paddle.width
    TOP_OF_LEFT_PADDLE = left_paddle.y_pos
    BOTTOM_OF_LEFT_PADDLE = left_paddle.y_pos + left_paddle.height
    
    # Top wall collision
    if TOP_OF_BALL < GameConstants::TOP_WALL
      @y_pos = GameConstants::TOP_WALL + GameConstants::BALL_RADIUS
      @vertical_velocity = -@vertical_velocity
    end
    
    # Bottom wall collision
    if BOTTOM_OF_BALL > GameConstants::BOTTOM_WALL
      @y_pos = GameConstants::BOTTOM_WALL - GameConstants::BALL_RADIUS
      @vertical_velocity = -@vertical_velocity
    end
    
    # Right paddle collision (when the ball goes past the front side of the paddle)
    if RIGHT_SIDE_OF_BALL > FRONT_SIDE_OF_RIGHT_PADDLE
      # Front side collision
      if @y_pos > TOP_OF_RIGHT_PADDLE && @y_pos < BOTTOM_OF_RIGHT_PADDLE
        @x_pos = FRONT_SIDE_OF_RIGHT_PADDLE - GameConstants::BALL_RADIUS
        @horizontal_velocity = -@horizontal_velocity
      end
      
      # Top side collision
      if BOTTOM_OF_BALL > TOP_OF_RIGHT_PADDLE && @y_pos < TOP_OF_RIGHT_PADDLE && BOTTOM_OF_BALL < BOTTOM_OF_RIGHT_PADDLE
        @y_pos = TOP_OF_RIGHT_PADDLE - GameConstants::BALL_RADIUS
        @vertical_velocity = -@vertical_velocity
      end
      
      # Bottom side collision
      if TOP_OF_BALL < BOTTOM_OF_RIGHT_PADDLE && @y_pos > BOTTOM_OF_RIGHT_PADDLE && TOP_OF_BALL > TOP_OF_RIGHT_PADDLE
        @y_pos = BOTTOM_OF_RIGHT_PADDLE + GameConstants::BALL_RADIUS
        @vertical_velocity = -@vertical_velocity
      end
    end
    
    # Left paddle collision (when the ball goes past the front side of the paddle)
    if LEFT_SIDE_OF_BALL < FRONT_SIDE_OF_LEFT_PADDLE
      # Front side collision
      if @y_pos > TOP_OF_LEFT_PADDLE && @y_pos < BOTTOM_OF_LEFT_PADDLE
        @x_pos = FRONT_SIDE_OF_LEFT_PADDLE + GameConstants::BALL_RADIUS
        @horizontal_velocity = -@horizontal_velocity
      end
      
      # Top side collision
      if BOTTOM_OF_BALL > TOP_OF_LEFT_PADDLE && @y_pos < TOP_OF_LEFT_PADDLE && BOTTOM_OF_BALL < BOTTOM_OF_LEFT_PADDLE
        @y_pos = TOP_OF_LEFT_PADDLE - GameConstants::BALL_RADIUS
        @vertical_velocity = -@vertical_velocity
      end
      
      # Bottom side collision
      if TOP_OF_BALL < BOTTOM_OF_LEFT_PADDLE && @y_pos > BOTTOM_OF_LEFT_PADDLE && TOP_OF_BALL > TOP_OF_LEFT_PADDLE
        @y_pos = BOTTOM_OF_LEFT_PADDLE + GameConstants::BALL_RADIUS
        @vertical_velocity = -@vertical_velocity
      end
      
      # ******************** End of ball collision code ********************
      
      # Restart at center when the ball leaves the ball leaves the field and score a point for the paddle that scored.
      
      # When the ball goes past the right paddle...
      if LEFT_SIDE_OF_BALL > GameConstants::RIGHT_WALL
        # ... restart at the center of the field and mark a point for the left paddle.
        @x_pos = GameConstants::HORIZONTAL_CENTER_OF_FIELD
        @y_pos = GameConstants::VERTICAL_CENTER_OF_FIELD
      end
      
      # When the ball goes past the left paddle...
      if RIGHT_SIDE_OF_BALL < GameConstants::LEFT_WALL
        # ... restart at the center of the field and mark a point for the right paddle.
        @x_pos = GameConstants::HORIZONTAL_CENTER_OF_FIELD
        @y_pos = GameConstants::VERTICAL_CENTER_OF_FIELD
      end
    end
  end
end