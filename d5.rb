require_relative 'day'

class String
	def upper?
		self == self.upcase
	end

	def lower?
		self == self.downcase
	end
end

class D5 < Day

	def eq_but_opp a, b
		a.downcase == b.downcase && (a.upper? && b.lower? || a.lower? && b.upper?)
	end

	def reduce str,remove=nil
		arr = str.strip.chars.compact
		if remove
			arr.delete(remove.downcase)
			arr.delete(remove.upcase)
		end

		i = 0

		loop do
			len_at_start = arr.size
			while i + 1 < arr.size do
				a = arr[i]
				b = arr[i+1]

				if eq_but_opp(a,b)
					2.times { arr.delete_at(i) }
					i -= 1
				else
					i += 1
				end
			end

			break if arr.size == len_at_start
		end

		arr.join("")
	end


	def part_one

		reduced = reduce(@input)

		puts "Started with #{@input.size} units, now #{reduced.size} units remain"
	end

	def part_two
		results = []
		('a'..'z').each do |l|
			results << reduce(@input, l)
		end

		puts "Started with #{@input.size} units, now #{results.map(&:size).min} units remain"

	end

end
