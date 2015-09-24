require_relative "global_constants"

class Ball
    
    include GlobalConstants
    
    # Make the instance variables accessible
    attr_accessor :x_pos
    attr_accessor :y_pos
    attr_accessor :horizontal_velocity
    attr_accessor :vertical_velocity
    
    def initialize
        @x_pos = HORIZONTAL_CENTER_OF_FIELD
        @y_pos = VERTICAL_CENTER_OF_FIELD
        @horizontal_velocity = STOPPED
        @vertical_velocity = STOPPED
    end
    
    def draw
        CONTEXT.beginPath
        CONTEXT.arc(@x_pos, @y_pos, BALL_RADIUS, BALL_START_ANGLE, BALL_END_ANGLE)
        CONTEXT.fill
    end
    
    def update_position (right_paddle, left_paddle)
        # Update position.
        @x_pos += @horizontal_velocity / FPS
        @y_pos += @vertical_velocity / FPS
        
        # -------------------- Start of ball collision code --------------------
        
        # Ball collision constants (these can't go into GlobalConstants because they use objects unknown to GlobalConstants, i.e., right_paddle and left_paddle, as well as instance variables)
        TOP_OF_BALL = @y_pos - BALL_RADIUS
        BOTTOM_OF_BALL = @y_pos + BALL_RADIUS
        RIGHT_SIDE_OF_BALL = @x_pos + BALL_RADIUS
        LEFT_SIDE_OF_BALL = @x_pos - BALL_RADIUS
        FRONT_SIDE_OF_RIGHT_PADDLE = right_paddle.x_pos
        TOP_OF_RIGHT_PADDLE = right_paddle.y_pos
        BOTTOM_OF_RIGHT_PADDLE = right_paddle.y_pos + right_paddle.height
        FRONT_SIDE_OF_LEFT_PADDLE = left_paddle.x_pos + left_paddle.width
        TOP_OF_LEFT_PADDLE = left_paddle.y_pos
        BOTTOM_OF_LEFT_PADDLE = left_paddle.y_pos + left_paddle.height
        
        # Top wall collision
        if TOP_OF_BALL < TOP_WALL
            @y_pos = TOP_WALL + BALL_RADIUS
            @vertical_velocity = -@vertical_velocity
        end
        
        # Bottom wall collision
        if BOTTOM_OF_BALL > BOTTOM_WALL
            @y_pos = BOTTOM_WALL - BALL_RADIUS
            @vertical_velocity = -@vertical_velocity
        end
        
        # Right paddle collision (when the ball goes past the front side of the paddle)
        if RIGHT_SIDE_OF_BALL > FRONT_SIDE_OF_RIGHT_PADDLE
            # Front side collision
            if @y_pos > TOP_OF_RIGHT_PADDLE && @y_pos < BOTTOM_OF_RIGHT_PADDLE
                @x_pos = FRONT_SIDE_OF_RIGHT_PADDLE - BALL_RADIUS
                @horizontal_velocity = -@horizontal_velocity
            end
            
            # Top side collision
            if BOTTOM_OF_BALL > TOP_OF_RIGHT_PADDLE && @y_pos < TOP_OF_RIGHT_PADDLE && BOTTOM_OF_BALL < BOTTOM_OF_RIGHT_PADDLE
                @y_pos = TOP_OF_RIGHT_PADDLE - BALL_RADIUS
                @vertical_velocity = -@vertical_velocity
            end
            
            # Bottom side collision
            if TOP_OF_BALL < BOTTOM_OF_RIGHT_PADDLE && @y_pos > BOTTOM_OF_RIGHT_PADDLE && TOP_OF_BALL > TOP_OF_RIGHT_PADDLE
                @y_pos = BOTTOM_OF_RIGHT_PADDLE + BALL_RADIUS
                @vertical_velocity = -@vertical_velocity
            end
        end
        
        # Left paddle collision (when the ball goes past the front side of the paddle)
        if LEFT_SIDE_OF_BALL < FRONT_SIDE_OF_LEFT_PADDLE
            # Front side collision
            if @y_pos > TOP_OF_LEFT_PADDLE && @y_pos < BOTTOM_OF_LEFT_PADDLE
                @x_pos = FRONT_SIDE_OF_LEFT_PADDLE + BALL_RADIUS
                @horizontal_velocity = -@horizontal_velocity
            end
            
            # Top side collision
            if BOTTOM_OF_BALL > TOP_OF_LEFT_PADDLE && @y_pos < TOP_OF_LEFT_PADDLE && BOTTOM_OF_BALL < BOTTOM_OF_LEFT_PADDLE
                @y_pos = TOP_OF_LEFT_PADDLE - BALL_RADIUS
                @vertical_velocity = -@vertical_velocity
            end
            
            # Bottom side collision
            if TOP_OF_BALL < BOTTOM_OF_LEFT_PADDLE && @y_pos > BOTTOM_OF_LEFT_PADDLE && TOP_OF_BALL > TOP_OF_LEFT_PADDLE
                @y_pos = BOTTOM_OF_LEFT_PADDLE + BALL_RADIUS
                @vertical_velocity = -@vertical_velocity
            end
        end
        # ******************** End of ball collision code ********************
        
        # Restart at center when the ball leaves the ball leaves the field and score a point for the paddle that scored.
        
        # When the ball goes past the right paddle...
        if LEFT_SIDE_OF_BALL > RIGHT_WALL
            # ... restart at the center of the field and mark a point for the left paddle.
            @x_pos = HORIZONTAL_CENTER_OF_FIELD
            @y_pos = VERTICAL_CENTER_OF_FIELD
            left_paddle.score += ONE_POINT
        end
        
        # When the ball goes past the left paddle...
        if RIGHT_SIDE_OF_BALL < LEFT_WALL
            # ... restart at the center of the field and mark a point for the right paddle.
            @x_pos = HORIZONTAL_CENTER_OF_FIELD
            @y_pos = VERTICAL_CENTER_OF_FIELD
            right_paddle.score += ONE_POINT
        end
    end
end