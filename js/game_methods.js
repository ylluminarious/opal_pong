define(["global_constants", "global_variables", "click_toggle"], function (gameConstants, gameVariables, clickToggle) {
    var GameMethods = function (ball, rightPaddle, leftPaddle) {
        // Draws the objects of the game, the text of the victory and opening scenes, and the game's halfway line.
        this.draw = function () {
            gameConstants.CONTEXT.fillStyle = gameVariables.color;
            ball.draw();
            rightPaddle.draw();
            leftPaddle.draw();
            for (var y_pos = gameConstants.HALFWAY_LINE_Y_POS; y_pos < gameConstants.BOTTOM_WALL; y_pos += gameConstants.HALFWAY_LINE_STEPS) {
                gameConstants.CONTEXT.fillRect(gameConstants.HALFWAY_LINE_X_POS, y_pos + gameConstants.HALFWAY_LINE_STEPS / 4, gameConstants.HALFWAY_LINE_WIDTH, gameConstants.HALFWAY_LINE_STEPS / 2);
            }
            if (gameVariables.whichGame === "opening scene" || gameVariables.whichGame === "victory scene") {
                this.writeText();
            }
        };
        // Updates the positions of the game objects, and does so differently depending on which game scene is current. Also will reset all game objects in the victory scene.
        this.update = function () {
            ball.updatePosition(rightPaddle, leftPaddle);
            rightPaddle.updatePosition();
            if (gameVariables.whichGame === "opening scene") {
                ball.updatePosition(rightPaddle, leftPaddle);
                rightPaddle.AIupdatePosition();
                leftPaddle.AIupdatePosition();
            } else if (gameVariables.whichGame === "one player") {
                leftPaddle.AIupdatePosition();
            } else if (gameVariables.whichGame === "two player") {
                leftPaddle.updatePosition();
            }
            if (rightPaddle.score === gameConstants.POINTS_TO_WIN || leftPaddle.score === gameConstants.POINTS_TO_WIN) {
                gameVariables.whichGame = "victory scene";
                ball.x = gameConstants.HORIZONTAL_CENTER_OF_FIELD;
                ball.y = gameConstants.VERTICAL_CENTER_OF_FIELD;
                rightPaddle.x = gameConstants.RIGHT_PADDLE_X_POS;
                rightPaddle.y = gameConstants.RIGHT_PADDLE_Y_POS;
                leftPaddle.x = gameConstants.LEFT_PADDLE_X_POS;
                leftPaddle.y = gameConstants.LEFT_PADDLE_Y_POS;
                ball.horizontalVelocity = gameConstants.STOPPED;
                ball.verticalVelocity = gameConstants.STOPPED;
                rightPaddle.velocity = gameConstants.STOPPED;
                leftPaddle.velocity = gameConstants.STOPPED;
            }
        };
        // Method that writes the instructional text telling you how to pick which game you want. Also writes "Winner!" text in the victory scene.
        this.writeText = function () {
            gameConstants.CONTEXT.fillStyle = "white";
            gameConstants.CONTEXT.font = gameConstants.TEXT_FONT;
            gameConstants.CONTEXT.fillText("Press \"1\" for single player",
                gameConstants.LEFT_BUTTON_INSTRUCTIONS_X_POS,
                gameConstants.LEFT_BUTTON_INSTRUCTIONS_Y_POS
            );
            gameConstants.CONTEXT.fillText("Press \"2\" for double player",
                gameConstants.RIGHT_BUTTON_INSTRUCTIONS_X_POS,
                gameConstants.RIGHT_BUTTON_INSTRUCTIONS_Y_POS
            );
            if (gameVariables.whichGame === "victory scene") {
                if (rightPaddle.score === gameConstants.POINTS_TO_WIN) {
                    gameConstants.CONTEXT.fillText("Winner!",
                    gameConstants.RIGHT_WINNER_X_POS,
                    gameConstants.RIGHT_WINNER_Y_POS
                );
                } else if (leftPaddle.score === gameConstants.POINTS_TO_WIN) {
                    gameConstants.CONTEXT.fillText("Winner!",
                    gameConstants.LEFT_WINNER_X_POS,
                    gameConstants.LEFT_WINNER_Y_POS
                );
                }
            }
        };
        // Method for the buttons of the game (uses jQuery to make them work).
        this.buttons = function () {
            // The play/pause button will toggle between clicks, changing the play symbol to pause symbol (and vice versa) and whether or not the game is paused.
            $("#pause_button").clickToggle(function () {
                if (gameVariables.whichGame !== "opening scene" && gameVariables.whichGame !== "victory scene") {
                    gameVariables.paused = true;
                    $("#pause_button").html("&#9658;");
                }
            }, function () {
                if (gameVariables.whichGame !== "opening scene" && gameVariables.whichGame !== "victory scene") {
                    gameVariables.paused = false;
                    $("#pause_button").html("&#10074;&#10074;");
                }
            });
            // The restart button will set both players' points to 0 and reset all the game objects' positioins, as well as their velocities.
            $("#restart_button").click(function () {
                if (gameVariables.whichGame !== "opening scene" && gameVariables.whichGame !== "victory scene") {
                    rightPaddle.score = gameConstants.NO_POINTS;
                    leftPaddle.score = gameConstants.NO_POINTS;
                    ball.x = gameConstants.HORIZONTAL_CENTER_OF_FIELD;
                    ball.y = gameConstants.VERTICAL_CENTER_OF_FIELD;
                    rightPaddle.x = gameConstants.RIGHT_PADDLE_X_POS;
                    rightPaddle.y = gameConstants.RIGHT_PADDLE_Y_POS;
                    leftPaddle.x = gameConstants.LEFT_PADDLE_X_POS;
                    leftPaddle.y = gameConstants.LEFT_PADDLE_Y_POS;
                    ball.horizontalVelocity = gameConstants.STOPPED;
                    ball.verticalVelocity = gameConstants.STOPPED;
                    rightPaddle.horizontalVelocity = gameConstants.STOPPED;
                    rightPaddle.verticalVelocity = gameConstants.STOPPED;
                    leftPaddle.horizontalVelocity = gameConstants.STOPPED;
                    leftPaddle.verticalVelocity = gameConstants.STOPPED;
                }
            });
        };
        // The tick method will be called on every tick of the game loop; it will run the steps of the game loop, check the buttons' conditions and update the stats bar.
        this.tick = function () {
            if (!gameVariables.paused) {
                gameConstants.CONTEXT.clearRect(gameConstants.ORIGIN, gameConstants.ORIGIN, gameConstants.RIGHT_WALL, gameConstants.BOTTOM_WALL);
                this.update();
                this.draw();
                this.buttons();
                $("#game_mode").html(gameVariables.whichGame);
                $("#right_player_score").html(rightPaddle.score);
                $("#left_player_score").html(leftPaddle.score);
            }
            if (gameVariables.whichGame !== "opening scene") {
                gameVariables.color = "white";
            }
        };
    };
    return GameMethods;
});