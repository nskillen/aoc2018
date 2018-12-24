require_relative 'day'
require 'io/console'
require 'set'

class D18 < Day

	def wait
		puts "Press any key to continue..."
		STDIN.getch
	end

	def neighbours(map,idx,width)
		ns = []
		(-1..1).each do |y_off|
			next unless (0...map.size).include?(idx + width * y_off)
			(-1..1).each do |x_off|
				next if (idx + x_off) / width != (idx / width)
				next if x_off == 0 && y_off == 0
				ns << map[idx + (width * y_off) + x_off]
			end
		end
		ns
	end

	def generate_map_from(orig_map,next_map,width)
		idx = 0
		while idx < orig_map.length
			acre = orig_map[idx]
			ns = neighbours(orig_map,idx,width)
			next_map[idx] = if    acre == ?. && ns.count{|n| n == ?|} >= 3
								?|
							elsif acre == ?| && ns.count{|n| n == ?#} >= 3
								?#
							elsif acre == ?# && (ns.count{|n| n == ?#} == 0 || ns.count{|n| n == ?|} == 0)
								?.
							else
								acre
							end
			idx += 1
		end
		[next_map, orig_map]
	end

	def print_map(map,width)
		map.each_slice(width) do |line|
			puts line.join("")
		end
	end

	def map_score(map)
		map.count("#") * map.count("|")
	end

	def part_one
		map = @lines.join("")
		next_map = map.dup
		width = @lines.first.size

		puts "map is #{width}x#{@lines.size}"
		seen_configs = Array.new(1000000)
		seen_configs[0] = map.hash
		total_configs = 1
		scores = {}
		seen_set = Set.new(seen_configs)

		minute = 0
		max_min = 1_000_000_000
		#last_score = map_score(map)
		#score_diffs = []
		break_reason = nil

		loop do
			puts "After 10 minutes, the lumber score is #{map_score(map)}" if minute == 10
			puts "Minute #{minute}" if minute % (max_min / 1000) == 0
			break if minute == max_min

			# generate updated map
			map, next_map = generate_map_from(map,next_map,width)
			minute += 1

			# break if config seen before (will now loop around)
			h = map.hash
			seen_configs[total_configs] = h
			if seen_set.include?(h)
				break_reason = :loop
				break
			end
			total_configs += 1
			if total_configs == seen_configs.size
				tmp = Array.new(seen_configs.size * 2)
				seen_configs.each_with_index {|c,i| tmp[i] = c}
				seen_configs = tmp
			end
			seen_set.add(h)
			scores[h] = map_score(map)

			# break if we've seen this score before
			#score = map_score(map)
			#score_diffs << score - last_score
			#score_diffs.shift until score_diffs.size <= 10
			#last_score = score
			#if score_diffs.size == 10 && score_diffs.uniq.size == 1
			#	break_reason = :score
			#	break
			#end
		end

		if break_reason == :loop
			puts "array size: #{total_configs}"
			puts "minute: #{minute}"
			mindex = seen_configs.index(seen_configs[total_configs]) # first occurrence of the current hash
			puts "mindex: #{mindex}"
			loop_length = total_configs - mindex # distance between the two
			puts "loop_length: #{loop_length}"
			target_index = mindex + ((max_min - minute) % loop_length)
			puts "target index: #{target_index}"
			target_hash = seen_configs[target_index]
			puts "target_hash: #{target_hash}"
			score = scores[target_hash]
			puts "score at 1 BILLION iterations is #{score}"
		elsif break_reason == :score
			puts "Broke because constant change"
			puts "change of #{score_diffs.last} per minute"
			puts "minute is #{minute}"
			puts "#{max_min - minute} minutes remain"
			puts "final score is #{last_score + (max_min - minute) * score_diffs.last}"
		else
			puts "you must have actually finished"
			puts "last score was #{last_score}"
		end
	end

	def part_two

	end

end
