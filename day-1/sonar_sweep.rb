# --- Day 1: Sonar Sweep ---

file = File.open('day-1/input.txt')
values = file.readlines.map(&:chomp)
file.close

values.map! { |v| v.to_i }

def measure_increases(values)
  increased_indices = []

  values.each_with_index do |v, i|
    next if i == 0
    increased_indices << i if (values[i] > values[i-1])
  end

  increased_indices
end


# part 1
# How many measurements are larger than the previous measurement?
measurements = measure_increases(values)
puts measurements.length # => 1215


# part 2
# Consider sums of a three-measurement sliding window.
# How many sums are larger than the previous sum?

sums = []
values.each_with_index do |v, i|
  # grab the sums of each set of 3
  if !values[i+2].nil?
    sums << (values[i] + values[i+1] + values[i+2])
  end
end

increased_sums = measure_increases(sums)
puts increased_sums.length # => 1150
