# --- Day 4: Giant Squid ---
require 'pry'

file = File.open('day-4/input.txt')
file_data = file.readlines.map(&:chomp)
file.close

# The submarine has a bingo subsystem to help passengers (currently,
# you and the giant squid) pass the time. It automatically generates a random
# order in which to draw numbers and a random set of boards (your puzzle input).

# The score of the winning board can now be calculated. Start by finding the sum
# of all unmarked numbers on that board; Then, multiply that sum by the number
# that was just called when the board won to get the final score.

@bingo_numbers = file_data.shift.split(',')

# split input rows into board groups
boards = []
boards_index = 0
file_data.each do |row|
  next if row.empty?
  boards_index += 1 if boards[boards_index]&.length == 5

  if boards[boards_index].nil?
    boards[boards_index] = [row.split(' ')]
  else
    boards[boards_index] << row.split(' ')
  end
end

# grab data_by_column method from day 3
def data_by_column(data)
  data_by_column = []

  # group array data by index into new array
  data.each do |row|
    row.each_with_index do |val, i|
      if data_by_column[i].nil?
        data_by_column[i] = [val]
      else
        data_by_column[i] << val
      end
    end
  end

  data_by_column
end

@drawn_numbers = []
@winner = nil

def draw_number
  @drawn_numbers << @bingo_numbers.shift
end

def array_difference(array)
  array - @drawn_numbers
end

def check_board(board)
  win = false

  board.each do |row|
    win ||= array_difference(row).empty?
  end

  data_by_column(board).each do |column|
    win ||= array_difference(column).empty?
  end

  win
end

def winning_board(board)
  check_board(board)
end

@bingo_numbers.length.times do |num|
  break if !@winner.nil?
  draw_number
  next if @drawn_numbers.length < 5
  boards.each do |board|
    win = check_board(board)
    next if !win
    @winner = board
    break
  end
end

if !@winner.nil?
  unmarked_sum = array_difference(@winner.flatten).map { |n| n.to_i  }.sum
  last_drawn = @drawn_numbers[-1].to_i
  puts unmarked_sum * last_drawn # => 72770
end
