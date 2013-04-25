#also in future manage different tile sizes?
require 'rubygems'
require 'gosu'
include Math

#lakes and mountains happen first, then roads, then trees?

class MapGen
	def initialize (window, width, height, rows, cols)
		@width = width
		@height = height
		@rows = rows
		@cols = cols
		@tiles = Hash.new
		@tiled = false
		tile_struct = Struct.new :image, :z_ordering, :speed, :name 
		#tile properties, 	
		#					image, 
		#					z-ordering, 
		#					speed/id
		#					name
		@tiles["pines"] = tile_struct.new Gosu::Image.new(window, "map_tiles/evergreens.png", true), 
							2, 
							4,
							"pines"
		@tiles["pines1"] = tile_struct.new Gosu::Image.new(window, "map_tiles/evergreens1.png", true), 
							2, 
							4,
							"pines"
		
		@tiles["grass"] = tile_struct.new Gosu::Image.new(window, "map_tiles/grass.png", true), 
							1, 
							2,
							"grass"
		@tiles["grass1"] = tile_struct.new Gosu::Image.new(window, "map_tiles/grass1.png", true), 
							1, 
							2,
							"grass"
		@tiles["grass2"] = tile_struct.new Gosu::Image.new(window, "map_tiles/grass2.png", true), 
							1, 
							2,
							"grass"
		@tiles["grass3"] = tile_struct.new Gosu::Image.new(window, "map_tiles/grass3.png", true), 
							1, 
							2,
							"grass"
		
		@tiles["peak"] = tile_struct.new Gosu::Image.new(window, "mountains/mountainpeak.png", true), 
							4, 
							15,
							"peak"
		@tiles["peak1"] = tile_struct.new Gosu::Image.new(window, "mountains/mountainpeak1.png", true), 
							4, 
							15,
							"peak"
		@tiles["lake"] = tile_struct.new Gosu::Image.new(window, "lake/lake.png", true), 
							3, 
							15,
							"lake"	
		@tiles["lake1"] = tile_struct.new Gosu::Image.new(window, "lake/lake1.png", true), 
							3, 
							15,
							"lake"	
		@tiles["lake2"] = tile_struct.new Gosu::Image.new(window, "lake/lake2.png", true), 
							3, 
							15,
							"lake"	
		@tiles["lake3"] = tile_struct.new Gosu::Image.new(window, "lake/lake3.png", true), 
							3, 
							15,
							"lake"	
		@tiles["nil"] = tile_struct.new nil, 
							0, 
							0,
							"nil"
		@tiles["lake_shallow"] = tile_struct.new Gosu::Image.new(window, "lake/lake_shallow.png", true), 
							3, 
							4,
							"lake_shallow"	
		@tiles["lake_shallow1"] = tile_struct.new Gosu::Image.new(window, "lake/lake_shallow1.png", true), 
							3, 
							4,
							"lake_shallow"	
		@tiles["lake_shallow2"] = tile_struct.new Gosu::Image.new(window, "lake/lake_shallow2.png", true), 
							3, 
							4,
							"lake_shallow"	
		@tiles["lake_shallow3"] = tile_struct.new Gosu::Image.new(window, "lake/lake_shallow3.png", true), 
							3, 
							4,
							"lake_shallow"								
		@tiles["hills"] = tile_struct.new Gosu::Image.new(window, "map_tiles/hills.png", true), 
							1, 
							3,
							"hills"		
		@tiles["hills1"] = tile_struct.new Gosu::Image.new(window, "map_tiles/hills1.png", true), 
							1, 
							3,
							"hills"						
		@tiles["cliff"] = tile_struct.new Gosu::Image.new(window, "mountains/cliff.png", true), 
							4, 
							9,
							"cliff"
		@tiles["pass"] = tile_struct.new Gosu::Image.new(window, "mountains/pass.png", true), 
							4, 
							6.5,
							"pass"		
		@tiles["cliff1"] = tile_struct.new Gosu::Image.new(window, "mountains/cliff1.png", true), 
							4, 
							9,
							"cliff"
		@tiles["pass1"] = tile_struct.new Gosu::Image.new(window, "mountains/pass1.png", true), 
							4, 
							6.5,
							"pass"
		@tiles["forest"] = tile_struct.new Gosu::Image.new(window, "map_tiles/forest.png", true), 
							2, 
							4,
							"forest"
		@tiles["forest1"] = tile_struct.new Gosu::Image.new(window, "map_tiles/forest1.png", true), 
							2, 
							4,
							"forest"
		@tiles["dark_forest"] = tile_struct.new Gosu::Image.new(window, "map_tiles/darkforest.png", true), 
							2, 
							6.5,
							"dark_forest"
		@tiles["dark_forest1"] = tile_struct.new Gosu::Image.new(window, "map_tiles/darkforest1.png", true), 
							2, 
							6.5,
							"dark_forest"
							
		@tiles["tree"] = tile_struct.new Gosu::Image.new(window, "map_tiles/tree.png", true), 
							2, 
							4,
							"tree"
							
		@tiles["tree1"] = tile_struct.new Gosu::Image.new(window, "map_tiles/tree1.png", true), 
							2, 
							4,
							"tree"		
		@tiles["fill"] = tile_struct.new nil, 
							100, 
							0,
							"fill"	
		
		@rand_tile_angle = Hash.new
		
		@rand_tile_angle["nil"] = ["nil"]
		@rand_tile_angle["fill"] = ["fill"]
		
		@rand_tile_angle["peak"] = ["peak", "peak1"]
		@rand_tile_angle["cliff"] = ["cliff", "cliff1"]
		@rand_tile_angle["pass"] = ["pass", "pass1"]
		@rand_tile_angle["pines"] = ["pines", "pines1"]
		
		@rand_tile_angle["grass"] = ["grass", "grass1", "grass2", "grass3"]
		@rand_tile_angle["hills"] = ["hills", "hills1"]
		@rand_tile_angle["tree"] = ["tree", "tree1"]
		
		@rand_tile_angle["lake"] = ["lake", "lake1", "lake2", "lake3"]
		@rand_tile_angle["lake_shallow"] = ["lake_shallow", "lake_shallow1", "lake_shallow2", "lake_shallow3"]
		
		@rand_tile_angle["forest"] = ["forest", "forest1"]
		@rand_tile_angle["dark_forest"] = ["dark_forest", "dark_forest1"]
		
		
		#only used to generate the map
		@tile_gen = Hash.new
		@tile_gen["nil"] = ["nil", "nil", "nil"]
		
		@tile_gen["peak"] = ["peak", "cliff", "cliff"]					
		@tile_gen["cliff"] = ["cliff", "pass", "pass"]
		@tile_gen["pass"] = ["cliff", "pass", "fill"]
		#"fill" is used to make a space that will later be filled with pines
		#it allows multiple mountains to generate on top of each other
		@tile_gen["pines"] = ["pines", "pines", "nil"]
		@tile_gen["fill"] = ["fill", "fill", "nil"]
		
		@tile_gen["grass"] = ["grass", "grass", "grass"]
		@tile_gen["hills"] = ["hills", "grass", "grass"]
		@tile_gen["tree"] = ["tree", "tree", "tree"]
		
		@tile_gen["lake"] = ["nil", "nil", "nil"]
		@tile_gen["lake_shallow"] = ["nil", "nil", "nil"]
		
		@tile_gen["forest"] = ["forest", "forest", "fill"]
		@tile_gen["dark_forest"] = ["dark_forest", "dark_forest", "forest"]
		
		@map = Array.new(@rows) { Array.new(@cols) { [@tiles["nil"],@tiles["nil"]]} }
		@mapCompare = Array.new(@rows) { Array.new(@cols) { [@tiles["nil"],@tiles["nil"]]} }
		
		#order of generation grass, hills, forest, lake, mountain
		
		types = ["grass", "hills", "forest", "dark_forest", "lake", "ridge", "mountain"]
		#estimates total number to be generated
		total_number = ((@rows*@cols)/10000).to_i
		numbers = [(total_number/2 + rand(-5..5)).to_i, 
					(total_number/4 + rand(-5..5)).to_i,
					(total_number/4 + rand(-2..2)).to_i,
					(total_number/4 + rand(-2..2)).to_i,
					(total_number/5 + rand(-2..2)).to_i,
					(total_number/10 + rand(-2..2)).to_i,
					(total_number/5 + rand(-2..2)).to_i]
		#calculates total
		total = 0
		#start at 2 because we don't really care about the number of grass and hills generated
		(2..numbers.length-1).each do |i|
			total+=numbers[i]
		end
		points = []
		row = Math.sqrt(total).ceil
		puts row, total
		dist = @rows/row
		(0..row-1).each do |r|
			(0..row-1).each do |c|
				points.push [rand(r*dist..(r+1)*dist), rand(c*dist..(c+1)*dist)]
			end
		end
		points.shuffle!
		index = 0
		points_index = 0
		types.each do |type|
			puts "generating " + type + "..."
			numbers[index].times do	
				if type == "mountain"
					gen_mountain(*points[points_index], rand(10..dist))
					points_index+=1
				elsif type == "ridge"
					gen_ridge(*points[points_index], rand(dist..dist*3))
					points_index+=1
				elsif type == "grass" or type == "hills"
					gen_section(rand(0..(@rows-1)), rand(0..@cols-1), rand(10..dist), type)
				else
					gen_section(*points[points_index], rand(10..dist), type)
					points_index+=1
				end
			end
			index+=1
		end
		
		puts "filling in extra map..."
		fill_in_map
		puts "Done!"
	end
	
	def gen_section(x, y, size, type)
		size = size/2
		points = []
		points.push [x+size+rand(-5..5), y+size+rand(-5..5)]
		points.push [x-size+rand(-5..5), y+size+rand(-5..5)]
		points.push [x-size+rand(-5..5), y-size+rand(-5..5)]
		points.push [x+size+rand(-5..5), y-size+rand(-5..5)]
		
		if type == "lake"
			tile_name = "lake_shallow"
			tile_name1 = "lake"
			
		elsif type == "forest"
			tile_name = "fill"
			tile_name1 = "forest"
		elsif type == "dark_forest"
			tile_name = "forest"
			tile_name1 = "dark_forest"
			
		elsif type == "hills"
			tile_name = "fill"
			tile_name1 = "hills"
			
		elsif type == "grass"
			tile_name = "grass"
			tile_name1 = "grass"
		end
		#right to left
		gen_edge(*points[0], *points[1], x, y, tile_name)
		#bottom to top
		gen_edge(*points[1], *points[2], x, y, tile_name)
		#left to right
		gen_edge(*points[2], *points[3], x, y, tile_name)
		#top to bottom
		gen_edge(*points[3], *points[0], x, y, tile_name)
		
		fill_in_center(x, y, x, y, size, tile_name1)
		
		#if we used fill to disperse, change all fill to nil
		if type == "forest" or type == "hills"
			((x-size*2)..(x+size*2)).each do |r|
				((y-size*2)..(y+size*2)).each do |c|
					if @map[check_x(r)][check_y(c)][1].name == "fill"
						@map[check_x(r)][check_y(c)][1] = rand_tile("grass")
					end
				end
			end
		end
	end
	
	#x and y represent the relative center of the circle
	def fill_in_center(x, y, center_x, center_y, size, tile_name)
		if x >= @rows
			x = 0
		elsif x < 0
			x = @rows -1
		end
		if y >= @cols
			y = 0
		elsif y < 0
			y = @cols -1
		end
		
		dx = (x-center_x).abs
		dy = (y-center_y).abs
		
		dist = dx >= dy ? dx : dy
		if tile_name == "lake"
			if over_ride_tile?(tile_name, @map[x][y][1])#.name == "nil"
				@map[x][y][1] = rand_tile(tile_name)
			else
				return
			end
		else
			rand_gen = [(rand*((size*2)-dist)+2), rand*dist, rand*(dist)]
			key = @tile_gen[tile_name][index_of_max(rand_gen)]
			if over_ride_tile?(tile_name, @map[x][y][1])#.name == "nil"
				@map[x][y][1] = rand_tile(key)
			else
				return
			end
		end
		
		fill_in_center(x+1,y, center_x, center_y, size, tile_name)
		fill_in_center(x-1,y, center_x, center_y, size, tile_name)
		fill_in_center(x,y-1, center_x, center_y, size, tile_name)
		fill_in_center(x,y+1, center_x, center_y, size, tile_name)
		
		#if this was haskel... this would be so much easier
		
	end
	#distance (d) = greatest length between points, 
	#v is variant the axis that will wander
	def gen_edge(x1, y1, x2, y2, center_x, center_y, tile_name)
		
		#switch vertical horizontal
		if (x1-x2).abs >= (y1-y2).abs
			d1 = x1.to_i
			v1 = y1.to_i
			d2 = x2.to_i
			v2 = y2.to_i
			switch = true
			center = center_y
			
		else
			v1 = x1.to_i
			d1 = y1.to_i
			v2 = x2.to_i
			d2 = y2.to_i
			switch = false
			center = center_x
		end		
		down = true
		#flip up and down
		if d1-d2 > 0
			down = false
		end
		v = v1
		d = d1
		map_section_edge(v,d,switch,center, tile_name)	
		
		while d<d2 or d2 < d
			dd = (d-d2).abs
			length = dd*2
			#Angle_Heading
			a_h = rand((v2-dd)..(v2+dd))
			#Starting Point
			s_p = v2-dd
			
			if length >= 5
				interval = length/5
				case a_h
				
				when (s_p..s_p+interval)
					v-=1		
				when (s_p+interval..s_p+(interval*2))
					v-=1
					d+=increment(down)
				when (s_p+(interval*2)..s_p+(interval*3))
					d+=increment(down)
				when (s_p+(interval*3)..s_p+(interval*4))
					v+=1
					d+=increment(down)
				when (s_p+(interval*4)..s_p+(interval*5))
					v+=1
				end
			elsif length >= 3
				interval = length/3
				case a_h
				
				when (s_p..s_p+interval)
					v-=1
					d+=increment(down)
				when (s_p+interval..s_p+(interval*2))
					d+=increment(down)
				when (s_p+(interval*2)..s_p+(interval*3))
					v+=1
					d+=increment(down)
				end
			else
				d=d2
			end
			
			dv = (v-v2).abs
			if dv>=dd or v==center-1 or v==center+1
				map_section_edge(v,d,switch,center, tile_name)
				if v<v2
					v+=1
				else
					v-=1
				end
				map_section_edge(v,d,switch,center, tile_name)
			end
			
			map_section_edge(v,d,switch,center, tile_name)		
			
		end
		map_section_edge(v2,d2,switch,center, tile_name)
		while v != v2
			if v<v2
				v+=1
			else
				v-=1
			end
			map_section_edge(v,d,switch,center, tile_name)
		end
		
		
	end
	
	def map_section_edge(v,d,switch,center, tile_name)
		if switch
			if over_ride_tile?(tile_name, @map[check_x(d)][check_y(v)][1])
				@map[check_x(d)][check_y(v)][1] = rand_tile(tile_name)
			end
			if v < center
				v-=1
			else
				v+=1
			end
			if over_ride_tile?(tile_name, @map[check_x(d)][check_y(v)][1])
				@map[check_x(d)][check_y(v)][1] = rand_tile(tile_name)
			end
		else
			if over_ride_tile?(tile_name, @map[check_x(v)][check_y(d)][1])
				@map[check_x(v)][check_y(d)][1] = rand_tile(tile_name)
			end
			if v < center
				v-=1
			else
				v+=1
			end
			if over_ride_tile?(tile_name, @map[check_x(v)][check_y(d)][1])
				@map[check_x(v)][check_y(d)][1] = rand_tile(tile_name)
			end
		end
	end
	def increment(plus)
		if plus
			return 1
		else
			return -1
		end
	end
	def find_width(x, y, x1, y1, x2, y2)
		#width from center line
		if x2-x1 != 0
			m = (y2-y1)/(x2-x1)
			b = y2 - m*x2
			width = (y-(m*x)-b).abs/(Math.sqrt(m**2 + 1))
		else
			width = (x2 - x).abs
		end		
		return width
		
	end
	def find_distance(x, y, x2, y2, initial_angle = 0)

		#find distance based on angle
		if initial_angle != 0
			cross_angle = ((initial_angle-1) + 2)%8+1
			x1,y1 = update_x_y(x2, y2, cross_angle)
			if x2-x1 != 0
				m = (y2-y1)/(x2-x1)
				b = y2 - m*x2
				distance = (y-(m*x)-b).abs/(Math.sqrt(m**2 + 1))
			else
				distance = (x2 - x).abs
			end
		#simple find distance
		else
			if x == x2
				distance = (y-y2).abs
			elsif y == y2
				distance = (x-x2).abs
			else
				distance = Math.sqrt((x2 - x).abs * (x2 - x).abs + (y2 - y).abs * (y2 - y).abs)
			end
		end
		return distance
	end
	
	def over_ride_tile?(new_tile, current_tile)
		if @tiles[new_tile].z_ordering > current_tile.z_ordering
			return true
		else
			return false
		end
	end
	
	def rand_tile(tile_name)
		length = @rand_tile_angle[tile_name].length
		new_tile = @tiles[@rand_tile_angle[tile_name][rand(0..length-1)]]
		return new_tile
	end
	
	def update_x_y(x, y, angle)
		if angle == 2
			x+=1
			y-=1
		elsif angle == 4
			x+=1
			y+=1
		elsif angle == 6
			x-=1
			y+=1
		elsif angle == 8
			x-=1
			y-=1
		elsif angle == 1
			y-=1
		elsif angle == 3
			x+=1
		elsif angle == 5
			y+=1
		elsif angle == 7
			x-=1
		end
		
		return x, y
	end
	
	def check_x(x_value)
		if x_value >= @rows
			x_value = x_value - @rows
		elsif x_value < 0
			x_value = x_value + (@rows)
		end
		return x_value
	end
	def check_y(y_value)
		if y_value >= @cols
			y_value = y_value - @cols
		elsif y_value < 0
			y_value = y_value + @cols
		end
		return y_value
	end
	def find_angle(angle, center)
		center -= 1
		angles_list = [(center - 2)%8+1, (center - 1)%8+1, center%8+1, (center + 1)%8+1, (center + 2)%8+1]
		
		index = angles_list.index(angle)
		
		if index == nil
			index = 2
		end
		turn = rand(-1..1)
		index += turn
		if index < 0
			index = 1
		elsif index > 4
			index = 3
		end
		return angles_list[index]
	end
	def gen_ridge(x, y, length)
	
		width = 10 + rand(-2..5)
		#center angle can only be 1,3,5,7
			#find initial center angle and angle1
		center_angle = rand(0..3)*2 + 1
		angle = center_angle
		
		x = x.to_i
		y = y.to_i
		
		#distance, width = find_distance_width(x1, y1, x2, y2, center_angle)
		
		##################
		x, y = map_ridge(x,y,angle,center_angle, width)	
		i = 0
		num_peaks = (length/40).to_i + 1
		interval = (length/num_peaks).ceil
		interval_length = interval
		peaks = []
		peaks.push [x,y]
		while i < length
			i+=1
			
			angle = find_angle(angle, center_angle)

			x, y = map_ridge(x,y,angle,center_angle, width)	
			if i >= interval_length
				interval_length += interval
				#gen_mountain(x,y, num_peaks*7)
				peaks.push [x,y]
			end
			
		end
		peaks.push [x,y]
		midPeak = (peaks.length/2).to_i
		gen_mountain(*peaks.first, num_peaks+(rand(width*3..width*5)*2))
		(1..peaks.length-2).each do |i|
			gen_mountain(*peaks[i], num_peaks+(rand(width*3..width*4)*2))
		end
		gen_mountain(*peaks.last, num_peaks+(rand(width*3..width*5)*2))
		
	end
	def map_ridge(x, y, angle, center_angle, width)
		width = width
		angles = *(1..8)
		index = angles.index(center_angle)
		
		
		
		rand_gen = [rand*(20), rand*15, rand*5]
		local_tile_gen = ["peak", "cliff", "pass"]
		key = local_tile_gen[index_of_max(rand_gen)]
		
		@map[check_x(x)][check_y(y)][1] = rand_tile(key)
		map_sub_ridge(x,y,angles[index-2],width, key)
		if index >= 6 
			index -= 6
		else
			index + 2
		end
		map_sub_ridge(x,y,angles[index],width, key)
		
		x, y = update_x_y(x,y,angle)
		
		return x,y
	end
	def map_sub_ridge(x,y,angle,length, tile)
		i = 0
		finished = false
		x, y = update_x_y(x,y,angle)
		local_tile_gen = Hash.new
		local_tile_gen["peak"] = ["peak", "cliff", "pass"]
		local_tile_gen["cliff"] = ["cliff", "cliff", "pass"]
		local_tile_gen["pass"] = ["pass", "cliff", "nil"]
		local_tile_gen["nil"] = ["nil", "nil", "nil"]
		key = tile
		while i < length and !finished
			i+=1
			rand_gen = [rand*(20), rand*15, rand*5]
			key = local_tile_gen[key][index_of_max(rand_gen)]
			if key == "nil"
				finished = true
			else
				@map[check_x(x)][check_y(y)][1] = rand_tile(key)
				x, y = update_x_y(x,y,angle)
			end
		end
	end
	
	#distance from mountain... changes weight of tiles
	#typesig Integer, Integer
	def gen_mountain(x, y, size)
		layer = 0
		x = x.to_i
		y = y.to_i
		@map[check_x(x)][check_y(y)][0] = @tiles["peak"]
		max_dist = size/2
		dist = 1
		length = 2
		while dist <= max_dist
			# EAST
			(0..(length-1)).each do |i|
				#continue only if the tile we are going to change is empty
				if @map[check_x(x+dist)][check_y(y+dist-i)][0].name == "nil" or @map[check_x(x+dist)][check_y(y+dist-i)][0].name == "pines"
					#don't know why I wrote this the way I did... but it works brilliantly :)
					#randomize which tile will be generated based on what tiles are nearby
					if dist < size/4
						num2 = size/4+dist
					else
						num2 = size/4
					end
					#sets the weigth of the tile chosen depending on size and distance
					rand_gen = [rand*(size-dist*2), rand*num2, rand*(1+dist)]
					#search for what tiles are near by
					tile = @map[check_x(x+dist-1)][check_y(y+dist-i)][0]
					if tile.name == "nil" or tile.name == "pine"
						(-2..2).each do |j|
							if @map[check_x(x+dist-1)][check_y(y+dist-i+j)][0].name != "nil" and @map[check_x(x+dist-1)][check_y(y+dist-i+j)][0].name != "pines"
								tile = @map[check_x(x+dist-1)][check_x(y+dist-i+j)][0]
							end
						end
					end
					#if we're not surrounded by empty tiles, change the tile we are at
					if tile.name != "nil" and tile.name != "pines"
						key = @tile_gen[tile.name][index_of_max(rand_gen)]
						# if its a pine tree it means we're at the end of the mountain, 
						#spread pines out for a more graceful finish "fill" will later be replaced by "pines"
						if key == "fill"
							if rand(0..5) != 0
								@map[check_x(x+dist+1)][check_y(y+dist-1-i)][0] = rand_tile(key)#@tiles[key]
							end
							if rand(0..5) != 0
								@map[check_x(x+dist+1)][check_y(y+dist+1-i)][0] = rand_tile(key)#@tiles[key]
							end
						end
						#and finally create the tile we are at
						@map[check_x(x+dist)][check_y(y+dist-i)][0] = rand_tile(key)#@tiles[key]
					end
				end
				
			end
			# WEST
			(0..(length-1)).each do |i|
				if @map[check_x(x-dist)][check_y(y-dist+i)][0].name == "nil" or @map[check_x(x-dist)][check_y(y-dist+i)][0].name == "pines"
					if dist < size/4
						num2 = size/4+dist
					else
						num2 = size/4
					end
					
					rand_gen = [rand*(size-dist*2), rand*num2, rand*(2+dist)]
					tile = @map[check_x(x-dist+1)][check_y(y-dist+i)][0]
					if tile.name == "nil" or tile.name == "pines"
						(-1..1).each do |j|
							if @map[check_x(x-dist+1)][check_y(y-dist+i+j)][0].name != "nil" and @map[check_x(x-dist+1)][check_y(y-dist+i+j)][0].name != "pines"
								tile = @map[check_x(x-dist+1)][check_y(y-dist+i+j)][0]
							end
						end
					end
					
					if tile.name != "nil" and tile.name != "pines"
						key = @tile_gen[tile.name][index_of_max(rand_gen)]
						if key == "fill"
							if rand(0..5) != 0
								@map[check_x(x-dist-1)][check_y(y-dist+1+i)][0] = rand_tile(key)
							end
							if rand(0..5) != 0
								@map[check_x(x-dist-1)][check_y(y-dist-1+i)][0] = rand_tile(key)
							end
						end
						@map[check_x(x-dist)][check_y(y-dist+i)][0] = rand_tile(key)
					end
				end
			end
			# SOUTH
			(0..(length-1)).each do |i|
				if @map[check_x(x-dist+i)][check_y(y+dist)][0].name == "nil" or @map[check_x(x-dist+i)][check_y(y+dist)][0].name == "pines"
					if dist < size/4
						num2 = size/4+dist
					else
						num2 = size/4
					end
					rand_gen = [rand*(size-dist*2), rand*num2, rand*(2+dist)]
					
					tile = @map[check_x(x-dist+i)][check_y(y+dist-1)][0]
					if tile.name == "nil" or tile.name == "pines"
						(-1..1).each do |j|
							if @map[check_x(x-dist+i)][check_y(y+dist-1+j)][0].name != "nil" and @map[check_x(x-dist+i)][check_y(y+dist-1+j)][0].name != "pines"
								tile = @map[check_x(x-dist+i)][check_y(y+dist-1+j)][0]
							end
						end
					end
					
					if tile.name != "nil" and tile.name != "pines"
						key = @tile_gen[tile.name][index_of_max(rand_gen)]
						# key = tile.gen_nearby[index_of_max(rand_gen)]
						if key == "fill"
							if rand(0..5) != 0
								@map[check_x(x-dist-1+i)][check_y(y+dist+1)][0] = rand_tile(key)#@tiles[key]
							end
							if rand(0..5) != 0
								@map[check_x(x-dist+1+i)][check_y(y+dist+1)][0] = rand_tile(key)#@tiles[key]
							end
						end
						@map[check_x(x-dist+i)][check_y(y+dist)][0] = rand_tile(key)#@tiles[key]
					end
				end
			end
			# NORTH
			(0..(length-1)).each do |i|
				if @map[check_x(x+dist-i)][check_y(y-dist)][0].name == "nil" or @map[check_x(x+dist-i)][check_y(y-dist)][0].name == "pines"
					if dist < size/4
						num2 = size/4+dist
					else
						num2 = size/4
					end
					rand_gen = [rand*(size-dist*2), rand*num2, rand*(2+dist)]
					
					tile = @map[check_x(x+dist-i)][check_y(y-dist+1)][0]
					if tile.name == "nil" or tile.name == "pines"
						(-1..1).each do |j|
							if @map[check_x(x+dist-i)][check_y(y-dist+1+j)][0].name != "nil" and @map[check_x(x+dist-i)][check_y(y-dist+1+j)][0].name != "pines"
								tile = @map[check_x(x+dist-i)][check_y(y-dist+1+j)][0]
							end
						end
					end
					if tile.name != "nil" and tile.name != "pines"
						# key = tile.gen_nearby[index_of_max(rand_gen)]
						key = @tile_gen[tile.name][index_of_max(rand_gen)]
						if key == "fill"
							if rand(0..5) != 0
								@map[check_x(x+dist-1-i)][check_y(y-dist-1)][0] = rand_tile(key)#@tiles[key]
							end
							if rand(0..5) != 0
								@map[check_x(x+dist+1-i)][check_y(y-dist-1)][0] = rand_tile(key)#@tiles[key]
							end
						end
						@map[check_x(x+dist-i)][check_y(y-dist)][0] = rand_tile(key)#@tiles[key]
					end
				end
			end
			dist += 1
			length = dist*2
		end	
		((x-max_dist-2)..(x+max_dist+2)).each do |r|
			((y-max_dist-2)..(y+max_dist+2)).each do |c|
				if @map[check_x(r)][check_y(c)][0].name == "fill"
					@map[check_x(r)][check_y(c)][0] = rand_tile("pines")
				end
			end
		end
	end
	#returns highest of a list of numbers, if there are ties first one wins
	def index_of_max(array)
		max = 0
		index = 0
		array.each do |elem|
			if elem > max
				max = elem
				index = array.index(elem)
			end
		end
		return index
	end
	
	def traversable?(x,y)
		return true
		if x >= @rows
			x = 0
		elsif x < 0
			x = @rows -1
		end
		if y >= @rows
			y = 0
		elsif y < 0
			y = @rows -1
		end
		if @map[x][y][0].name != "nil"
			if @map[x][y][0].speed == 0
				return false
			else
				return true
			end
		else
			return true
		end
	end
	def speed(x,y)
		return 1
		if @map[x][y][0].name != "nil"
			return @map[x][y][0].speed
			
		elsif @map[x][y][1].name != "nil"
			return @map[x][y][1].speed
		else
			return 1
		end
	end
	def fill_in_map
		(0..@rows-1).each do |r|
			(0..@cols-1).each do |c|
				if @map[r][c][0].image == nil and @map[r][c][1].image == nil
					switch = rand(0..100)
					case switch
					
					when (0..95)
						@map[r][c][0] = rand_tile("grass")
					when (95..98)
						@map[r][c][0] = rand_tile("hills")
					when (99..100)
						@map[r][c][1] = rand_tile("tree")
						@map[r][c][0] = rand_tile("grass")
					end
				end
			end
		end
	end
	def marks_compare_function
		if !@tiled
			(0..@rows-1).each do |r|
				(0..@cols-1).each do |c|
					@mapCompare[r][c][0] = @map[r][c][0] 
					@mapCompare[r][c][1] = @map[r][c][1]
					@map[r][c][0] = @tiles[@map[r][c][0].name]
					@map[r][c][1] = @tiles[@map[r][c][1].name]
				end
			end
			@tiled = true
		end
	end
	def marks_uncompare_function
		if @tiled
			(0..@rows-1).each do |r|
				(0..@cols-1).each do |c|
					@map[r][c][0] = @mapCompare[r][c][0] 
					@map[r][c][1] = @mapCompare[r][c][1]
				end
			end
			@tiled = false
		end
	end

	def draw(c_x, c_y)
		x_edge = @width/2
		y_edge = @height/2
		x = 1
		y = 1
	
		(c_x - x_edge..x_edge + c_x).each do |r|
			(c_y - y_edge..y_edge + c_y).each do |c|
				if r >= @rows
					r = r-@rows
				end
				if r < 0
					r = r+@rows
				end
				if c >=@cols
					c = c-@cols
				end
				if c < 0
					c = c+@cols
				end
				if @map[r][c][1].image != nil
					@map[r][c][1].image.draw(x*32, y*32, @map[r][c][1].z_ordering)
				end
				if @map[r][c][0].image != nil
					@map[r][c][0].image.draw(x*32, y*32, @map[r][c][0].z_ordering)
				end
				y+=1
			end
			x+=1
			y=1
		end
	end



end