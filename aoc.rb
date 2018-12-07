#!/usr/bin/env ruby

day = if ARGV.any?
        ARGV[0]
      else
        "d#{Time.now.day}"
      end

require_relative day
Klazz = Object.const_get(day.upcase)
input = File.read(File.join(__dir__, "input", "#{day}.txt"))

k = Klazz.new(input)
puts "PART ONE"
k.part_one
puts "PART TWO"
k.part_two
