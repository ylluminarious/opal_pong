puts "test"
class Paddle
  def initialize (x_pos, y_pos)
    @x = x_pos
    @y = y_pos
  end
  def draw
    @context = `document.getElementById("playing_field").getContext("2d")`
    `@context.fillStyle = "white"`
    `@context.fillRect(@x, @y, 40, 40)`
  end
end