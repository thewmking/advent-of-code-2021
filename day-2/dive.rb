 # --- Day 2: Dive! ---

file = File.open('day-2/input.txt')
file_data = file.readlines.map(&:chomp)
file.close

# forward X increases the horizontal position by X units.
# down X increases the depth by X units.
# up X decreases the depth by X units.

# x = horizontal position
# y = vertical position
@x,@y = 0,0

def move_forward(increment)
  @x += increment
end

def move_down(increment)
  @y += increment
end

def move_up(increment)
  @y -= increment
end

moves = file_data.map { |i| i.split(' ') }

moves.each do |direction, increment|
  increment = increment.to_i
  case direction
  when 'forward'
    move_forward(increment)
  when 'down'
    move_down(increment)
  when 'up'
    move_up(increment)
  end
end

# What do you get if you multiply your final horizontal position by your final depth?
puts @x * @y # => 1815044
