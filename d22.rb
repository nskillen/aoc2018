require_relative 'day'
require 'io/console'

class D22 < Day

  DEPTH = 11739
  TX = 11
  TY = 718

  def geologic_index(r)
    return 0 if r.x == 0 && r.y == 0
    return 0 if r.x == TX && r.y == TY
    return r.x * 16807 if r.y == 0
    return r.y * 48271 if r.x == 0
    erosion_level(P.new(r.x-1,r.y)) * erosion_level(P.new(r.x,r.y-1))
  end

  def erosion_level(r)
    @els ||= {}
    @els[r] ||= (geologic_index(r) + DEPTH) % 20183
  end

  def region_type(r)
    case erosion_level(r) % 3
    when 0 then :rocky
    when 1 then :wet
    when 2 then :narrow
    end
  end

	def wait
		puts "Press any key to continue..."
		STDIN.getch
	end

	def part_one
    @cave = (0..TY).map do |y|
      (0..TX).map do |x|
        rt = region_type(P.new(x,y))
        case rt
        when :rocky then 0
        when :wet then 1
        when :narrow then 2
        else raise "unexpected region type #{rt}"
        end
      end
    end
    puts @cave.flatten.reduce(0,&:+)
	end

  def needed_tools(r)
    case region_type(r)
    when :rocky then [:climbing_gear,:torch]
    when :wet then [:climbing_gear,:neither]
    when :narrow then [:torch,:neither]
    end
  end

  def other_tool(r,tool)
    (needed_tools(r) - [tool]).first
  end

  def get_reachable(r,tool)
    enterable = []
    [-1,1].each do |off|
      if needed_tools(r).include?(tool)
        if r.y + off >= 0 && r.y + off < DEPTH
          enterable << P.new(r.x,r.y+off)
        end
        if r.x + off >= 0 && r.x + off < 5 * TX
          enterable << P.new(r.x + off, r.y)
        end
      end
    end
    enterable
  end

  def get_change_reachable(r,tool)
    enterable = []
    [-1,1].each do |off|
      if !needed_tools(r).include?(tool)
        if r.y + off >= 0 && r.y + off < DEPTH
          enterable << P.new(r.x,r.y+off)
        end
        if r.x + off >= 0 && r.x + off < 5 * TX
          enterable << P.new(r.x + off, r.y)
        end
      end
    end
    enterable
  end

  MOVE_TIME = 1
  SWITCH_TIME = 7

	def part_two
    q = []
    (0..(TY+10)).each do |y|
      (0..(TX+20)).each do |x|
        v = P.new(x,y)
        q << {v: v, d: Float::INFINITY, p: nil}
      end
    end

    while q.any?
      u = q.shift




    #open = [{l: P.new(0,0), f: nil, t: :torch, c: false}]
    #visited = {}
    #iters = 0

    #while open.any?
    #  if iters % 100000 == 0
    #    puts "#{iters} iterations, #{open.size} spaces pending checking"
    #  end
    #  begin
    #    p = open.shift
    #    total_cost = p[:f].nil? ? 0 : (visited[p[:f]] + 1 + (p[:c] ? 7 : 0)) # did we change tools to get here?

    #    if !visited.key?(p[:l]) || visited[p[:l]] > total_cost # we haven't been here before, or this route is cheaper
    #      visited[p[:l]] = total_cost

    #      get_reachable(p[:l],p[:t]).each do |pp|
    #        open << {l: pp, f: p[:l], t: p[:t], c: false}
    #      end

    #      get_change_reachable(p[:l],p[:t]).each do |pp|
    #        needed_tools(pp).each do |new_tool|
    #          open << {l: pp, f: p[:l], t: new_tool, c: true}
    #        end
    #      end
    #    end
    #  rescue => e
    #    puts e
    #    require 'pry'
    #    binding.pry
    #  end
    #  iters += 1
    #end
    #puts visited[P.new(TX,TY)]
  end

end
