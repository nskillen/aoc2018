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
k.part_one
k.part_two
