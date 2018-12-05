require_relative 'day'
require 'pp'
require 'set'

class D3 < Day

  def part_one
    # 1354 @ 296,697: 21x10
    @fab = []
    @claims = {}
    @lines.each do |line|
      matches = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/.match line
      i = matches[1].to_i
      x = matches[2].to_i
      y = matches[3].to_i
      w = matches[4].to_i
      h = matches[5].to_i

      @claims[i] = w*h

      (y...y+h).each do |cy|
        @fab[cy] ||= []
        (x...x+w).each do |cx|
          if @fab[cy][cx].is_a?(Integer)
            @fab[cy][cx] = 'X'
          elsif @fab[cy][cx].nil?
            @fab[cy][cx] = i
          end
        end
      end
    end

    puts "There are #{@fab.flatten.select{|i| i == 'X'}.count} overlapping sq in"
  end

  def part_two
    flat = @fab.flatten
    @claims.each do |c,s|
      if flat.select{|v| v == c}.count == s
        puts "The only non-overlapping claim is #{c}"
        break
      end
    end
  end
end
