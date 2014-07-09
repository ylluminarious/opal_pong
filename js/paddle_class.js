define(["global_constants", "global_variables"], function (gameConstants, gameVariables) {
    var Paddle = function (xPos, yPos, horizontalScorePos, verticalScorePos, ball) {
        // Set the paddle to the positions specified in the arguments, and make the paddle stopped in the beginning of a game.
        this.x = xPos;
        this.y = yPos;
        this.horizontalScorePos = horizontalScorePos;
        this.verticalScorePos = verticalScorePos;
        this.width = gameConstants.PADDLE_WIDTH;
        this.height = gameConstants.PADDLE_HEIGHT;
        this.velocity = gameConstants.STOPPED;
        this.score = gameVariables.score;
        // Draw the paddle with its score.
        this.draw = function () {
            gameConstants.CONTEXT.fillRect(this.x, this.y, this.width, this.height);
            gameConstants.CONTEXT.font = gameConstants.SCORE_FONT;
            gameConstants.CONTEXT.fillText(this.score, this.horizontalScorePos, this.verticalScorePos);
        };
        // Method to update the paddle's position.
        this.updatePosition = function () {
            // If the ball is not stopped, update position.
            if (ball.horizontalVelocity !== gameConstants.STOPPED && ball.verticalVelocity !== gameConstants.STOPPED) {
                // Update position.
                this.y += this.velocity / gameConstants.FPS;
                
                // If the paddle hits the top wall or the bottom wall... 
                if ( this.y < gameConstants.TOP_WALL || (this.y + this.height) > gameConstants.BOTTOM_WALL ) {
                    // ... stop the paddle.
                    this.velocity = gameConstants.STOPPED;
                }
            }
        };
        // Method to update the paddle's position when it's an AI.
        this.AIupdatePosition = function () {
            // -------------------- Start of AI code --------------------
            
            // If the ball is not stopped, update position and look through the code for the AI.
            if (ball.horizontalVelocity !== gameConstants.STOPPED && ball.verticalVelocity !== gameConstants.STOPPED) {
                // Update position.
                this.y += this.velocity / gameConstants.FPS;
                
                // If the ball's center is above the paddle's center...
                if ( ball.y < (this.y + this.height / 2) ) {
                    // ... make the paddle go upwards.
                    this.velocity = -gameConstants.LEFT_PADDLE_VELOCITY;
                }
                
                // If the ball's center is below the paddle's center...
                if ( ball.y > (this.y + this.height / 2) ) {
                    // ...make the paddle's go downwards.
                    this.velocity = gameConstants.LEFT_PADDLE_VELOCITY;
                }
            
                // If the paddle is touching the top wall and the ball's center is above the paddle's center (so that the paddle will not stay stopped once the ball goes below it)...
                if ( this.y < gameConstants.TOP_WALL && ball.y < (this.y + this.height / 2) ) {
                    // ... stop the paddle.
                    this.velocity = gameConstants.STOPPED;
                }
            
                // If the paddle is touching the bottom wall and the ball's center is aboce the paddle's center...
                if ( (this.y + this.height) > gameConstants.BOTTOM_WALL && ball.y > (this.y + this.height / 2) ) {
                    // ... stop the paddle.
                    this.velocity = gameConstants.STOPPED;
                }
            }
            
            // ******************** End of AI code ********************
        };
    };
    return Paddle;
});