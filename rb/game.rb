require_remote "rb/global_constants.rb"
require_remote "rb/global_variables.rb"
require_remote "rb/click_toggle.rb"

class Game
    
    include GlobalConstants
    
    def initialize (ball, right_paddle, left_paddle)
        @ball = ball
        @right_paddle = right_paddle
        @left_paddle = left_paddle
        buttons
    end
    
    def clear
        CONTEXT.clearRect(ORIGIN, ORIGIN, RIGHT_WALL, BOTTOM_WALL)
    end
    
    # Draws the objects of the game, the text of the victory and opening scenes, and the game's halfway line.
    def draw
        CONTEXT[:fillStyle] = $global_variables[:color]
        @ball.draw
        @right_paddle.draw
        @left_paddle.draw
        
        y_pos = HALFWAY_LINE_Y_POS
        while y_pos < BOTTOM_WALL
            CONTEXT.fillRect(HALFWAY_LINE_X_POS,
            y_pos + HOW_MUCH_TO_STRETCH_STEPS,
            STEP_WIDTH,
            STEP_HEIGHT
            )
            y_pos += HALFWAY_LINE_STEPS
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
            
            if @right_paddle.score == POINTS_TO_WIN || @left_paddle.score == POINTS_TO_WIN
                $global_variables[:which_game] = "victory scene"
                @ball.x_pos = HORIZONTAL_CENTER_OF_FIELD
                @ball.y_pos = VERTICAL_CENTER_OF_FIELD
                @right_paddle.y_pos = RIGHT_PADDLE_Y_POS
                @left_paddle.y_pos = LEFT_PADDLE_Y_POS
                @ball.horizontal_velocity = STOPPED
                @ball.vertical_velocity = STOPPED
                @right_paddle.velocity = STOPPED
                @left_paddle.velocity = STOPPED
            end
        end
    end
    
    # Method that writes the instructional text telling you how to pick which game you want. Also writes "Winner!" text in the victory scene.
    def write_text
        CONTEXT[:fillStyle] = "white"
        CONTEXT[:font] = TEXT_FONT
        CONTEXT.fillText("Press \"1\" for single player",
        SINGLE_PLAYER_BUTTON_INSTRUCTIONS_X_POS,
        SINGLE_PLAYER_BUTTON_INSTRUCTIONS_Y_POS
        )
        CONTEXT.fillText("Press \"2\" for double player",
        DOUBLE_PLAYER_BUTTON_INSTRUCTIONS_X_POS,
        DOUBLE_PLAYER_BUTTON_INSTRUCTIONS_Y_POS
        )
        if $global_variables[:which_game] == "victory scene"
            if @right_paddle.score == POINTS_TO_WIN
                CONTEXT.fillText("Winner!",
                RIGHT_WINNER_X_POS,
                RIGHT_WINNER_Y_POS
                )
            elsif @left_paddle.score == POINTS_TO_WIN
                CONTEXT.fillText("Winner!",
                LEFT_WINNER_X_POS,
                LEFT_WINNER_Y_POS
                )
            end
        end
    end
    
    # Method for the buttons of the game (uses Opal-jQuery to make them work).
    def buttons
        # The play/pause button will toggle between clicks, changing the play symbol to pause symbol (and vice versa) and whether or not the game is paused.
        pause_button = Element.find("#pause_button")
        
        pause = proc do
            if $global_variables[:which_game] != "opening scene" && $global_variables[:which_game] != "victory scene"
                $global_variables[:paused] = true
                pause_button.html("&#9658;")
            end
        end
        
        play = proc do
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
                @right_paddle.score = NO_POINTS
                @left_paddle.score = NO_POINTS
                @ball.x_pos = HORIZONTAL_CENTER_OF_FIELD
                @ball.y_pos = VERTICAL_CENTER_OF_FIELD
                @right_paddle.y_pos = RIGHT_PADDLE_Y_POS
                @left_paddle.y_pos = LEFT_PADDLE_Y_POS
                @ball.horizontal_velocity = STOPPED
                @ball.vertical_velocity = STOPPED
                @right_paddle.velocity = STOPPED
                @left_paddle.velocity = STOPPED
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