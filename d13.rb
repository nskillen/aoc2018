require_relative 'day'
require 'io/console'

# Saw the suggestions to use complex numbers on the reddit thread for the day
# Still didn't get it right the first time, because the turn changes direction
# based on where you're coming from. Still, the literal syntax is handy here.
#
# The ?c syntax is something I wasn't aware of before that really cleaned things
# up. Another useful trick I saw was the way to read in the carts and replace
# their characters in the map.
#
# Yet another syntax trick I discovered is the way that the spaceship operator
# compares pairs of arrays (element-by-element), sending back the result of the
# first non-zero comparison, or 0 if all are equal.

class D13 < Day

	C = Struct.new(:x,:y,:v,:t,:alive) do
		def <=> other
			[self.y,self.x] <=> [other.y,other.x]
		end

		def move(map)
			self.x += self.v.real
			self.y += self.v.imag

			h = self.v.real != 0

			case [h,map[self.y][self.x]]
			when [true,?/], [false, ?\\] then self.v *= -1i # CCW rotation
			when [false,?/], [true, ?\\] then self.v *=  1i # CW rotation
			when [true,?+], [false,?+]
				case self.t % 3
				when 0 then self.v *= -1i
				when 1 then # noop
				when 2 then self.v *=  1i
				end
				self.t += 1
			end
		end
	end

	def part_one
		carts = []
		map = @lines.map.with_index do |l,y|
			l.chars.map.with_index do |c,x|
				case c
				when ?v then carts << C.new(x,y,( 0+1i),0,true); ?|
				when ?^ then carts << C.new(x,y,( 0-1i),0,true); ?|
				when ?< then carts << C.new(x,y,(-1+0i),0,true); ?-
				when ?> then carts << C.new(x,y,( 1+0i),0,true); ?-
				else c
				end
			end
		end

		collision = nil
		loop do
			carts.sort!
			carts.each do |cart|
				next unless cart.alive
				cart.move(map)
				collided = carts.select{|c| c != cart && c.alive && c.x == cart.x && c.y == cart.y}
				if collided.any?
					cart.alive = false
					collision = [cart.x,cart.y] unless collision
					collided.each {|c| c.alive = false}
					puts "There are now #{carts.count(&:alive)} carts left alive"
				end
			end
			break if carts.count(&:alive) <= 1
		end

		a = carts.detect(&:alive)

		puts "The first collision happens at #{collision}"
		puts "The last cart left is #{a}" if a
	end

	def part_two

	end

end
