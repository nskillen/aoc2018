require_relative 'day'
require 'io/console'

class D20 < Day

	def wait
		puts "Press any key to continue..."
		STDIN.getch
	end

	WIDTH = 5000
	CENTER = 2500

	R = Struct.new(:pieces,:choices,:parent)

	def connected_rooms(map,x,y)
		rooms = []
		[-1,1].each do |off|
			if x + off >= 0 && x + off < WIDTH && map[y * WIDTH + x + off] == ?|
				rooms << [x+(2*off),y]
			end
			if y + off >= 0 && y + off < WIDTH && map[(y + off) * WIDTH + x] == ?-
				rooms << [x, y+(2*off)]
			end
		end
		rooms.map{|r| [[x,y],r]}
	end

	def flood(map,x,y)
		rooms_to_check = connected_rooms(map,x,y)
		routes = {[x,y] => {from: nil, dist: 0}}

		while rooms_to_check.any?
			from,room = rooms_to_check.shift
			if !routes.key?(room)
				routes[room] = {from: from, dist: routes[from][:dist] + 1}
				rooms_to_check += connected_rooms(map,*room)
			end
		end

		routes
	end

	def part_one
		base = Array.new(WIDTH * WIDTH, ?#)
		x, y = CENTER, CENTER
		base[y * WIDTH + x] = ?X

		group_starts = []

		@input.chars.each_with_index do |c,i|
			next if c == ?^
			break if c == ?$

			case c
			when ?( then group_starts << [x,y]
			when ?) then group_starts.pop
			when ?| then x, y = group_starts.last
			when ?N
				y -= 1
				base[y * WIDTH + x] = ?-
				y -= 1
				base[y * WIDTH + x] = ?.
			when ?S
				y += 1
				base[y * WIDTH + x] = ?-
				y += 1
				base[y * WIDTH + x] = ?.
			when ?E
				x += 1
				base[y * WIDTH + x] = ?|
				x += 1
				base[y * WIDTH + x] = ?.
			when ?W
				x -= 1
				base[y * WIDTH + x] = ?|
				x -= 1
				base[y * WIDTH + x] = ?.
			else raise "Unexpected character: #{c} at index #{i}"
			end
		end

		base.map!{|c| c == ?? ? ?# : c}

		routes = flood(base,CENTER,CENTER)
		puts "The shortest max path is #{routes.values.map{|r| r[:dist]}.max}"
		puts "The number of rooms at least 1000 doors away from the origin is #{routes.values.select{|r| r[:dist] >= 1000}.size}"
	end

	def part_two

	end

end
