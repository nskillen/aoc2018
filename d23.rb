require_relative 'day'
require 'io/console'
require 'set'

class D23 < Day

  Nanobot = Struct.new(:p,:r) do
    def in_range_of other
      p.dist_to(other.p) <= other.r
    end

    def point_in_common? other
      p.dist_to(other.p) <= r + other.r
    end
  end

  P3 = Struct.new(:x,:y,:z) do
    def dist_to other
      (x - other.x).abs + (y - other.y).abs + (z - other.z).abs
    end

    def to_s
      "P{x: #{self.x}, y: #{self.y}, z: #{self.z}}"
    end
  end

	def wait
		puts "Press any key to continue..."
		STDIN.getch
	end

	def part_one
    @nanobots = []
    @lines.each do |l|
      if /pos=<(?<x>-?\d+),(?<y>-?\d+),(?<z>-?\d+)>, r=(?<r>-?\d+)/ =~ l
        @nanobots << Nanobot.new(P3.new(x.to_i, y.to_i, z.to_i), r.to_i)
      end
    end

    raise "Nanobot count mismatch (e: #{@lines.size}, a: #{@nanobots.size})" if @lines.size != @nanobots.size

    strongest = @nanobots.max{|n1,n2| n1.r <=> n2.r}
    in_range = @nanobots.select{|n| n.in_range_of(strongest)}

    puts in_range.size
	end

	def part_two
    nanobots_selected = @nanobots
    loop do
      c = {}
      nanobots_selected.each do |n|
        nir = nanobots_selected.count{|nn| nn.point_in_common?(n)}
        c[nir] ||= []
        c[nir] << n
      end
      break if c[c.keys.min] == nanobots_selected
      nanobots_selected = nanobots_selected - c[c.keys.min]
    end

    origin = P3.new(0,0,0)
    puts nanobots_selected.map{|n| n.p.dist_to(origin) - n.r}.max
	end

end
