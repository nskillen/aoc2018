require_relative 'day'
require 'io/console'

class D19 < Day

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

	def wait
		puts "Press any key to continue..."
		STDIN.getch
	end

	def part_one
		initial_ip = @lines.first
		instructions = @lines[1..-1].map{|i| i.split(" ")}.map{|i,a,b,c| [i.to_sym,a.to_i,b.to_i,c.to_i]}

		ip_idx = initial_ip.split(" ").last.to_i
		ip = 0
		registers = [0,0,0,0,0,0]

		until ip < 0 || ip >= instructions.size
			instruction = instructions[ip]
			opcode,a,b,c = instruction

			rv = registers[ip_idx]
			registers[ip_idx]=ip
			OPCODES[opcode].call(registers,a,b,c)
			ip = registers[ip_idx]
			registers[ip_idx] = rv
			ip += 1
		end

		puts registers
	end

	def part_two
		puts "https://www.wolframalpha.com/input/?i=sum+of+divisors+of+10551358"
	end

end
