require_relative 'day'

class D11 < Day

	INPUT = 8444

	def power_at(x,y)
		rack_id = x + 10
		pl = rack_id * y
		pl += INPUT
		pl *= rack_id
		pl = (pl / 100) % 10
		pl - 5
	end

	def print_region(x,y)
		puts "Region at (#{x},#{y}):"
		(-1...4).each do |y_off|
			(-1...4).each do |x_off|
				print "#{power_at(x+x_off,y+y_off).to_s.rjust(3)} "
			end
			print "\n"
		end
	end

	def part_one
		plev = 0
		mx, my = [0,0]
		(1...299).each do |y|
			(1...299).each do |x| 
				p = power_at(x+0,y+0) + power_at(x+1,y+0) + power_at(x+2,y+0)+
				    power_at(x+0,y+1) + power_at(x+1,y+1) + power_at(x+2,y+1)+
				    power_at(x+0,y+2) + power_at(x+1,y+2) + power_at(x+2,y+2)
				    
				if (p > plev)
					plev = p
					mx, my = x, y
				end
			end
		end

		print_region(mx,my)

		puts "The max power is at (#{mx},#{my}) and is #{plev} units"
	end

	def sum_pow(x,y,s)
		p = 0
		(0...s).each do |y_off|
			(0...s).each do |x_off|
				p += @plevs[(y + y_off) * 300 + x + x_off]
			end
		end
		p
	end

	def part_two
		@plevs = Array.new(300 * 300, 0)
		(0...300).each do |y|
			(0...300).each do |x|
				@plevs[y * 300 + x] = power_at(x,y)
			end
		end

		memo = {}

		mp,mx,my,ms = 0,0,0,0
		(1..300).each do |s|
			ss = 0
			memo.keys.select{|k| k <= (s/2)}.sort.reverse.each do |k|
				if s % k == 0
					ss = k
					break
				end
			end
			memo[s] = {} if s > 1
			puts "Initial population on squares of size #{s}" if s < 4
			puts "Using subsquares of size #{ss} for squares of size #{s}" if ss > 0
			puts "Special prime case on size #{s}" if s >= 4 && ss==0
			(0..(300-s)).each do |y|
				(0..(300-s)).each do |x|
					p=0
					if ss > 0 && s > 1
						(0...(s/ss)).each do |sy|
							(0...(s/ss)).each do |sx|
								p += memo[ss][[x+(ss*sx),y+(ss*sy)]]
							end
						end
					elsif s < 4
						p = sum_pow(x,y,s)
					else
						# s is prime
						p = memo[s-1][[x,y]]
						(y...(y+s)).each do |yy|
							p += @plevs[yy * 300 + x + (s-1)]
						end
						(x...(x+s-1)).each do |xx|
							p += @plevs[(y+s-1) * 300 + xx]
						end
					end
					memo[s][[x,y]] = p if s > 1
					if p > mp
						mp,mx,my,ms = p,x,y,s
					end
				end
			end
		end
		puts "The max power is #{mx},#{my},#{ms} @ #{mp} units"
	end

end
