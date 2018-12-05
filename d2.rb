require_relative 'day'
require 'rubygems/text'

class D2 < Day

  def part_one
    twos = 0
    threes = 0

    @input.split("\n").each do |line|
      char_nums = line.chars
        .group_by(&:itself)
        .transform_values(&:count)
        .values.uniq
      twos += 1 if char_nums.include?(2)
      threes += 1 if char_nums.include?(3)
    end
    puts twos * threes
  end

  def part_two
    ld = Class.new.extend(Gem::Text).method(:levenshtein_distance)

    @input.split("\n").sort.each_cons(2) do |a,b|
      if ld.call(a,b) == 1
        puts a
        puts b
        break
      end
    end
  end
end
