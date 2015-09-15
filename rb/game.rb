require_relative "global_constants"
require_relative "global_variables"
require_relative "click_toggle"

class Game
    
    def initialize (ball, right_paddle, left_paddle)
        @ball = ball
        @right_paddle = right_paddle
        @left_paddle = left_paddle
        buttons
    end
    
    def clear
        GlobalConstants::CONTEXT.clearRect(GlobalConstants::ORIGIN, GlobalConstants::ORIGIN, GlobalConstants::RIGHT_WALL, GlobalConstants::BOTTOM_WALL)
    end
    
    # Draws the objects of the game, the text of the victory and opening scenes, and the game's halfway line.
    def draw
        GlobalConstants::CONTEXT[:fillStyle] = $global_variables[:color]
        @ball.draw
        @right_paddle.draw
        @left_paddle.draw
        
        y_pos = GlobalConstants::HALFWAY_LINE_Y_POS
        while y_pos < GlobalConstants::BOTTOM_WALL
            GlobalConstants::CONTEXT.fillRect(GlobalConstants::HALFWAY_LINE_X_POS,
            y_pos + GlobalConstants::HOW_MUCH_TO_STRETCH_STEPS,
            GlobalConstants::STEP_WIDTH,
            GlobalConstants::STEP_HEIGHT
            )
            y_pos += GlobalConstants::HALFWAY_LINE_STEPS
        end
        
        if $global_variables[:which_game] == "opening scene" || $global_variables[:which_game] == "victory scene"
            write_text
        end
    end
    
    # Updates the positions of the game objects, and does so differently depending on which game scene is current. Also will reset all game objects in the victory scene.
    def update
        if !$global_variables[:paused]
            @ball.update_position(@right_paddle, @left_paddle)
            @right_paddle.update_position
            
            if $global_variables[:which_game] == "opening scene"
                # do nothing
            elsif $global_variables[:which_game] == "one player"
                @left_paddle.AI_update_position
            elsif $global_variables[:which_game] == "two player"
                @left_paddle.update_position
            end
            
            if @right_paddle.score == GlobalConstants::POINTS_TO_WIN || @left_paddle.score == GlobalConstants::POINTS_TO_WIN
                $global_variables[:which_game] = "victory scene"
                @ball.x_pos = GlobalConstants::HORIZONTAL_CENTER_OF_FIELD
                @ball.y_pos = GlobalConstants::VERTICAL_CENTER_OF_FIELD
                @right_paddle.y_pos = GlobalConstants::RIGHT_PADDLE_Y_POS
                @left_paddle.y_pos = GlobalConstants::LEFT_PADDLE_Y_POS
                @ball.horizontal_velocity = GlobalConstants::STOPPED
                @ball.vertical_velocity = GlobalConstants::STOPPED
                @right_paddle.velocity = GlobalConstants::STOPPED
                @left_paddle.velocity = GlobalConstants::STOPPED
            end
        end
    end
    
    # Method that writes the instructional text telling you how to pick which game you want. Also writes "Winner!" text in the victory scene.
    def write_text
        GlobalConstants::CONTEXT[:fillStyle] = "white"
        GlobalConstants::CONTEXT[:font] = GlobalConstants::TEXT_FONT
        GlobalConstants::CONTEXT.fillText("Press \"1\" for single player",
        GlobalConstants::SINGLE_PLAYER_BUTTON_INSTRUCTIONS_X_POS,
        GlobalConstants::SINGLE_PLAYER_BUTTON_INSTRUCTIONS_Y_POS
        )
        GlobalConstants::CONTEXT.fillText("Press \"2\" for double player",
        GlobalConstants::DOUBLE_PLAYER_BUTTON_INSTRUCTIONS_X_POS,
        GlobalConstants::DOUBLE_PLAYER_BUTTON_INSTRUCTIONS_Y_POS
        )
        if $global_variables[:which_game] == "victory scene"
            if @right_paddle.score == GlobalConstants::POINTS_TO_WIN
                GlobalConstants::CONTEXT.fillText("Winner!",
                GlobalConstants::RIGHT_WINNER_X_POS,
                GlobalConstants::RIGHT_WINNER_Y_POS
                )
            elsif @left_paddle.score == GlobalConstants::POINTS_TO_WIN
                GlobalConstants::CONTEXT.fillText("Winner!",
                GlobalConstants::LEFT_WINNER_X_POS,
                GlobalConstants::LEFT_WINNER_Y_POS
                )
            end
        end
    end
    
    # Method for the buttons of the game (uses Opal-jQuery to make them work).
    def buttons
        # The play/pause button will toggle between clicks, changing the play symbol to pause symbol (and vice versa) and whether or not the game is paused.
        pause_button = Element.find("#pause_button")
        
        pause = Proc.new do
            if $global_variables[:which_game] != "opening scene" && $global_variables[:which_game] != "victory scene"
                $global_variables[:paused] = true
                pause_button.html("&#9658;")
            end
        end
        
        play = Proc.new do
            if $global_variables[:which_game] != "opening scene" && $global_variables[:which_game] != "victory scene"
                $global_variables[:paused] = false
                pause_button.html("&#10074;&#10074;")
            end
        end
        
        pause_button.click_toggle(pause, play)
        
        # The restart button will set both players' points to 0 and reset all the game objects' positions, as well as their velocities.
        restart_button = Element.find("#restart_button")
        restart_button.on(:click) do
            if $global_variables[:which_game] != "opening scene" && $global_variables[:which_game] != "victory scene" && !$global_variables[:paused]
                @right_paddle.score = GlobalConstants::NO_POINTS
                @left_paddle.score = GlobalConstants::NO_POINTS
                @ball.x_pos = GlobalConstants::HORIZONTAL_CENTER_OF_FIELD
                @ball.y_pos = GlobalConstants::VERTICAL_CENTER_OF_FIELD
                @right_paddle.y_pos = GlobalConstants::RIGHT_PADDLE_Y_POS
                @left_paddle.y_pos = GlobalConstants::LEFT_PADDLE_Y_POS
                @ball.horizontal_velocity = GlobalConstants::STOPPED
                @ball.vertical_velocity = GlobalConstants::STOPPED
                @right_paddle.velocity = GlobalConstants::STOPPED
                @left_paddle.velocity = GlobalConstants::STOPPED
            end
        end
    end
    
    
    # The tick method will be called on every tick of the game loop; it will run the steps of the game loop, check the buttons' conditions and update the stats bar.
    def tick
        clear
        update
        draw
        game_mode = Element.find("#game_mode")
        right_player_score = Element.find("#right_player_score")
        left_player_score = Element.find("#left_player_score")
        game_mode.html($global_variables[:which_game])
        right_player_score.html(@right_paddle.score)
        left_player_score.html(@left_paddle.score)
        
        if $global_variables[:which_game] != "opening scene"
            $global_variables[:color] = "white"
        end
    end
end