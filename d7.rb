require_relative 'day'
require 'pp'

class D7 < Day

	def get_doable(steps, done=[], in_progress=[])
		return nil if steps.keys.sort == done.sort

		if done.none?
			steps.select{|k,v| v == []}.keys.reject{|k| in_progress.include?(k)}.sort.first
		else
			steps.reject{|k,v| done.include?(k) || in_progress.include?(k)}.select{|k,v| v - done == []}.keys.sort.first
		end
	end

	def time_for_step s
		60 + (s.ord - 'A'.ord) + 1
	end

	def part_one
		@steps = {}
		('A'..'Z').each do |letter|
			@steps[letter] = []
		end

		@lines.each do |l|
			m = /Step (.) must be finished before step (.) can begin\./.match(l)
			step = m[2]
			prereq = m[1]
			@steps[step] << prereq
		end
		#pp steps

		done = []
		loop do
			can_do = get_doable(@steps, done)
			break if can_do.nil?
			done << can_do
		end
		#pp done
		puts "The final sequence is #{done.join("")}"

	end

	W = Struct.new(:step, :remaining)

	def part_two
		workers = []
		5.times { workers << W.new }

		t = 0
		done = []
		in_progress = []
		#puts "TIME WORKERS DONE"
		loop do
			break if done.size == @steps.keys.size

			workers.select{|w| w.step.nil?}.each do |w|
				next_job = get_doable(@steps, done, in_progress)
				break if next_job.nil?
				w.step = next_job
				w.remaining = time_for_step(next_job)
				in_progress << next_job
			end

			#print "#{t.to_s.rjust(3)}  "
			#workers.each {|w| print "#{w.step ? w.step : '.'}"}
			#puts "   #{done.join("")}"

			t += 1

			workers.select{|w| !w.step.nil?}.each do |w|
				w.remaining -= 1
				if w.remaining == 0
					in_progress.delete(w.step)
					done << w.step
					w.step = nil
				end
			end

		end

		puts "It took #{workers.size} workers #{t} seconds to complete all the jobs"
	end

end
