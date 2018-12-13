require_relative 'day'
require 'io/console'

class D10 < Day

	V = Struct.new(:x,:y)
	P = Struct.new(:p,:v) do
		def <=> other
			if self.p.y == other.p.y
				self.p.x <=> other.p.x
			else
				self.p.y <=> other.p.y
			end
		end
	end

	def get_bounds(points)
		left = points.map(&:p).map(&:x).min
		top = points.map(&:p).map(&:y).min

		width = points.map(&:p).map(&:x).max - left
		height = points.map(&:p).map(&:y).max - top

		[left, top, width, height]
	end

	def print_image(points)
		sorted = points.sort
		row = sorted.first.p.y
		l,t,w,h = get_bounds(points)
		line = "." * w
		sorted.each do |p|
			if p.p.y > row
				puts line
				row += 1
				line = "." * w
			end
			if p.p.y == row
				line[p.p.x - l] = "#"
			end
		end
		puts line
	end

	def update(points)
		[].tap do |new_points|
			points.each do |p|
				new_points<< P.new(V.new(p.p.x + p.v.x, p.p.y + p.v.y), p.v)
			end
		end
	end

	def wait
		puts "press any key"
		STDIN.getch
	end
		


	def part_one
		points = []
		@lines.each do |line|
			m = /position=<([- ]\d+), ([- ]\d+)> velocity=<([- ]\d+), ([- ]\d+)>/.match(line)
			puts m.inspect
			pos = V.new(*m[1..2].map(&:strip).map(&:to_i))
			vel = V.new(*m[3..4].map(&:strip).map(&:to_i))
			puts pos
			puts vel
			points << P.new(pos,vel)
		end

		old_area = nil
		area = nil
		i = 1 
		
		10710.times { points = update(points) }
		print_image points

		#loop do
		#	new_points = update(points)
		#	bounds = get_bounds(new_points)
		#	narea = bounds[2] * bounds[3]
		#	if area && narea < area
		#		puts "#{i}: #{narea}"
		#	end
		#	area = narea
		#	i += 1
		#	#if !area
		#	#	area = bounds[2] * bounds[3]
		#	#else
		#	#	narea = bounds[2] * bounds[3]
		#	#	if narea < 1000 && narea >= area && old_area && area <= old_area
		#	#		print_image(points)
		#	#		break if wait == "q"
		#	#	end
		#	#	old_area = area
		#	#	area = narea
		#	#end
		#	points = new_points
		#end
	end

	def part_two

	end

end
