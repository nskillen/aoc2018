require_relative 'day'
require 'io/console'

class D15 < Day
	def wait
		puts "press any key"
		STDIN.getch
	end

	P = Struct.new(:x,:y) do
		def <=> other
			[self.y,self.x] <=> [other.y,other.x]
		end

		def == other
			return false unless other.is_a?(P)
			self.y == other.y && self.x == other.x
		end

		def to_s
			"(#{self.x},#{self.y}"
		end
	end

	class Map
		def initialize(data,units)
			@data = data
			@units = units.sort
		end

		def print
			@data.each_with_index do |line,i|
				str = line.join("")
				@units.select{|u| u.a && u.p.y == i}.each do |u|
					str[u.p.x] = u.t == :goblin ? ?G : ?E
				end
				puts str
			end
		end

		def walkable?(p)
			@data[p.y][p.x] == '.' && @units.none?{|u| u.a && u.p.x == p.x && u.p.y == p.y}
		end

		def walkable_neighbors(point)
			to_check = []
			[1,-1].each{|off| to_check << P.new(pointx,pointy+off); to_check << P.new(pointx+off,pointy)}
			arr = []
			to_check.each do |p|
				arr << p if p.y >= 0 && p.y < @data.size && p.x >= 0 && p.x < @data[0].size
			end
			arr.select{|p| walkable?(p)}
		end

		def dist(p1,p2)
			xs = [p1.x,p2.x]
			ys = [p1.y,p2.y]
			(xs.max - xs.min) + (ys.max - ys.min)
		end

		def in_range?(p,target_type=nil)
			units = if target_type
						@units.select{|u| u.t == target_type}
					else
						@units
					end
			units.any?{|u| dist(u,p) == 1}
		end

		def flood(from_point)
			pending = []
			reachable = []
			
			until pending.empty?
				point = pending.shift
				reachable << point
				pending += walkable_neighbors(point).reject{|p| reachable.include?(p)}
			end

			reachable
		end

		def enemy_of(u)
			if u.t == :goblin
				:elf
			else
				:goblin
			end
		end

		def hittable_enemies(unit)
			@units.sort.select{|u| u.t == enemy_of(unit) && u.a && dist(unit.p,u.p) == 1}
		end

		def move_if_needed(unit)
			if hittable_enemies.none?
				reachable = flood(unit.p).select{|s| in_range?(s,enemy_of(unit))}
				nearest = reachable.reduce([]) do |nr,cr|
					if nr.empty?
						[cr]
					else
						if dist(cr) < dist(nr)
							[cr]
						elsif dist(cr) == dist(nr)
							[cr, *nr]
						end
					end
				end
				chosen = nearest.sort.first
				paths
				# TODO pathfind to this point
			end
		end

		def combat_round
			@units.each do |unit|
				move_if_needed(unit)
				hittable = hittable_enemies()
				if hittable.any?
					to_hit = hittable.min{|h| h.hp}
					to_hit.hp -= unit.ap
					if to_hit.hp <= 0
						to_hit.a = false
					end
				end
			end
		end

		def victory?
			@units.select{|u| u.t == :goblin && u.a}.none? || @units.select{|u| u.t == :elf && u.a}.none?
		end

		def victor
			@units.map(&:t).first
		end

		def remaining_hp
			@units.select(&:a).map(&:hp).reduce(0,&:+)
		end
	end

	U = Struct.new(:t,:p,:a,:ap,:hp) do
		def <=> other
			self.p <=> other.p
		end

		def to_s
			"#{self.t}#{self.a ? "!":""}#{self.p.to_s}"
		end
	end

	def part_one
		units = []
		map = @lines.map.with_index do |line,y|
			line.chars.map.with_index do |c,x|
				case c
				when ?#, ?. then c
				when ?G then units << U.new(:goblin,P.new(x,y),true,3,200); ?.
				when ?E then units << U.new(:elf,P.new(x,y),true,3,200); ?.
				else raise "Unexpected char #{c} at #{x},#{y}"
				end
			end
		end

		map = Map.new(map,units)

		t = 0
		loop do
			t += 1
			map.combat_round
			break if map.victory?
		end

		puts "After #{t} rounds, the #{map.victor.to_s} win, with #{map.remaining_hp} HP remaining, for a score of #{t * map.remaining_hp}"
	end

	def part_two

	end

end
