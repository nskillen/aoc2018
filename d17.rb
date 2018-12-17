require_relative 'day'
require 'io/console'

class D17 < Day

	WIDTH = 1000

	def wait
		puts "Press any key to continue..."
		STDIN.getch
	end

	def part_one

		min_x, min_y = Float::INFINITY, Float::INFINITY
		max_x, max_y = 0, 0
		clay_ranges = []

		@lines.each_with_index do |line,i|
			if /x=(?<x>\d+),\s+y=(?<y1>\d+)\.\.(?<y2>\d+)/ =~ line
				x = x.to_i
				y1 = y1.to_i
				y2 = y2.to_i

				min_x = x  if x < min_x
				max_x = x  if x > max_x
				min_y = y1 if y1 < min_y
				max_y = y1 if y1 > max_y
				min_y = y2 if y2 < min_y
				max_y = y2 if y2 > max_y
				
				ys = [y1,y2]

				clay_ranges << [x,(ys.min..ys.max)]
			elsif /y=(?<y>\d+),\s+x=(?<x1>\d+)\.\.(?<x2>\d+)/ =~ line
				y = y.to_i
				x1 = x1.to_i
				x2 = x2.to_i

				min_y = y  if y < min_y
				max_y = y  if y > max_y
				min_x = x1 if x1 < min_x
				max_x = x1 if x1 > max_x
				min_x = x2 if x2 < min_x
				max_x = x2 if x2 > max_x

				xs = [x1,x2]

				clay_ranges << [(xs.min..xs.max), y]
			else
				puts "Could not parse line: #{line}"
			end
		rescue => e
			puts e
			puts line
			require 'pry'
			binding.pry
		end

		# ranges are inclusive
		width = max_x - min_x + 1
		height = max_y - min_y + 1

		map = Array.new(height * WIDTH, ?.)
		map[0 * WIDTH + 500] = ?X

		#clay_ranges.each {|cr| puts cr.inspect}

		clay_ranges.each do |xs,ys|
			if xs.is_a?(Range)
				xs.each {|x| map[ys * WIDTH + x] = "#"}
			else
				ys.each {|y| map[y * WIDTH + xs] = "#"}
			end
		end

		open_drops = [[500,0]]
		drops = 0
		until open_drops.none?
			drop = open_drops.shift
			drops += 1

			x, y = drop # water source position

			#puts "Dropping water from #{x},#{y}"

			loop do 
				# find bottom of the drop
				# may be falling off the bottom of the map
				break if ["#",?~,?|].include?(map[(y+1) * WIDTH + x]) || (y+1) > max_y
				y += 1
				map[y * WIDTH + x] = ?|
			end

			if y <= max_y && ["#",?~].include?(map[(y+1) * WIDTH + x])
				# didn't drop off the bottom, so fill the bucket
				x_min, x_max = nil, nil
				left_is, right_is = nil, nil

				loop do
					# fill each row in the bucket
					# at some point the bucket could get narrower (center shaft, for example)
					# or one side can end, and we spill over

					x_min, x_max = x, x # water spreads horizontally on this row from this point
					left_is, right_is = :open, :open
					
					while left_is == :open do
						# find either the left edge of the bucket, or the point where we spill over, or the left edge of the map
						left_is = if map[(y+1) * WIDTH + x_min] == "#" && ![?~,"#"].include?(map[(y+1) * WIDTH + (x_min-1)])
									  :spillover
								  elsif map[y * WIDTH + (x_min - 1)] == "#"
									  :wall
								  elsif (x_min - 1) < 0
									  :map_edge
								  else
									  :open
								  end
						x_min -= 1 unless left_is == :wall
					end
					while right_is == :open do
						# find either the right edge of the bucket, or the point where we spill over, or the right edge of the map
						right_is = if map[(y+1) * WIDTH + x_max] == "#" && ![?~,"#"].include?(map[(y+1) * WIDTH + (x_max+1)])
									   :spillover
								   elsif map[y * WIDTH + x_max + 1] == "#"
									   :wall
								   elsif x_max  + 1 > WIDTH
									   :map_edge
								   else
									   :open
								   end
						x_max += 1 unless right_is == :wall
					end

					# record spillovers for future dropping
					if left_is == :spillover && x_min > 0
						map[y*WIDTH + x_min] = ?|
						open_drops << [x_min, y]
						#puts "spillover at #{x_min},#{y}"
					end
					if right_is == :spillover && x_max < WIDTH
						map[y*WIDTH + x_max] = ?|
						open_drops << [x_max, y]
						#puts "spillover at #{x_max},#{y}"
					end

					if left_is != :wall || right_is != :wall
						# fill the map on the spillover line or map-edge line
						(x_min..x_max).each {|x| map[y*WIDTH+x] = ?|}
						break
					elsif left_is == :wall && right_is == :wall
						# fill the bucket at this row
						(x_min..x_max).each {|x| map[y * WIDTH + x] = ?~}
						y -= 1
					end
				end
			end
		end

		print "     "
		((min_x - 10)..(max_x+10)).each do |x|
			print "0123456789"[x / 100]
		end
		print "\n     "
		((min_x - 10)..(max_x+10)).each do |x|
			print "0123456789"[(x / 10) % 10]
		end
		print "\n     "
		((min_x - 10)..(max_x+10)).each do |x|
			print "0123456789"[x % 10]
		end
		print "\n"

		map.each_slice(WIDTH).with_index do |row,i|
			puts "#{i.to_s.rjust(4)} #{row.join("")[(min_x-10)..(max_x+10)]}"
		end

		puts "total range is:"
		puts "(#{min_x},#{min_y}) to (#{max_x},#{max_y})"
		puts "width is #{max_x - min_x}"
		puts "height is #{max_y - min_y}"
		puts "There are #{map[(min_y*WIDTH)..-1].count{|s| [?~,?|].include?(s)}} spaces touched by water"
		puts "After the spring runs out there will be #{map.count{|c| c == ?~}} units of water left"
	end

	def part_two

	end

end
