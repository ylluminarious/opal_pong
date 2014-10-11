require_remote "rb/global_constants.rb"
require_remote "rb/global_variables.rb"

class Input
    def initialize (ball, right_paddle, left_paddle)
        @ball = ball
        @right_paddle = right_paddle
        @left_paddle = left_paddle
    end
    
    def key_down (input_event)
        # IE code
        input_event = input_event || $$.event
        # Get the key code of the key that was pressed
        event = Native(input_event)
        key_pressed = event.keyCode
        # Prevent the key's default actions
        event.preventDefault
        # Paddle collision constants (these can't go into GlobalConstants because they use objects unknown to GlobalConstants: @right_paddle and @left_paddle)
        TOP_OF_RIGHT_PADDLE = @right_paddle.y_pos
        BOTTOM_OF_RIGHT_PADDLE = @right_paddle.y_pos + @right_paddle.height
        TOP_OF_LEFT_PADDLE = @left_paddle.y_pos
        BOTTOM_OF_LEFT_PADDLE = @left_paddle.y_pos + @left_paddle.height
        
        # Opening scene input
        if $global_variables[:which_game] == "opening scene"
            
            # If the key pressed is one or one on the numberpad...
            if key_pressed == GlobalConstants::ONE_CODE || key_pressed == GlobalConstants::ONE_NUMPAD_CODE
                # ... set the game mode to one player.
                $global_variables[:which_game] = "one player"
            end
            
            # If the key pressed is two or two on the numberpad...
            if key_pressed == GlobalConstants::TWO_CODE || key_pressed == GlobalConstants::TWO_NUMPAD_CODE
                # ... set the game mode to two player.
                $global_variables[:which_game] = "two player"
            end
            
        end
        
        # One-player game keydown input
        if $global_variables[:which_game] == "one player"
            # If the key pressed is the spacebar and the ball isn't moving...
            if key_pressed == GlobalConstants::SPACEBAR_CODE && @ball.horizontal_velocity == GlobalConstants::STOPPED && @ball.vertical_velocity == GlobalConstants::STOPPED
                # ... make the ball go leftwards and downwards.
                @ball.horizontal_velocity = -GlobalConstants::BALL_VELOCITY
                @ball.vertical_velocity = GlobalConstants::BALL_VELOCITY
            end
            
            # If the key pressed is up arrow, w, a, or ' (single quote) and the paddle is not touching the top wall...
            if key_pressed == GlobalConstants::UP_ARROW_CODE || key_pressed == GlobalConstants::W_CODE || key_pressed == GlobalConstants::A_CODE || key_pressed == GlobalConstants::SINGLE_QUOTE_CODE
                if TOP_OF_RIGHT_PADDLE > GlobalConstants::TOP_WALL
                    # ... make the paddle go upwards.
                    @right_paddle.velocity = -GlobalConstants::RIGHT_PADDLE_VELOCITY
                end
            end
            
            # If the key pressed is down arrow, s, z, or / (forward slash) and the paddle is not touching the bottom wall...
            if key_pressed == GlobalConstants::DOWN_ARROW_CODE || key_pressed == GlobalConstants::S_CODE || key_pressed == GlobalConstants::Z_CODE || key_pressed == GlobalConstants::FORWARD_SLASH_CODE
                if BOTTOM_OF_RIGHT_PADDLE < GlobalConstants::BOTTOM_WALL
                    # ... make the paddle go downwards.
                    @right_paddle.velocity = GlobalConstants::RIGHT_PADDLE_VELOCITY
                end
            end
        end
        
        # Two-player game keydown input
        if $global_variables[:which_game] == "two player"
            # If the key pressed is the spacebar and the ball is not moving...
            if key_pressed == GlobalConstants::SPACEBAR_CODE && @ball.horizontal_velocity == GlobalConstants::STOPPED && @ball.vertical_velocity == GlobalConstants::STOPPED
                # ... make the ball move leftwards and downwards.
                @ball.horizontal_velocity = -GlobalConstants::BALL_VELOCITY
                @ball.vertical_velocity = GlobalConstants::BALL_VELOCITY
            end
        end
        
        # If the key pressed is a and the left paddle is not touching the top wall...
        if key_pressed == GlobalConstants::A_CODE
            if TOP_OF_LEFT_PADDLE > GlobalConstants::TOP_WALL
                # ... make the left paddle move upwards.
                @left_paddle.velocity = -GlobalConstants::LEFT_PADDLE_VELOCITY
            end
        end
        
        # If the key pressed is z and the left paddle is not touching the bottom wall...
        if key_pressed == GlobalConstants::Z_CODE
            if BOTTOM_OF_LEFT_PADDLE < GlobalConstants::BOTTOM_WALL
                # ... make the left paddle move downwards.
                @left_paddle.velocity = GlobalConstants::LEFT_PADDLE_VELOCITY
            end
        end
        
        # If the key pressed is ' (single quote) and the right paddle is not touching the top wall...
        if key_pressed == GlobalConstants::SINGLE_QUOTE_CODE
            if TOP_OF_RIGHT_PADDLE > GlobalConstants::TOP_WALL
                # ... make the right paddle move upwards.
                @right_paddle.velocity = -GlobalConstants::RIGHT_PADDLE_VELOCITY
            end
        end
        
        # If the key pressed is / (forward slash) and the right paddle is not touching the bottom wall...
        if key_pressed == GlobalConstants::FORWARD_SLASH_CODE
            if BOTTOM_OF_RIGHT_PADDLE < GlobalConstants::BOTTOM_WALL
                # ... make the right paddle move downwards.
                @right_paddle.velocity = GlobalConstants::RIGHT_PADDLE_VELOCITY
            end
        end
        
        if $global_variables[:which_game] == "victory scene"
            if key_pressed == GlobalConstants::ONE_CODE || key_pressed == GlobalConstants::ONE_NUMPAD_CODE
                @right_paddle.score = GlobalConstants::NO_POINTS
                @left_paddle.score = GlobalConstants::NO_POINTS
                @ball.horizontal_velocity = GlobalConstants::STOPPED
                @ball.vertical_velocity = GlobalConstants::STOPPED
                $global_variables[:which_game] = "one player"
            end
            
            if key_pressed == GlobalConstants::TWO_CODE || key_pressed == GlobalConstants::TWO_NUMPAD_CODE
                @right_paddle.score = GlobalConstants::NO_POINTS
                @left_paddle.score = GlobalConstants::NO_POINTS
                @ball.horizontal_velocity = GlobalConstants::STOPPED
                @ball.vertical_velocity = GlobalConstants::STOPPED
                $global_variables[:which_game] = "two player"
            end
        end
    end
    
    def key_up (input_event)
        # IE code
        input_event = input_event || $$.event
        # Get the key code of the key that was pressed
        event = Native(input_event)
        key_released = event.keyCode
        
        # One-player keyup input
        if $global_variables[:which_game] == "one player"
            # If any of the keys for going upwards are released...
            if key_released == GlobalConstants::UP_ARROW_CODE || key_released == GlobalConstants::W_CODE || key_released == GlobalConstants::A_CODE || key_released == GlobalConstants::SINGLE_QUOTE_CODE
                # ... stop moving the paddle.
                @right_paddle.velocity = GlobalConstants::STOPPED
            end
            
            # If any of keys for going downwards are released...
            if key_released == GlobalConstants::DOWN_ARROW_CODE || key_released == GlobalConstants::S_CODE || key_released == GlobalConstants::Z_CODE || key_released == GlobalConstants::FORWARD_SLASH_CODE
                # ... stop moving the paddle.
                @right_paddle.velocity = GlobalConstants::STOPPED
            end
        end
        
        # Two-player keyup input
        if $global_variables[:which_game] == "two player"
            # If a is released...
            if key_released == GlobalConstants::A_CODE
                # ... stop the left paddle.
                @left_paddle.velocity = GlobalConstants::STOPPED
            end
            
            # If z is released...
            if key_released == GlobalConstants::Z_CODE
                # stop the left paddle.
                @left_paddle.velocity = GlobalConstants::STOPPED
            end
            
            # If ' (single quote) is released...
            if key_released == GlobalConstants::SINGLE_QUOTE_CODE
                # ... stop the right paddle.
                @right_paddle.velocity = GlobalConstants::STOPPED
            end
            
            # If / (forward slash) is released...
            if key_released == GlobalConstants::FORWARD_SLASH_CODE
                # ... stop the right paddle.
                @right_paddle.velocity = GlobalConstants::STOPPED
            end
        end
    end
end