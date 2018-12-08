require_relative 'day'

Node = Struct.new(:ch, :md, :p) do
	def len
		2 + ch.map(&:len).reduce(0, &:+) + md.size
	end

	def mdsum
		ch.map(&:mdsum).reduce(0, &:+) + md.reduce(0, &:+)
	end

	def val
		if ch.any?
			md.map{|m| ch[m-1]}.compact.map(&:val).reduce(0, &:+)
		else
			mdsum
		end
	end
end

class D8 < Day

	def build_node_tree_at root
		Node.new.tap do |n|
			n.ch = []
			n.md = []
			ccount = @nums[root]
			mcount = @nums[root+1]
			off = root+2
			while ccount > 0
				n.ch << build_node_tree_at(off)
				off += n.ch.last.len
				ccount -= 1
			end
			while mcount > 0
				n.md << @nums[off]
				off += 1
				mcount -= 1
			end
		end
	end
			
	def part_one
		@nums = @input.split(" ").map(&:to_i)
		@n = build_node_tree_at 0
		puts "The sum of the metadata entries is #{@n.mdsum}"
	end

	def part_two
		puts "The value of the root node is #{@n.val}"
	end

end
