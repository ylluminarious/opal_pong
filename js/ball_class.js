define(["global_constants", "global_variables"], function (gameConstants, gameVariables) {
    var Ball = function () {
        // Set the ball to the center of the field and make it stopped at the beginning.
        this.x = gameConstants.HORIZONTAL_CENTER_OF_FIELD;
        this.y = gameConstants.VERTICAL_CENTER_OF_FIELD;
        this.horizontalVelocity = gameConstants.STOPPED;
        this.verticalVelocity = gameConstants.STOPPED;
        // Draw the ball with the proper positions and dimensions.
        this.draw = function () {
            gameConstants.CONTEXT.beginPath();
            gameConstants.CONTEXT.arc(this.x, this.y, gameConstants.BALL_RADIUS, gameConstants.BALL_START_ANGLE, gameConstants.BALL_END_ANGLE);
            gameConstants.CONTEXT.fill();
        };
        // Update the ball's position depending on velocity. Also do collision detection for the ball.
        this.updatePosition = function (rightPaddle, leftPaddle) {
            this.x += this.horizontalVelocity / gameConstants.FPS;
            this.y += this.verticalVelocity / gameConstants.FPS;
            // -------------------- Start of ball collision code --------------------
            
            // Top wall collision.
            if ((this.y - gameConstants.BALL_RADIUS) < gameConstants.TOP_WALL) {
                this.y = gameConstants.BALL_RADIUS;
                this.verticalVelocity = -this.verticalVelocity;
            }
            
            // Bottom wall collision.
            if ((this.y + gameConstants.BALL_RADIUS) > gameConstants.BOTTOM_WALL) {
                this.y = gameConstants.BOTTOM_WALL - gameConstants.BALL_RADIUS;
                this.verticalVelocity = -this.verticalVelocity;
            }
            
            // Right paddle collison on the front side of the paddle.
            if ((this.x + gameConstants.BALL_RADIUS) > rightPaddle.x) {
                if (this.y > rightPaddle.y) {
                    if (this.y < (rightPaddle.y + rightPaddle.height)) {
                        this.x = rightPaddle.x - gameConstants.BALL_RADIUS;
                        this.horizontalVelocity = -this.horizontalVelocity;
                    }
                }
            }
            
            // Right paddle collision on the top side of the paddle.
            if ((this.x + gameConstants.BALL_RADIUS) > rightPaddle.x) {
                if ((this.y + gameConstants.BALL_RADIUS) > rightPaddle.y) {
                    if ((this.y + gameConstants.BALL_RADIUS) < (rightPaddle.y + rightPaddle.height)) {
                        this.y = rightPaddle.y - gameConstants.BALL_RADIUS;
                        this.verticalVelocity = -this.verticalVelocity;
                    }
                }
            }
            
            // Right paddle collision on the bottom side of the paddle.
            if ((this.x + gameConstants.BALL_RADIUS) > rightPaddle.x) {
                if ((this.y - gameConstants.BALL_RADIUS) < (rightPaddle.y + rightPaddle.height)) {
                    if ((this.y - gameConstants.BALL_RADIUS) > rightPaddle.y) {
                        this.y = (rightPaddle.y + rightPaddle.height) + gameConstants.BALL_RADIUS;
                        this.verticalVelocity = -this.verticalVelocity;
                    }
                }
            }
            
            // Left paddle collision on the front side of the paddle.
            if ((this.x - gameConstants.BALL_RADIUS) < (leftPaddle.x + leftPaddle.width)) {
                if (this.y > leftPaddle.y) {
                    if (this.y < (leftPaddle.y + leftPaddle.height)) {
                        this.x = (leftPaddle.x + leftPaddle.width) + gameConstants.BALL_RADIUS;
                        this.horizontalVelocity = -this.horizontalVelocity;
                    }
                }
            }
            
            // Left paddle collision on the top side of the paddle.
            if ((this.x - gameConstants.BALL_RADIUS) < (leftPaddle.x + leftPaddle.width)) {
                if ((this.y + gameConstants.BALL_RADIUS) > leftPaddle.y) {
                    if ((this.y + gameConstants.BALL_RADIUS) < (leftPaddle.y + leftPaddle.height)) {
                        this.y = leftPaddle.y - gameConstants.BALL_RADIUS;
                        this.verticalVelocity = -this.verticalVelocity;
                    }
                }
            }
            
            // Left paddle collision on the bottom side of the paddle.
            if ((this.x - gameConstants.BALL_RADIUS) < (leftPaddle.x + leftPaddle.width)) {
                if ((this.y - gameConstants.BALL_RADIUS) < (leftPaddle.y + leftPaddle.height)) {
                    if ((this.y - gameConstants.BALL_RADIUS) > leftPaddle.y) {
                        this.y = (leftPaddle.y + leftPaddle.height) + gameConstants.BALL_RADIUS;
                        this.verticalVelocity = -this.verticalVelocity;
                    }
                }
            }
            
            // ******************** End of ball collision code ********************
            
            // Restart at center when the ball leaves the field and score a point for the paddle that scored.
            
            // When the ball goes past the right paddle...
            if ((this.x - gameConstants.BALL_RADIUS) > gameConstants.RIGHT_WALL) {
                // ... restart at the center of the field and mark a point for the left paddle.
                this.x = gameConstants.HORIZONTAL_CENTER_OF_FIELD;
                this.y = gameConstants.VERTICAL_CENTER_OF_FIELD;
                leftPaddle.score++;
            }
            
            // When the ball goes past the left paddle...
            if ((this.x + gameConstants.BALL_RADIUS) < gameConstants.LEFT_WALL) {
                // ... restart at the center of the field and mark a point for the right paddle.
                this.x = gameConstants.HORIZONTAL_CENTER_OF_FIELD;
                this.y = gameConstants.VERTICAL_CENTER_OF_FIELD;
                rightPaddle.score++;
            }
        };
    };
    return Ball;
});