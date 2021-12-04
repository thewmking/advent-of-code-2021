# --- Day 3: Binary Diagnostic ---

file = File.open('day-3/input.txt')
file_data = file.readlines.map(&:chomp)
file.close

# You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate).
# The power consumption can then be found by multiplying the gamma rate by the epsilon rate.
#
# Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report.
# The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used.
@gamma, @epsilon = [], []

def binary_to_float(binary)
  binary.to_i(2)
end

data_by_column = []

# group array data by index into new object
file_data.each do |row|
  row.split('').each_with_index do |val, i|
    if data_by_column[i].nil?
      data_by_column[i] = [val]
    else
      data_by_column[i] << val
    end
  end
end

data_by_column.each do |values|
  # gets min and max at once
  e, g = values.minmax_by{ |i| values.count(i) }
  @gamma << g
  @epsilon << e
end

g_float = binary_to_float(@gamma.join)
e_float = binary_to_float(@epsilon.join)

puts g_float * e_float # => 4160394
