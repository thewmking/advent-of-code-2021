# --- Day 5: Hydrothermal Venture ---
require 'pry'

file = File.open('day-5/input.txt')
@file_data = file.readlines.map(&:chomp)
file.close

# You come across a field of hydrothermal vents on the ocean floor!
# These vents constantly produce large, opaque clouds, so it would be best to
# avoid them if possible.

# Each line of vents is given as a line segment in the format:
# x1,y1 -> x2,y2
# where x1,y1 are the coordinates of one end the line segment and
# x2,y2 are the coordinates of the other end.

# These line segments include the points at both ends. In other words:
# - An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
# - An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.
# For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.

# So, the horizontal and vertical lines from the above list would produce the following diagram:

# .......1..
# ..1....1..
# ..1....1..
# .......1..
# .112111211
# ..........
# ..........
# ..........
# ..........
# 222111....

# In this diagram, the top left corner is 0,0 and the bottom right corner is 9,9.
# Each position is shown as the number of lines which cover that point
# or `.` if no line covers that point.

# The top-left pair of 1s, for example, comes from 2,2 -> 2,1;
# the very bottom row is formed by the overlapping lines 0,9 -> 5,9 and 0,9 -> 2,9.

# To avoid the most dangerous areas, you need to determine the number of points
# where at least two lines overlap. In the above example, this is anywhere in the
# diagram with a 2 or larger - a total of 5 points.

# Consider only horizontal and vertical lines. At how many points do at least two lines overlap?

def parse_input
  @coordinate_pairs = @file_data.map { |row| row.split(' -> ').map { |coord| coord.split(',').map { |i| i.to_i } } }
  end

def get_columns # x coordinate
  @coordinate_pairs.map{|set| set.map{|coord| coord[0]}}.flatten.max.to_i + 1
end

def get_rows # y coordinate
  @coordinate_pairs.map{|set| set.map{|coord| coord[1]}}.flatten.max.to_i + 1
end

def build_matrix
  @rows = get_rows
  @columns = get_columns
  @matrix = Array.new(@columns) { Array.new(@rows) {0} }
end

def calculate_path(pair)
  # lifted from my ruby chess game for calulating the path of a queen
  # https://github.com/thewmking/ruby-chess/blob/master/lib/chess/queen.rb
  range = (0..(@columns-1))
  path_coordinates = [pair[0], pair[1]]

  start_col, start_row = pair[0]
  end_col, end_row = pair[1]

  x, y = (end_col - start_col), (end_row - start_row)

  if (x != 0 && y != 0) && (x.abs == y.abs)
    i = x.abs/x
    j = y.abs/y
    (x.abs - 1).times do
      path_coordinates << [start_col + i, start_row + j] if range.include?(start_col + i) && range.include?(start_row + j)
      i += 1 if x > 0
      i -= 1 if x < 0
      j += 1 if y > 0
      j -= 1 if y < 0
    end
  elsif x != 0
    i = x.abs/x
    (x.abs - 1).times do
      path_coordinates << [start_col + i, start_row] if range.include?(start_col + i)
      i += 1 if x > 0
      i -= 1 if x < 0
    end
  elsif y != 0
    j = y.abs/y
    (y.abs - 1).times do
      path_coordinates << [start_col, start_row + j] if range.include?(start_row + j)
      j += 1 if y > 0
      j -= 1 if y < 0
    end
  end

  path_coordinates.uniq
end

def add_coordinate_pair(pair)
  path_coordinates = calculate_path(pair)
  path_coordinates.each do |coord|
    x, y = coord
    @matrix[y][x] += 1
  end
end

def pair_valid?(pair)
  # For now, only consider horizontal and vertical lines:
  # lines where either x1 = x2 or y1 = y2.
  (pair[0][0] == pair[1][0]) || (pair[0][1] == pair[1][1])
end

def count_danger_zones
  zones = 0
  @matrix.each do |row|
    row.each do |cell|
      zones += 1 if cell >= 2
    end
  end
  zones
end

parse_input
build_matrix

@coordinate_pairs.each do |pair|
  if pair_valid?(pair)
    add_coordinate_pair(pair)
  end
end

count_danger_zones

puts count_danger_zones # => 6572

# --- Part Two ---
# Unfortunately, considering only horizontal and vertical lines doesn't give you
# the full picture; you need to also consider diagonal lines.

# Because of the limits of the hydrothermal vent mapping system, the lines in your
# list will only ever be horizontal, vertical, or a diagonal line at exactly 45 degrees.
# In other words:

# - An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
# - An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.

def valid_diagonal_path(origin)
  # also lifted from my ruby chess game
  range = (0..(@columns-1))
  col, row = origin
  path_coordinates = []

  i = 0
  until i == @columns-1
    path_coordinates << [col - i, row - i] if range.include?(col - i) && range.include?(row - i)
    path_coordinates << [col - i, row + i] if range.include?(col - i) && range.include?(row + i)
    path_coordinates << [col + i, row + i] if range.include?(col + i) && range.include?(row + i)
    path_coordinates << [col + i, row - i] if range.include?(col + i) && range.include?(row - i)
    i += 1
  end

  path_coordinates
end

def pair_valid_diagonal?(pair)
  valid_coords = valid_diagonal_path(pair[0])
  valid_coords.include? pair[1]
end


build_matrix # again for round 2

@coordinate_pairs.each do |pair|
  if pair_valid?(pair) || pair_valid_diagonal?(pair)
    add_coordinate_pair(pair)
  end
end

puts count_danger_zones # => 21466
