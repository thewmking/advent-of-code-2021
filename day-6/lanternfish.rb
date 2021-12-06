# --- Day 6: Lanternfish ---
require 'pry'

file = File.open('day-6/input.txt')
@file_data = file.readlines.map(&:chomp)
file.close

def init(days)
  @days = days
  @fish = @file_data.map { |e| e.split(',').map { |n| n.to_i } }.flatten.tally
  key_opts = (0..8)
  key_opts.each do |opt|
    @fish[opt] = 0 if @fish[opt].nil?
  end
  @empty_fish_obj = Hash[key_opts.map {|k| [k, 0]}]
end

def age_fish_object(obj)
  new_obj = @empty_fish_obj.dup
  obj.each do |k,v|
    if k == 0
      new_obj[6] += v
      new_obj[8] += v
    else
      new_obj[k-1] += v
    end
  end
  @fish = new_obj
end

def simulate_fish(days)
  init(days)

  @days.times do
    age_fish_object(@fish)
  end

  @fish.values.sum
end

puts simulate_fish(80) # => 359999

# --- Part Two ---

puts simulate_fish(256) # => 1631647919273
