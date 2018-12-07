require_relative 'day'

P = Struct.new(:x,:y,:num) do
	def distance_to x, y
		xs = [self.x,x]
		ys = [self.y,y]
		(xs.max - xs.min).abs + (ys.max - ys.min).abs
	end
end

class D6 < Day

	def closest_to x, y
		candidate, spoiler = @points.map{|p| [p,p.distance_to(x,y)]}.sort{|p1,p2| p1.last <=> p2.last}.take(2)
		if candidate.last == spoiler.last
			return nil
		elsif candidate.last > spoiler.last
			raise "WTF?! #{candidate} vs #{spoiler}"
		else
			return candidate.first
		end
	end

	def part_one
		@points = []
		@lines.each_with_index do |l,i|
			@points << P.new(*l.split(", ").map(&:to_i), i)
		end

		left = @points.map(&:x).min
		right = @points.map(&:x).max
		top = @points.map(&:y).min
		bottom = @points.map(&:y).max

		width = right - left + 1
		height = bottom - top + 1

		@fa_points = @points.reject{|p| p.x == left || p.x == right || p.y == top || p.y == bottom}
		rejected = @points - @fa_points
		puts "There are #{@fa_points.size} points with a finite area"
		puts "The following points define the edges:"
		rejected.each{|r| puts r}
		puts "The box is bounded at #{left} #{right} #{top} #{bottom}"
		puts "The area inside the box is #{width*height}"
		space = []

		(0...height).each do |y|
			(0...width).each do |x|
				closest = closest_to(x + left, y + top)
				space[y * width + x] = closest ? closest.num : nil
			end
		end

		edge_hits = []
		(0...height).each do |y|
			edge_hits << space[y * width]
			edge_hits << space[(y+1) * width - 1]
		end
		(0...width).each do |x|
			edge_hits << space[x]
			edge_hits << space[(height-1)*width + x]
		end

		edge_hits = edge_hits.compact.sort.uniq

		chars = ('a'..'z').to_a + ('A'..'Z').to_a
		(0...height).each do |y|
			(0...width).each do |x|
				v = space[y * width + x]
				if v
					print chars[v]
				else
					print '.'
				end
			end
			print "\n"
		end

		space.compact!
		largest_finite_space = space.reject{|k,v| edge_hits.include?(k)}.group_by(&:itself).transform_values(&:count).values.max
		largest = space.group_by(&:itself).detect{|k,v| v.size == largest_finite_space}.first
		puts "The largest finite space is #{largest_finite_space} and is represented by #{chars[largest]}"
	end

	def part_two
		left = @points.map(&:x).min
		right = @points.map(&:x).max
		top = @points.map(&:y).min
		bottom = @points.map(&:y).max

		width = right - left + 1
		height = bottom - top + 1

		spaces = []
		#((top - 200)...(bottom + 200)).each do |_y|
	#		((left - 200)...(right + 200)).each do |_x|
		(0...height).each do |y|
			(0...width).each do |x|
				#x = _x - (left-200)
				#y = _y - (top-200)
				spaces[y * width + x] = @points.map{|p| p.distance_to(x+left,y+top)}.reduce(0, &:+) < 10000
			end
		end
		chars = ('a'..'z').to_a + ('A'..'Z').to_a
		(0...height).each do |y|
			(0...width).each do |x|
				v = spaces[y * width + x]
				p = @points.detect{|p| p.x == left + x && p.y == top + y}
				if p
					print chars[p.num]
				elsif v
					print '#'
				else
					print '.'
				end
			end
			print "\n"
		end

		puts "The safe region is #{spaces.select(&:itself).size} spaces in size"
	end

end
