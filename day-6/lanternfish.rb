# --- Day 6: Lanternfish ---
require 'pry'

file = File.open('day-6/input.txt')
@file_data = file.readlines.map(&:chomp)
file.close

def init
  @days = 80
  @fish = @file_data.map { |e| e.split(',').map { |n| n.to_i } }.flatten
end

def age_fish(fish, index)
  if fish == 0
    fish = 6
    @new_fish_array << 8
  else
    fish -= 1
  end
  @aged_fish_array[index] = fish
end

init

@days.times do
  @aged_fish_array = []
  @new_fish_array = []
  @fish.each_with_index do |f, i|
    age_fish(f, i)
  end
  @fish = @aged_fish_array + @new_fish_array
end

puts @fish.length # => 359999
