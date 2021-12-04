# --- Day 3: Binary Diagnostic ---

file = File.open('day-3/input.txt')
@file_data = file.readlines.map(&:chomp)
file.close

# You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate).
# The power consumption can then be found by multiplying the gamma rate by the epsilon rate.
#
# Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report.
# The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used.
@gamma, @epsilon = [], []

def binary_to_decimal(binary)
  binary.to_i(2)
end


def data_by_column(data)
  data_by_column = []

  # group array data by index into new object
  data.each do |row|
    row.split('').each_with_index do |val, i|
      if data_by_column[i].nil?
        data_by_column[i] = [val]
      else
        data_by_column[i] << val
      end
    end
  end

  data_by_column
end

def min_max(values)
  values.minmax_by{ |v| values.count(v) }
end


data_by_column(@file_data).each do |values|
  e, g = min_max(values)
  @gamma << g
  @epsilon << e
end

g_dec = binary_to_decimal(@gamma.join)
e_dec = binary_to_decimal(@epsilon.join)

puts g_dec * e_dec # => 4160394

# Part 2

# Next, you should verify the life support rating, which can be determined by
# multiplying the oxygen generator rating by the CO2 scrubber rating.

# The bit criteria depends on which type of rating value you want to find:
# To find oxygen generator rating, determine the most common value (0 or 1)
   # in the current bit position, and keep only numbers with that bit in that position.
   # If 0 and 1 are equally common, keep values with a 1 in the position being considered.
# To find CO2 scrubber rating, determine the least common value (0 or 1)
   # in the current bit position, and keep only numbers with that bit in that position.
   # If 0 and 1 are equally common, keep values with a 0 in the position being considered.

# Keep only numbers selected by the bit criteria for the type of rating value for which you are searching.
# Discard numbers which do not match the bit criteria.
# If you only have one number left, stop; this is the rating value for which you are searching.
# Otherwise, repeat the process, considering the next bit to the right.


def find_by_criteria(column_data, raw_data, index, default_keeper)
  values = column_data[index]
  e, g = min_max(values)
  
  # if min == max, use 1, otherwise use max
  keep_value = default_keeper == '1' ? g : e
  keeper = (e == g) ? default_keeper : keep_value

  # filter data down to match keeper
  filtered_data = raw_data.select { |v| v[index] == keeper }
  return filtered_data[0] if filtered_data.length == 1

  find_by_criteria(data_by_column(filtered_data), filtered_data, index+1, default_keeper)
end

ox = find_by_criteria(data_by_column(@file_data), @file_data, 0, '1')
co2 = find_by_criteria(data_by_column(@file_data), @file_data, 0, '0')

ox_dec = binary_to_decimal(ox)
co2_dec = binary_to_decimal(co2)

puts ox_dec * co2_dec # => 4125600
