require_remote "rb/global_constants.rb"
require_remote "rb/global_variables.rb"

class GameMethods
  
  def initialize (ball, right_paddle, left_paddle)
    @ball = ball
    @right_paddle = right_paddle
    @left_paddle = left_paddle
  end
  
  
  def draw
    GameConstants::CONTEXT[:fillStyle] = $game_variables[:color]
    @ball.draw
    @right_paddle.draw
    @left_paddle.draw
    if $game_variables[:which_game] == "opening scene" || $game_variables[:which_game] == "victory scene"
      write_text
    end
  end
  
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
  
  def tick
    GameConstants::CONTEXT.clearRect(GameConstants::ORIGIN, GameConstants::ORIGIN, GameConstants::RIGHT_WALL, GameConstants::BOTTOM_WALL)
    update
    draw
    if $game_variables[:which_game] != "opening scene"
      $game_variables[:color] = "white"
    end
  end
end