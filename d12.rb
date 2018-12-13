require_relative 'day'

class D12 < Day

	INITIAL_STATE="##.##..#.#....#.##...###.##.#.#..###.#....##.###.#..###...#.##.#...#.#####.###.##..#######.####..#"
	#INITIAL_STATE="#..#.#..##......###...###"

	def score(state, zidx)
		the_score = 0
		state.chars.each_with_index do |c,i|
			the_score += i - zidx if c == "#"
		end
		the_score
	end
	
	def solve(gens, rules)
		scores = []
		last_score = nil
		state = INITIAL_STATE
		zidx = 0
		(1..gens).each do |gen|
			zidx += 4
			next_state = "." * (state.size + 8)
			"....#{state}....".chars.each_cons(5).with_index do |seg,i|
				next_state[i+2] = rules[seg.join("")] || "."
			end
			chop_idx = next_state.index("#")
			zidx -= chop_idx
			next_state = next_state[chop_idx..-1]
			next_state = next_state[0..next_state.rindex("#")]
			
			state = next_state
			next_score = score(state,zidx)
			if last_score
				scores << (next_score - last_score)
				last_score = next_score
				scores.shift if scores.size > 10
			else
				last_score = next_score
			end
		end

		[state, zidx, scores]
	end

	def part_one
		@rules = @lines.map {|line| parts = line.split(" => ")}.to_h

		final_state, zidx, _ = solve(20, @rules)

		puts "After 20 generations, the final score is #{score(final_state,zidx)}"
				
	end

	def part_two
		gens = 1000
		final_state, zidx, scores = nil, nil, nil
		loop do
			final_state, zidx, scores = solve(gens, @rules)
			break if scores.last == scores.reduce(0, &:+) / scores.size
			gens += 1000
		end
		puts "Score increase settled down to #{scores.last} per generation"
		puts "After 50,000,000,000 generations, the final score will be #{score(final_state,zidx) + scores.last * (50_000_000_000 - gens)}"
	end

end
