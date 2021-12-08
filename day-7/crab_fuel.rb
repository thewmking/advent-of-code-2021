# --- Day 7: The Treachery of Whales ---
require 'pry'

file = File.open('day-7/input.txt')
@file_data = file.readlines.map(&:chomp)
file.close

def init
  @crab_positions = @file_data.map { |n| n.split(',').map { |i| i.to_i } }.flatten
end

def calc_median(array)
  sorted, len = array.sort, array.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

def calc_fuel(position)
  (position - @median).abs()
end

init
fuel = 0
@median = calc_median(@crab_positions)
@crab_positions.each do |position|
  fuel += calc_fuel(position)
end

puts fuel # => 347449

# --- Part Two ---

def calc_fuel_usage(value, position)
  ((value - position).abs * ((value - position).abs + 1)) / 2
end

fuel = 0
fuel_amounts = []

min = @crab_positions.min
max = @crab_positions.max

(min...max).each do |position|
  @crab_positions.each do |value|
      fuel += calc_fuel_usage(value, position)
  end
  fuel_amounts << fuel
  fuel = 0
end

puts fuel_amounts.min # => 98039527
