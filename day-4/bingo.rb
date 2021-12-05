# --- Day 4: Giant Squid ---
require 'pry'

file = File.open('day-4/input.txt')
@file_data = file.readlines.map(&:chomp)
file.close

# The submarine has a bingo subsystem to help passengers (currently,
# you and the giant squid) pass the time. It automatically generates a random
# order in which to draw numbers and a random set of boards (your puzzle input).

# The score of the winning board can now be calculated. Start by finding the sum
# of all unmarked numbers on that board; Then, multiply that sum by the number
# that was just called when the board won to get the final score.

def init_bingo
  set_bingo_numbers
  set_drawn_numbers
  set_winner
  set_boards
end

def set_bingo_numbers
  @bingo_numbers = @file_data[0].split(',')
end

def set_drawn_numbers
  @drawn_numbers = []
end

def set_winner
  @winner = nil
end

# split input rows into board groups

def set_boards
  @boards = []
  boards_index = 0
  @file_data[1..-1].each do |row|
    next if row.empty?
    boards_index += 1 if @boards[boards_index]&.length == 5

    if @boards[boards_index].nil?
      @boards[boards_index] = [row.split(' ')]
    else
      @boards[boards_index] << row.split(' ')
    end
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

init_bingo

@bingo_numbers.length.times do |num|
  break if !@winner.nil?
  draw_number
  next if @drawn_numbers.length < 5
  @boards.each do |board|
    win = check_board(board)
    next if !win
    @winner = board
    break
  end
end

# To guarantee victory against the giant squid, figure out which board will win first.
# What will your final score be if you choose that board?

if !@winner.nil?
  unmarked_sum = array_difference(@winner.flatten).map { |n| n.to_i  }.sum
  last_drawn = @drawn_numbers[-1].to_i
  puts unmarked_sum * last_drawn # => 72770
end

# --- Part Two ---
# On the other hand, it might be wise to try a different strategy: let the giant squid win.
#
# You aren't sure how many bingo boards a giant squid could play at once, so
# rather than waste time counting its arms, the safe thing to do is to figure out
# which board will win last and choose that one. That way, no matter which boards
# it picks, it will win for sure.

# Figure out which board will win last. Once it wins, what would its final score be?

init_bingo

@winners = {}

@bingo_numbers.count.times do |num|
  break if @boards.empty?
  draw_number
  next if @drawn_numbers.length < 5
  @boards.each_with_index do |board, index|
    win = check_board(board)
    next if !win
    @boards.delete_at(index)
    @winners[@drawn_numbers[-1]] = board
  end
end

last_drawn = @winners.keys.last
@winner = @winners[last_drawn]
unmarked_sum = array_difference(@winner.flatten).map { |n| n.to_i  }.sum
puts unmarked_sum * last_drawn.to_i # =>
