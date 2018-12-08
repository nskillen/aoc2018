require 'fileutils'

day = lambda do |d|
	<<~EOF
		require_relative 'day'

		class #{d.upcase} < Day

			def part_one

			end

			def part_two

			end

		end
	EOF
end

d = "d#{ARGV[0]}"
d = d[1..-1] if d.start_with?("dd")

FileUtils.touch("input/#{d}.txt")

File.open("#{d}.rb", "w") do |f|
	f.write day.call(d)
end
