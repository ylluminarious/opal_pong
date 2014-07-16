require_remote "rb/global_constants.rb"
require_remote "rb/global_variables.rb"
require_remote "rb/game_methods.rb"

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
    key_pressed = event.key_code
    # Prevent the key's default actions
    event.preventDefault
    # Paddle collision constants (these can't go into GameConstants because they use objects unknown to GameConstants: @right_paddle and @left_paddle)
    TOP_OF_RIGHT_PADDLE = @right_paddle.y_pos
    BOTTOM_OF_RIGHT_PADDLE = @right_paddle.y_pos + @right_paddle.height
    TOP_OF_LEFT_PADDLE = @left_paddle.y_pos
    BOTTOM_OF_LEFT_PADDLE = @left_paddle.y_pos + @left_paddle.height
    
    # Opening scene input
    if $game_variables[:which_game] == "opening scene"
      
      # If the key pressed is one or one on the numberpad...
      if key_pressed == GameConstants::ONE_CODE || key_pressed == GameConstants::ONE_NUMPAD_CODE
        # ... set the game mode to one player.
        $game_variables[:which_game] = "one player"
      end
      
      # If the key pressed is two or two on the numberpad...
      if key_pressed == GameConstants::TWO_CODE || key_pressed == GameConstants::TWO_NUMPAD_CODE
        # ... set the game mode to two player.
        $game_variables[:which_game] = "two player"
      end
      
    end
    
    # One-player game keydown input
    if $game_variables[:which_game] == "one player"
      # If the key pressed is the spacebar and the ball isn't moving...
      if key_pressed == GameConstants::SPACEBAR_CODE && @ball.horizontal_velocity == GameConstants::STOPPED && ball.vertical_velocity == GameConstants::STOPPED
        # ... make the ball go leftwards and downwards.
        @ball.horizontal_velocity = -GameConstants::BALL_VELOCITY
        @ball.vertical_velocity = -GameConstants::BALL_VELOCITY
      end
      
      # If the key pressed is up arrow, w, a, or ' (single quote) and the paddle is not touching the top wall...
      if key_pressed == GameConstants::UP_ARROW_CODE || key_pressed == GameConstants::W_CODE || key_pressed == GameConstants::A_CODE || key_pressed == GameConstants::SINGLE_QUOTE_CODE
        if TOP_OF_RIGHT_PADDLE > GameConstants::TOP_WALL
          # ... make the paddle go upwards.
          @right_paddle.velocity = -GameConstants::RIGHT_PADDLE_VELOCITY
        end
      end
      
      # If the key pressed is down arrow, s, z, or / (forward slash) and the paddle is not touching the bottom wall...
      if key_pressed == GameConstants::DOWN_ARROW_CODE || key_pressed == GameConstants::S_CODE || key_pressed == GameConstants::Z_CODE || key_pressed == GameConstants::FORWARD_SLASH_CODE
        if BOTTOM_OF_RIGHT_PADDLE < GameConstants::BOTTOM_WALL
          # ... make the paddle go downwards.
          @right_paddle.velocity = GameConstants::RIGHT_PADDLE_VELOCITY
        end
      end
    end
    
    # Two-player game keydown input
    if $game_variables[:which_game] == "two player"
      # If the key pressed is the spacebar and the ball is not moving...
      if key_pressed == GameConstants::SPACEBAR_CODE && @ball.horizontal_velocity == GameConstants::STOPPED && @ball.vertical_velocity == GameConstants::STOPPED
        # ... make the ball move leftwards and downwards.
        @ball.horizontal_velocity = -GameConstants::BALL_VELOCITY
        @ball.vertical_velocity = -GameConstants::BALL_VELOCITY
      end
    end
    
    # If the key pressed is a and the left paddle is not touching the top wall...
    if key_pressed == GameConstants::A_CODE
      if TOP_OF_LEFT_PADDLE > GameConstants::TOP_WALL
        # ... make the left paddle move upwards.
        @left_paddle.velocity = -GameConstants::LEFT_PADDLE_VELOCITY
      end
    end
    
    # If the key pressed is z and the left paddle is not touching the bottom wall...
    if key_pressed == GameConstants::Z_CODE
      if BOTTOM_OF_LEFT_PADDLE < GameConstants::BOTTOM_WALL
        # ... make the left paddle move downwards.
        @left_paddle.velocity = GameConstants::LEFT_PADDLE_VELOCITY
      end
    end
    
    # If the key pressed is ' (single quote) and the right paddle is not touching the top wall...
    if key_pressed == GameConstants::SINGLE_QUOTE_CODE
      if TOP_OF_RIGHT_PADDLE > GameConstants::TOP_WALL
        # ... make the right paddle move upwards.
        @right_paddle.velocity = -GameConstants::RIGHT_PADDLE_VELOCITY
      end
    end
    
    # If the key pressed is / (forward slash) and the right paddle is not touching the bottom wall...
    if key_pressed == GameConstants::FORWARD_SLASH_CODE
      if BOTTOM_OF_RIGHT_PADDLE < GameConstants::BOTTOM_WALL
        # ... make the right paddle move downwards.
        @right_paddle.velocity = GameConstants::RIGHT_PADDLE_VELOCITY
      end
    end
    
    if $game_variables[:which_game] == "victory scene"
      if key_pressed == GameConstants::ONE_CODE || key_pressed == GameConstants::ONE_NUMPAD_CODE
        @right_paddle.score = GameConstants::NO_POINTS
        @left_paddle.score = GameConstants::NO_POINTS
        @ball.horizontal_velocity = GameConstants::STOPPED
        @ball.vertical_velocity = GameConstants::STOPPED
        $game_variables[:which_game] = "one player"
      end
      
      if key_pressed == GameConstants::TWO_CODE || key_pressed == GameConstants::TWO_NUMPAD_CODE
        @right_paddle.score = GameConstants::NO_POINTS
        @left_paddle.score = GameConstants::NO_POINTS
        @ball.horizontal_velocity = GameConstants::STOPPED
        @ball.vertical_velocity = GameConstants::STOPPED
        $game_variables[:which_game] = "two player"
      end
    end
  end
  
  def key_up (input_event)
    # IE code
    input_event = input_event || $$.event
    # Get the key code of the key that was pressed
    event = Native(input_event)
    key_released = event.key_code
  
    # One-player keyup input
    if $game_variables[:which_game] == "one player"
      # If any of the keys for going upwards are released...
      if key_released == GameConstants::UP_ARROW_CODE || key_released == GameConstants::W_CODE || key_released == GameConstants::A_CODE || key_released == GameConstants::SINGLE_QUOTE_CODE
        # ... stop moving the paddle.
        @right_paddle.velocity = GameConstants::STOPPED
      end
    
      # If any of keys for going downwards are released...
      if key_released == GameConstants::DOWN_ARROW_CODE || key_released == GameConstants::S_CODE || key_released == GameConstants::Z_CODE || key_released == GameConstants::FORWARD_SLASH_CODE
        # ... stop moving the paddle.
        @right_paddle.velocity = GameConstants::STOPPED
      end
    end
  
    # Two-player keyup input
    if $game_variables[:which_game] == "two player"
      # If a is released...
      if key_released == GameConstants::A_CODE
        # ... stop the left paddle.
        @left_paddle.velocity = GameConstants::STOPPED
      end
      
      # If z is released...
      if key_released == GameConstants::Z_CODE
        # stop the left paddle.
        @left_paddle.velocity = GameConstants::STOPPED
      end
      
      # If ' (single quote) is released...
      if key_released == GameConstants::SINGLE_QUOTE_CODE
        # ... stop the right paddle.
        @right_paddle.velocity = GameConstants::STOPPED
      end
      
      # If / (forward slash) is released...
      if key_released == GameConstants::FORWARD_SLASH_CODE
        # ... stop the right paddle.
        @right_paddle.velocity = GameConstants::STOPPED
      end
    end
  end
end