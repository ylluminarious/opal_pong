require_remote "rb/global_constants.rb"
require_remote "rb/global_variables.rb"

class Paddle
    
    attr_accessor :x_pos
    attr_accessor :y_pos
    attr_accessor :horizontal_score_pos
    attr_accessor :vertical_score_pos
    attr_accessor :width
    attr_accessor :height
    attr_accessor :velocity
    attr_accessor :score
    
    def initialize (x_pos, y_pos, horizontal_score_pos, vertical_score_pos, ball)
        @x_pos = x_pos
        @y_pos = y_pos
        @horizontal_score_pos = horizontal_score_pos
        @vertical_score_pos = vertical_score_pos
        @width = GlobalConstants::PADDLE_WIDTH
        @height = GlobalConstants::PADDLE_HEIGHT
        @velocity = GlobalConstants::STOPPED
        @score = $global_variables[:score]
        @ball = ball
    end
    
    def draw
        GlobalConstants::CONTEXT.fillRect(@x_pos, @y_pos, @width, @height)
        GlobalConstants::CONTEXT[:font] = GlobalConstants::SCORE_FONT
        GlobalConstants::CONTEXT.fillText(@score, @horizontal_score_pos, @vertical_score_pos)
    end
    
    # Method to update the paddle's position.
    def update_position
        # If the paddle is not stopped, update position.
        if @ball.horizontal_velocity != GlobalConstants::STOPPED && @ball.vertical_velocity != GlobalConstants::STOPPED
            
            # Update position.
            @y_pos += @velocity / GlobalConstants::FPS
            
            # If the paddle hits the top wall or the bottom wall...
            if @y_pos < GlobalConstants::TOP_WALL || (@y_pos + @height) > GlobalConstants::BOTTOM_WALL
                @velocity = GlobalConstants::STOPPED
            end
        end
        
        # Method to update the paddle's position when it's an AI.
        def AI_update_position
            # -------------------- Start of AI code --------------------
            
            # AI constants; these can't go into GlobalConstants because they use instance variables.
            BOTTOM_OF_PADDLE = @y_pos + @height
            CENTER_OF_PADDLE = @y_pos + @height / GlobalConstants::HALVES
            
            # If the ball is not stopped, update position and look through the code for the AI.
            if @ball.horizontal_velocity != GlobalConstants::STOPPED && @ball.vertical_velocity != GlobalConstants::STOPPED
                
                # Update position.
                @y_pos += @velocity / GlobalConstants::FPS
                
                # If the ball's center is above the paddle's center...
                if @ball.y_pos < CENTER_OF_PADDLE
                    # ... make the paddle go upwards.
                    @velocity = -GlobalConstants::LEFT_PADDLE_VELOCITY
                end
                
                # If the ball's center is below the paddle's center...
                if @ball.y_pos > CENTER_OF_PADDLE
                    # ... make the paddle go downwards.
                    @velocity = GlobalConstants::LEFT_PADDLE_VELOCITY
                end
                
                # If the paddle is touching the top wall and the ball's center is above the paddle's center (so that the paddle will not stay stopped once the ball goes below it)...
                if @y_pos < GlobalConstants::TOP_WALL && @ball.y_pos < CENTER_OF_PADDLE
                    # ... stop the paddle.
                    @velocity = GlobalConstants::STOPPED
                end
                
                # If the paddle is touching the bottom wall and the ball's center is above the paddle's center (again, so that the paddle will not stay stopped once the ball goes above it)...
                if BOTTOM_OF_PADDLE > GlobalConstants::BOTTOM_WALL && @ball.y_pos > CENTER_OF_PADDLE
                    # ... stop the paddle.
                    @velocity = GlobalConstants::STOPPED
                end
            end
            
            # ******************** End of AI code ********************
        end
    end
end