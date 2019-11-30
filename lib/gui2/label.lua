return {
	inherit = "container",
	constructor = function(self)
		
	end,
	
	----------------------------------------
	
	data = {
		_text = "",
		_font = false,
		_text_color = false,
		_text_alignment_x = 1,
		_text_alignment_y = 1,
		_text_wrap = false,
		
		_text_raw = "",
		_text_height = 0,
		
		------------------------------
		
		_wrapText = function(self)
			local str = ""
			local line = ""
			local b = self.borderSize * 2
			local height = nil
			
			self._text_height = 0
			render.setFont(self.font)
			
			for spacer, word in string.gmatch(self._text_raw, "([%s%c]*)(%w+)") do
				if string.find(spacer, "\n") then
					str = str .. line .. "\n"
					line = word
					
					self._text_height = self._text_height + height
				else
					local w, h = render.getTextSize(line .. spacer .. word)
					
					if not height then
						height = h
					end
					
					if w > self._w - b then
						str = str .. line .. "\n"
						line = word
						
						self._text_height = self._text_height + height
					else
						line = line .. spacer .. word
					end
				end
			end
			
			if #line > 0 then
				str = str .. line
				
				self._text_height = self._text_height + height
			end
			
			self._text = str
		end,
		
		------------------------------
		
		onDraw = function(self, w, h)
			self.base()
			
			local ax, ay = self._text_alignment_x, self._text_alignment_y
			local d = self.borderSize
			
			render.setFont(self.font)
			render.setColor(self.textColor)
			
			if self._text_wrap then
				render.drawText(ax == 0 and d or (ax == 1 and w / 2 or w - d), (h - self._text_height) / 2, self.text, ax)
			else
				render.drawSimpleText(ax == 0 and d or (ax == 1 and w / 2 or w - d), ay == 3 and d or (ay == 1 and h / 2 or h - d), self.text, ax, ay)
			end
		end
	},
	
	----------------------------------------
	
	properties = {
		text = {
			set = function(self, text)
				self._text_raw = text
				
				self:_changed(true)
				
				if self._text_wrap then
					self:_wrapText()
				else
					self._text = self._text_raw
				end
			end,
			
			get = function(self)
				return self._text
			end
		},
		
		font = {
			set = function(self, font)
				self._font = font
				
				self:_changed(true)
				
				if self._text_wrap then
					self:_wrapText()
				end
			end,
			
			get = function(self)
				return self._font or self._theme.font
			end
		},
		
		textColor = {
			set = function(self, color)
				self._text_color = color
				
				self:_changed(true)
			end,
			
			get = function(self)
				return self._text_color or self._theme.text
			end
		},
		
		textAlignmentX = {
			set = function(self, x)
				self._text_alignment_x = x
				
				self:_changed(true)
			end,
			
			get = function(self)
				return self._text_alignment_x
			end
		},
		
		textAlignmentY = {
			set = function(self, y)
				self._text_alignment_y = y
				
				self:_changed(true)
			end,
			
			get = function(self)
				return self._text_alignment_y
			end
		},
		
		textAlignment = {
			set = function(self, x, y)
				self._text_alignment_x = x
				self._text_alignment_y = y
				
				self:_changed(true)
			end,
			
			get = function(self)
				return self._text_alignment_x, self._text_alignment_y
			end
		},
		
		textWrapping = {
			set = function(self, state)
				self._text_wrap = state
				
				self:_changed(true)
				self:_wrapText()
			end,
			
			get = function(self)
				return self._text_wrap
			end
		}
	}
	
}