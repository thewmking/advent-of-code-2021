 # --- Day 2: Dive! ---

file = File.open('day-2/input.txt')
file_data = file.readlines.map(&:chomp)
file.close

# down X increases your aim by X units.
# up X decreases your aim by X units.
# forward X does two things:
  # It increases your horizontal position by X units.
  # It increases your depth by your aim multiplied by X.

# x = horizontal position
# y = vertical position (depth)
# a = aim

@x,@y,@a = 0,0,0

def move_forward(increment)
  @x += increment
  depth_change = (increment * @a)
  @y += depth_change if depth_change != 0
end

def aim_down(increment)
  @a += increment
end

def aim_up(increment)
  @a -= increment
end

moves = file_data.map { |i| i.split(' ') }

moves.each do |direction, increment|
  increment = increment.to_i
  case direction
  when 'forward'
    move_forward(increment)
  when 'down'
    aim_down(increment)
  when 'up'
    aim_up(increment)
  end
end

# What do you get if you multiply your final horizontal position by your final depth?
puts @x * @y # => 1739283308
