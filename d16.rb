require_relative 'day'
require 'io/console'

class D16 < Day

	OPCODES = {
		addr: -> regs, a, b, c { regs[c] = regs[a] + regs[b] },
		addi: -> regs, a, b, c { regs[c] = regs[a] + b },
		mulr: -> regs, a, b, c { regs[c] = regs[a] * regs[b]},
		muli: -> regs, a, b, c { regs[c] = regs[a] * b  },
		banr: -> regs, a, b, c { regs[c] = regs[a] & regs[b] },
		bani: -> regs, a, b, c { regs[c] = regs[a] & b },
		borr: -> regs, a, b, c { regs[c] = regs[a] | regs[b] },
		bori: -> regs, a, b, c { regs[c] = regs[a] | b },
		setr: -> regs, a, b, c { regs[c] = regs[a] },
		seti: -> regs, a, b, c { regs[c] = a },
		gtir: -> regs, a, b, c { regs[c] = a > regs[b] ? 1 : 0 },
		gtri: -> regs, a, b, c { regs[c] = regs[a] > b ? 1 : 0 },
		gtrr: -> regs, a, b, c { regs[c] = regs[a] > regs[b] ? 1 : 0 },
		eqir: -> regs, a, b, c { regs[c] = a == regs[b] ? 1 : 0 },
		eqri: -> regs, a, b, c { regs[c] = regs[a] == b ? 1 : 0 },
		eqrr: -> regs, a, b, c { regs[c] = regs[a] == regs[b] ? 1 : 0 },
	}

	def part_one
		opcodes = (0...16).map{ |n| [n,nil] }.to_h
		part1_count = 0
		samples = 0
		smallest_sizes = {}
		idx = 0
		@input.lines.each_slice(4) do |before,input,after,_|
			samples += 1
			registers = /Before:\s+\[(\d+), (\d+), (\d+), (\d+)\]/.match(before)[1..-1].map(&:to_i)
			expected_regs = /After:\s+\[(\d+), (\d+), (\d+), (\d+)\]/.match(after)[1..-1].map(&:to_i)

			op, a, b, out = /(\d+) (\d+) (\d+) (\d+)/.match(input)[1..-1].map(&:to_i)

			idx += 4
			rs = nil
			possibles = OPCODES.select do |opcode,oper|
				rs = registers.dup
				oper.call(rs,a,b,out)
				rs == expected_regs
			end

			part1_count += 1 if possibles.size >= 3
			if possibles.size == 1
				opcodes[op] = possibles.keys.first
				smallest_sizes[op] = 1
			else
				begin
					if opcodes[op].nil?
						opcodes[op] = possibles.keys
						smallest_sizes[op] = possibles.keys.size
					elsif opcodes[op].is_a?(Array)
						intersection = opcodes[op] & possibles.keys
						if smallest_sizes[op] > intersection.size
							smallest_sizes[op] = intersection.size
						end
						opcodes[op] = intersection
						if opcodes[op].size == 1
							opcodes[op] = opcodes[op].first
						end
					end
				rescue => e
					puts e
					puts op
					puts possibles.keys
					puts opcodes
					puts smallest_sizes
					raise
				end
			end
		rescue
			break
		end

		changed = true
		until !changed do
			changed = false
			known_ops = opcodes.values.select{|op| op.is_a?(Symbol)}
			opcodes.each do |k,v|
				next if v.is_a?(Symbol)
				res = v - known_ops
				if res != v
					changed = true
					if res.size == 1
						opcodes[k] = res.first
					else
						opcodes[k] = res
					end
				end
			end
		end

		puts "There are #{opcodes.values.uniq.size} known opcocdes"
		puts "There are #{part1_count} samples out of #{samples} that behave like 3 or more opcodes"

		registers = [0,0,0,0]
		instrs = 0
		@lines[idx..-1].each do |line|
			next if line.empty?
			instrs += 1
			if instrs == 1
				puts "The first instruction is #{line}"
			end
			op, a, b, out = /(\d+) (\d+) (\d+) (\d+)/.match(line)[1..-1].map(&:to_i)
			OPCODES[opcodes[op]].call(registers,a,b,out)
		end

		puts "The value of register 0 after running the program is #{registers.join(" ")} (#{instrs} instructions were run)"
	end

	def part_two

	end

end
