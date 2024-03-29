require 'rubygems'
require 'gosu'
require './character'
require './mapgen'
 


#load images for terrain
#terrain has properties like... if it can be walked on...
#
#generate chunks of terrain... 
#
#
$Width = 1024#*2
$Height = 768#*2
#do everyone a favor... keep the map SQUARE!! :) Thanks!
$MapRows = 500
$MapCols = 500
class GameWindow < Gosu::Window
	def initialize
		#+64 adds a black buffer around the edge
		super $Width+98, $Height+98, false
		self.caption = "Gosu Tutorial Game"
		@w = $Width/32
		@h = $Height/32
		#@map = CreateMap.new(self, @w, @h, $MapRows, $MapCols)
		@map = MapGen.new(self, @w, @h,$MapRows, $MapCols)
		@text = Gosu::Font.new(self, 'courier', 25)
		#given in tiles not pixels
		@center_x = 20
		@center_y = 20
		@pause = Time.now
		@character = Character.new(self, @w/2 + 1, @h/2 + 1)
	end
	
	def update
	
		if button_down?(Gosu::KbNumpad2) or button_down?(Gosu::KbDown)
			if (@pause <= Time.now) 
				if @map.traversable?(@center_x, @center_y + 1)
					@center_y += 1
				end
				if @center_y >= $MapCols
					@center_y = 0
				end
				#sets which way the character is facing
				@character.move_down
				#makes it so the character only moves every .1 seconds at most
				@pause = Time.now + 0.1*@map.speed(@center_x, @center_y)
				#toggles between images for animation
				@character.step_taken
			end
		elsif button_down?(Gosu::KbQ) or button_down?(Gosu::KbNumpad5) 
			@map.marks_compare_function
		elsif button_down?(Gosu::KbW) or button_down?(Gosu::KbNumpad0) 
			@map.marks_uncompare_function
		elsif button_down?(Gosu::KbNumpad8) or button_down?(Gosu::KbUp)
			if (@pause <= Time.now) 
				if @map.traversable?(@center_x, @center_y - 1)
					@center_y -= 1
				end
				if @center_y < 0
					@center_y = $MapCols - 1
				end
				@character.move_up
				@pause = Time.now + 0.1*@map.speed(@center_x, @center_y)
				@character.step_taken
			end
		elsif button_down?(Gosu::KbNumpad4) or button_down?(Gosu::KbLeft)
			if (@pause <= Time.now)
				if @map.traversable?(@center_x - 1, @center_y)
					@center_x -= 1
				end
				if @center_x < 0
					@center_x = $MapRows - 1
				end
				@character.move_left
				@pause = Time.now + 0.1*@map.speed(@center_x, @center_y)
				@character.step_taken
			end
		elsif button_down?(Gosu::KbNumpad6) or button_down?(Gosu::KbRight)
			if (@pause <= Time.now)  
				if @map.traversable?(@center_x + 1, @center_y)
					@center_x += 1
				end
				if @center_x >= $MapRows
					@center_x = 0
				end
				@character.move_right
				@pause = Time.now + 0.1*@map.speed(@center_x, @center_y)
				@character.step_taken
			end
		elsif button_down?(Gosu::KbNumpad7) 
			if (@pause <= Time.now)  
				if @map.traversable?(@center_x - 1, @center_y - 1)
					@center_x -= 1
					@center_y -= 1
				end
				if @center_y < 0
					@center_y = $MapCols - 1
				end
				if @center_x < 0
					@center_x = $MapRows - 1
				end
				@character.move_upL
				@pause = Time.now + 0.1*@map.speed(@center_x, @center_y)
				@character.step_taken
			end
		elsif button_down?(Gosu::KbNumpad9)
			if (@pause <= Time.now)  
				if @map.traversable?(@center_x + 1, @center_y - 1)
					@center_x += 1
					@center_y -= 1
				end
				if @center_y < 0
					@center_y = $MapCols - 1
				end
				if @center_x >= $MapRows
					@center_x = 0
				end
				@character.move_upR
				@pause = Time.now + 0.1*@map.speed(@center_x, @center_y)
				@character.step_taken
			end
		elsif button_down?(Gosu::KbNumpad1)
			if (@pause <= Time.now)  
				if @map.traversable?(@center_x - 1, @center_y + 1)
					@center_x -= 1
					@center_y += 1
				end
				if @center_y >= $MapCols
					@center_y = 0
				end
				if @center_x < 0
					@center_x = $MapRows - 1
				end
				@character.move_downL
				@pause = Time.now + 0.1*@map.speed(@center_x, @center_y)
				@character.step_taken
			end
		
		elsif button_down?(Gosu::KbNumpad3)
			if (@pause <= Time.now)  
				if @map.traversable?(@center_x + 1, @center_y + 1)
					@center_x += 1
					@center_y += 1
				end
				if @center_y >= $MapCols
					@center_y = 0
				end
				if @center_x >= $MapRows 
					@center_x = 0
				end
				@character.move_downR
				@pause = Time.now + 0.1*@map.speed(@center_x, @center_y)
				@character.step_taken
			end
		end
		
	end
	#escape to close
	def button_down(id)
		case id
		#escape to close game
		when Gosu::KbEscape
			self.close		
		end
	end
	def draw
		@character.draw
		@map.draw(@center_x, @center_y)
		@text.draw("x = #{@center_x} y = #{@center_y}", 10, ($Height+64), 1)
	end
end
 
window = GameWindow.new
window.show



