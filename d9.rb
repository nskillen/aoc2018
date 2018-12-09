require_relative 'day'

class D9 < Day

	N = Struct.new(:n,:p,:v) do
		def self.init
			N.new.tap do |n|
				n.n = n
				n.p = n
				n.v = 0
			end
		end

		def insert_before(val)
			n = N.new(self,self.p,val)
			self.p.n=n
			self.p=n
		end
		
		def remove
			self.p.n = self.n
			self.n.p = self.p
			[self,self.n]
		end
	end

	def part_one
		@lines.each do |line|
			m = /(\d+) players; last marble is worth (\d+) points/.match(line)
			players, points = m[1..-1].map(&:to_i)

			score = Array.new(players,0)
			board = N.init
			player = 1
			cur = board

			(1..points).each do |m|
				if points > 7000000 && m % 100000 == 0
					puts "On marble #{m}"
				end
				if m % 23 == 0
					score[player] += m
					removed,cur = cur.p.p.p.p.p.p.p.remove
					score[player] += removed.v
				else
					cur = cur.n.n.insert_before(m)
				end
				player = (player + 1) % players
			end
			puts "The winning elf's score is #{score.max}"
		end
	end

	def part_two
	end

end
