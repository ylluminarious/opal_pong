define(function () {
    var gameVariables = {
        // Game is not paused when it starts
        paused: false,
        // Game starts out in opening scene
        whichGame: "opening scene",
        // Starting color is gray
        color: "gray",
        // Both players start out with a score of 0
        score: 0
    };
    return gameVariables;
});