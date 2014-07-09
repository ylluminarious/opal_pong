define(["global_constants", "global_variables", "game_methods"], function (gameConstants, gameVariables, GameMethods) {
    var Input = function (ball, rightPaddle, leftPaddle) {
        this.keyDown = function (input) {
            // IE code
            input = input || window.event;
            // Get the key code of the key that was pressed
            var key_code = input.keyCode;
            // Prevent the key's default actions
            input.preventDefault();
            
            // Opening scene input
            if (gameVariables.whichGame === "opening scene") {
                if (key_code === gameConstants.ONE_CODE || key_code === gameConstants.ONE_NUMPAD_CODE) {
                    gameVariables.whichGame = "one player";
                }
                if (key_code === gameConstants.TWO_CODE || key_code === gameConstants.TWO_NUMPAD_CODE) {
                    gameVariables.whichGame = "two player";
                }
            }
            
            // One-player game keydown input
            if (gameVariables.whichGame === "one player") {
                // If key pressed is the spacebar and the ball isn't moving...
                if (key_code === gameConstants.SPACEBAR_CODE && ball.horizontalVelocity === gameConstants.STOPPED && ball.verticalVelocity === gameConstants.STOPPED) {
                    // ... make the ball go leftwards and downwards.
                    ball.horizontalVelocity = -gameConstants.BALL_VELOCITY;
                    ball.verticalVelocity = gameConstants.BALL_VELOCITY;
                }

                // If key pressed is up arrow, w, a, or ' (single quote) and the paddle is not touching the top wall...
                if (key_code === gameConstants.UP_ARROW_CODE || key_code === gameConstants.W_CODE || key_code === gameConstants.A_CODE || key_code === gameConstants.SINGLE_QUOTE_CODE) {
                    if (rightPaddle.y > gameConstants.TOP_WALL) {
                        // ... make the paddle go upwards.
                        rightPaddle.velocity = -gameConstants.RIGHT_PADDLE_VELOCITY;
                    }
                }
      
                // If key pressed is down arrow, s, z, or / (forward slash) and the paddle is not touching the bottom wall...
                if (key_code === gameConstants.DOWN_ARROW_CODE || key_code === gameConstants.S_CODE || key_code === gameConstants.Z_CODE || key_code === gameConstants.FORWARD_SLASH_CODE) {
                    if ( (rightPaddle.y + rightPaddle.height) < gameConstants.BOTTOM_WALL ) {
                        // ... make the paddle go downwards.
                        rightPaddle.velocity = gameConstants.RIGHT_PADDLE_VELOCITY;
                    }
                }
            }
            
            // Two-player game keydown input
            if (gameVariables.whichGame === "two player") {
                // If key pressed is the spacebar and the ball is not moving...
                if (key_code === gameConstants.SPACEBAR_CODE && ball.horizontalVelocity === gameConstants.STOPPED && ball.verticalVelocity === gameConstants.STOPPED) {
                    // ... make the ball move leftwards and downwards.
                    ball.horizontalVelocity = -gameConstants.BALL_VELOCITY;
                    ball.verticalVelocity = gameConstants.BALL_VELOCITY;
                }

                // If key pressed is a and the left paddle is not touching the top wall...
                if (key_code === gameConstants.A_CODE) {
                    if (leftPaddle.y > gameConstants.TOP_WALL) {
                        // ... make the left paddle move upwards.
                        leftPaddle.velocity = -gameConstants.LEFT_PADDLE_VELOCITY;
                    }
                }
      
                // If key pressed is z and the left paddle is not touching the bottom wall...
                if (key_code === gameConstants.Z_CODE) {
                    if ( (leftPaddle.y + leftPaddle.height) < gameConstants.BOTTOM_WALL ) {
                        // ... make the left paddle move downwards.
                        leftPaddle.velocity = gameConstants.LEFT_PADDLE_VELOCITY;
                    }
                }
      
                // If key pressed is ' (single quote) and the right paddle is not touching the top wall...
                if (key_code === gameConstants.SINGLE_QUOTE_CODE) {
                    if (rightPaddle.y > gameConstants.TOP_WALL) {
                        // ... make the right paddle move upwards.
                        rightPaddle.velocity = -gameConstants.RIGHT_PADDLE_VELOCITY;
                    }
                }
      
                // If key pressed is / (forward slash) and the right paddle is not touching the bottom wall...
                if (key_code === gameConstants.FORWARD_SLASH_CODE) {
                    if ( (rightPaddle.y + rightPaddle.height) < gameConstants.BOTTOM_WALL ) {
                        // ... make the right paddle move downwards.
                        rightPaddle.velocity = gameConstants.RIGHT_PADDLE_VELOCITY;
                    }
                }
            }
            
            // Victory scene input
            if (gameVariables.whichGame === "victory scene") {
                if (key_code === gameConstants.ONE_CODE || key_code === gameConstants.ONE_NUMPAD_CODE) {
                    rightPaddle.score = gameConstants.NO_POINTS;
                    leftPaddle.score = gameConstants.NO_POINTS;
                    ball.horizontalVelocity = gameConstants.STOPPED;
                    ball.verticalVelocity = gameConstants.STOPPED;
                    gameVariables.whichGame = "one player";
                }
                if (key_code === gameConstants.TWO_CODE || key_code === gameConstants.TWO_NUMPAD_CODE) {
                    rightPaddle.score = gameConstants.NO_POINTS;
                    leftPaddle.score = gameConstants.NO_POINTS;
                    ball.horizontalVelocity = gameConstants.STOPPED;
                    ball.verticalVelocity = gameConstants.STOPPED;
                    gameVariables.whichGame = "two player";
                }
            }
        };
        this.keyUp = function (input) {
            // IE code
            input = input || window.event;
            // Get the key code of the key that was pressed
            var key_code = input.keyCode;
            
            // One-player keyup input
            if (gameVariables.whichGame === "one player") {
                // If any of the keys for going upwards are released...
                if (key_code === gameConstants.UP_ARROW_CODE || key_code === gameConstants.W_CODE || key_code === gameConstants.A_CODE || key_code === gameConstants.SINGLE_QUOTE_CODE) {
                    // ... stop moving the paddle.
                    rightPaddle.velocity = gameConstants.STOPPED;
                }
                // If any of the keys for going downwards are released...
                if (key_code === gameConstants.DOWN_ARROW_CODE || key_code === gameConstants.S_CODE || key_code === gameConstants.Z_CODE || key_code === gameConstants.FORWARD_SLASH_CODE) {
                    // ... stop moving the paddle.
                    rightPaddle.velocity = gameConstants.STOPPED;
                }
            }
            
            // Two-player keyup input
            if (gameVariables.whichGame === "two player") {
                // If a is released...
                if (key_code === gameConstants.A_CODE) {
                    // ... stop the left paddle.
                    leftPaddle.velocity = gameConstants.STOPPED;
                }
      
                // If z is released...
                if (key_code === gameConstants.Z_CODE) {
                    // ... stop the left paddle.
                    leftPaddle.velocity = gameConstants.STOPPED;
                }
      
                // If ' (single quote) is released...
                if (key_code === gameConstants.SINGLE_QUOTE_CODE) {
                    // ... stop the right paddle.
                    rightPaddle.velocity = gameConstants.STOPPED;
                }
      
                // If / (forward slash) is released...
                if (key_code === gameConstants.FORWARD_SLASH_CODE) {
                    // ... stop the right paddle.
                    rightPaddle.velocity = gameConstants.STOPPED;
                }
            }
        };
    };
    return Input;
});