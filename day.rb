class Day

  class P < Struct.new(:x,:y)
    def <=> other
      [self.y,self.x] <=> [other.y,other.x]
    end

		def == other
			return false unless other.is_a?(P)
			self.y == other.y && self.x == other.x
		end

    def to_s
      "(#{x},#{y})"
    end

  end

  def initialize(input)
    @input = input
    @lines = input.split("\n")
  end

  def part_one
    raise "Please redefine part_one in your per-day class"
  end

  def part_two
    raise "Please redefine part_two in your per-day class"
  end

end
