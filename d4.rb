require_relative 'day'
require 'date'

class D4 < Day

  def part_one
    @guards = {}
    guard = -1
    sleep_start = nil
    @lines.each do |l|
      m = /\[(.+)\] (falls asleep|wakes up|Guard #(\d+) begins shift)/.match l
      ts = DateTime.strptime(m[1], "%Y-%m-%d %H:%M")
      case m[2]
      when 'falls asleep'
        next if guard == -1
        sleep_start = ts
      when 'wakes up'
        next if guard == -1
        sleep_time = (ts - sleep_start) * 24 * 60
        @guards[guard] ||= {id: guard, time: 0, pattern: Array.new(60, 0)}
        @guards[guard][:time] += sleep_time.to_i
        (sleep_start.min...ts.min).each do |m|
          @guards[guard][:pattern][m] += 1
        end
      else
        guard = m[3].to_i if m[3]
      end
    end

    guard = @guards.values.reduce(nil){|g,n| g ? g[:time] > n[:time] ? g : n : n}

    puts "Guard with most sleep is #{guard[:id]}"
    puts "Guard slept #{guard[:time]} minutes"
    puts "Guard most often slept at minute #{guard[:pattern].index(guard[:pattern].max)}"
  end

  def part_two
    sorted_guards = @guards.values.sort{|a,b| a[:pattern].max <=> b[:pattern].max}
    g = sorted_guards.last
    puts "Guard #{g[:id]} spent #{g[:pattern].max} minutes asleep at minute #{g[:pattern].index(g[:pattern].max)}"
  end

end
