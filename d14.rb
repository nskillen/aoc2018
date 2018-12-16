require_relative 'day'

class D14 < Day

	INPUT = 293801
	INPUT_RX = /293801/

	def part_one
		scores = Array.new(INPUT*200, 0)
		first_unused = 2
		scores[0] = 3
		scores[1] = 7
		elves = [0,1]

		puts "looping!"
		seen_input = false
		last_10 = ""
		last_10_idx = 0
		until seen_input
			new_recipes = elves.map{|e| scores[e]}.reduce(0,&:+).digits.reverse
			new_recipes.each do |r|
				last_10 << r.to_s
				seen_input = INPUT_RX =~ last_10
				scores[first_unused] = r
				first_unused += 1
			end
			elves = elves.map{|e| (e + 1 + scores[e]) % first_unused}
			shift_out = last_10.size - 10
			if shift_out > 0
				last_10 = last_10[shift_out..-1]
				last_10_idx += shift_out
			end
		end
		
		puts "The scores of the 10 recipes after making 9 is #{scores[9..-1].take(10).join("")}"
		puts "The scores of the 10 recipes after making 5 is #{scores[5..-1].take(10).join("")}"
		puts "The scores of the 10 recipes after making 18 is #{scores[18..-1].take(10).join("")}"
		puts "The scores of the 10 recipes after making 2018 is #{scores[2018..-1].take(10).join("")}"
		puts "The scores of the 10 recipes after making #{INPUT} is #{scores[INPUT..-1].take(10).join("")}"

		scores[first_unused-10..first_unused].each_with_index{|s,i| puts "#{s} #{i+first_unused-10}"}
	end

	def part_two

	end

end
