require_remote "rb/global_constants.rb"
require_remote "rb/global_variables.rb"
require_remote "rb/click_toggle.rb"

class GameMethods
  
  def initialize (ball, right_paddle, left_paddle)
    @ball = ball
    @right_paddle = right_paddle
    @left_paddle = left_paddle
  end
  
  # Draws the objects of the game, the text of the victory and opening scenes, and the game's halfway line.
  def draw
    GameConstants::CONTEXT[:fillStyle] = $game_variables[:color]
    @ball.draw
    @right_paddle.draw
    @left_paddle.draw
    
    y_pos = GameConstants::HALFWAY_LINE_Y_POS
    while y_pos < GameConstants::BOTTOM_WALL
      GameConstants::CONTEXT.fillRect(GameConstants::HALFWAY_LINE_X_POS,
      y_pos + GameConstants::HALFWAY_LINE_STEPS / 4,
      GameConstants::HALFWAY_LINE_WIDTH,
      GameConstants::HALFWAY_LINE_STEPS / 2
      )
      y_pos += GameConstants::HALFWAY_LINE_STEPS
    end
    
    if $game_variables[:which_game] == "opening scene" || $game_variables[:which_game] == "victory scene"
      write_text
    end
  end
  
  # Updates the positions of the game objects, and does so differently depending on which game scene is current. Also will reset all game objects in the victory scene.
  def update
    @ball.update_position(@right_paddle, @left_paddle)
    @right_paddle.update_position
    
    if $game_variables[:which_game] == "opening scene"
      @ball.update_position(@right_paddle, @left_paddle)
      @right_paddle.AI_update_position
      @left_paddle.AI_update_position
    elsif $game_variables[:which_game] == "one player"
      @left_paddle.AI_update_position
    elsif $game_variables[:which_game] == "two player"
      @left_paddle.update_position
    end
    
    if @right_paddle.score == GameConstants::POINTS_TO_WIN || @left_paddle.score == GameConstants::POINTS_TO_WIN
      $game_variables[:which_game] = "victory scene"
      @ball.x_pos = GameConstants::HORIZONTAL_CENTER_OF_FIELD
      @ball.y_pos = GameConstants::VERTICAL_CENTER_OF_FIELD
      @right_paddle.x_pos = GameConstants::RIGHT_PADDLE_X_POS
      @left_paddle.y_pos = GameConstants::RIGHT_PADDLE_Y_POS
      @left_paddle.x_pos = GameConstants::LEFT_PADDLE_X_POS
      @left_paddle.y_pos = GameConstants::LEFT_PADDLE_Y_POS
      @ball.horizontal_velocity = GameConstants::STOPPED
      @ball.vertical_velocity = GameConstants::STOPPED
      @right_paddle.velocity = GameConstants::STOPPED
      @left_paddle.velocity = GameConstants::STOPPED
    end
  end
  
  # Method that writes the instructional text telling you how to pick which game you want. Also writes "Winner!" text in the victory scene.
  def write_text
    GameConstants::CONTEXT[:fillStyle] = "white"
    GameConstants::CONTEXT[:font] = GameConstants::TEXT_FONT
    GameConstants::CONTEXT.fillText("Press \"1\" for single player",
    GameConstants::SINGLE_PLAYER_BUTTON_INSTRUCTIONS_X_POS,
    GameConstants::SINGLE_PLAYER_BUTTON_INSTRUCTIONS_Y_POS
    )
    GameConstants::CONTEXT.fillText("Press \"2\" for double player",
    GameConstants::DOUBLE_PLAYER_BUTTON_INSTRUCTIONS_X_POS,
    GameConstants::DOUBLE_PLAYER_BUTTON_INSTRUCTIONS_Y_POS
    )
    if $game_variables[:which_game] == "victory scene"
      if @right_paddle.score == GameConstants::POINTS_TO_WIN
        GameConstants::CONTEXT.fillText("Winner!",
        GameConstants::RIGHT_WINNER_X_POS,
        GameConstants::RIGHT_WINNER_Y_POS
        )
      elsif @left_paddle.score == GameConstants::POINTS_TO_WIN
        GameConstants::CONTEXT.fillText("Winner!",
        GameConstants::LEFT_WINNER_X_POS,
        GameConstants::LEFT_WINNER_Y_POS
        )
      end
    end
  end
  
  # Method for the buttons of the game (uses Opal-jQuery to make them work).
  def buttons
    # The play/pause button will toggle between clicks, changing the play symbol to pause symbol (and vice versa) and whether or not the game is paused.
    pause_button = Element.find("#pause_button")
    
    pause = Proc.new do
      if $game_variables[:which_game] != "opening scene" && $game_variables[:which_game] != "victory scene"
        $game_variables[:paused] = true
        pause_button.html("&#9658;")
      end
    end
    
    play = Proc.new do
      if $game_variables[:which_game] != "opening scene" && $game_variables[:which_game] != "victory scene"
        $game_variables[:paused] = false
        pause_button.html("&#10074;&#10074;")
      end
    end
    
    pause_button.click_toggle(pause, play)
    
    # The restart button will set both players' points to 0 and reset all the game objects' positions, as well as their velocities.
    restart_button = Element.find("#restart_button")
    restart_button.on(:click) do
      if $game_variables[:which_game] != "opening scene" && $game_variables[:which_game] != "victory scene"
        @right_paddle.score = GameConstants::NO_POINTS
        @left_paddle.score = GameConstants::NO_POINTS
        @ball.x_pos = GameConstants::HORIZONTAL_CENTER_OF_FIELD
        @ball.y_pos = GameConstants::VERTICAL_CENTER_OF_FIELD
        @right_paddle.x_pos = GameConstants::RIGHT_PADDLE_X_POS
        @right_paddle.y_pos = GameConstants::RIGHT_PADDLE_Y_POS
        @left_paddle.x_pos = GameConstants::LEFT_PADDLE_X_POS
        @left_paddle.y_pos = GameConstants::LEFT_PADDLE_Y_POS
        @ball.horizontal_velocity = GameConstants::STOPPED
        @ball.vertical_velocity = GameConstants::STOPPED
        @right_paddle.velocity = GameConstants::STOPPED
        @left_paddle.velocity = GameConstants::STOPPED
      end
    end
  end
    
  
  # The tick method will be called on every tick of the game loop; it will run the steps of the game loop, check the buttons' conditions and update the stats bar.
  def tick
    GameConstants::CONTEXT.clearRect(GameConstants::ORIGIN, GameConstants::ORIGIN, GameConstants::RIGHT_WALL, GameConstants::BOTTOM_WALL)
    update
    draw
    buttons
    game_mode = Element.find("#game_mode")
    right_player_score = Element.find("#right_player_score")
    left_player_score = Element.find("#left_player_score")
    game_mode.html($game_variables[:which_game])
    right_player_score.html(@right_paddle.score)
    left_player_score.html(@left_paddle.score)
    
    if $game_variables[:which_game] != "opening scene"
      $game_variables[:color] = "white"
    end
  end
end