require_relative 'day'
require 'set'

class D1 < Day

  def part_one
    puts @lines.reduce(0) {|total,adj| total += adj.to_i}
  end

  def part_two
    total = 0
    seen = Set.new
    found_repeat = false
    loop do
      break if found_repeat
      for adj in @lines.map(&:to_i)
        break if found_repeat
        total += adj.to_i
        if seen.include?(total)
          found_repeat = true
        else
          seen.add(total)
        end
      end
    end
    puts total
  end

end
