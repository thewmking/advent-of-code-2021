# --- Day 4: Giant Squid ---
require 'pry'

file = File.open('day-4/input-sample.txt')
file_data = file.readlines.map(&:chomp)
file.close

bingo_numbers = file_data.shift;

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
