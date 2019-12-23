local GUI = GUI

return {
	inherit = "container",
	constructor = function(self)
		
	end,
	
	----------------------------------------
	
	data = {
		_text_color = false,
		
		_text = "",
		_font = false,
		_text_alignment_x = 1,
		_text_alignment_y = 1,
		_text_wrap = false,
		
		_text_raw = "",
		_text_height = 0,
		
		------------------------------
		
		_wrapText = function(self)
			local str = ""
			local line = ""
			local height = nil
			
			self._text_height = 0
			render.setFont(self.font)
			
			for spacer, word in string.gmatch(self._text_raw, "(%s*)(%S+)") do
				if string.find(spacer, "\n") then
					str = str .. line .. "\n"
					line = word
					
					self._text_height = self._text_height + height
				else
					local w, h = render.getTextSize(line .. spacer .. word)
					
					if not height then
						height = h
					end
					
					if w > self._w then
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
		
		_setTextHeight = function(self)
			render.setFont(self.font)
			
			local _, h = render.getTextSize(self._text)
			self._text_height = h
		end,
		
		------------------------------
		
		onDraw = function(self, w, h)
			base()
			
			local ax, ay = self._text_alignment_x, self._text_alignment_y
			local th = self._text_height
			local to = h - th
			local to2 = to / 2
			
			render.setFont(self.font)
			render.setColor(self.textColor)
			render.drawText(ax == 0 and to2 or (ax == 1 and w / 2 or w - to2), ay == 3 and to2 or (ay == 1 and to2 or h - th), self._text, ax)
		end
	},
	
	----------------------------------------
	
	properties = {
		mainColor = {
			set = function(self, color)
				self._main_color = color
				
				self:_changed(true)
			end,
			
			get = function(self)
				local clr = self._main_color
				return clr and (type(clr) == "string" and self._theme[clr] or clr) or self._theme.primaryColorDark
			end
		},
		
		textColor = {
			set = function(self, color)
				self._text_color = color
				
				self:_changed(true)
			end,
			
			get = function(self)
				local clr = self._text_color
				return clr and (type(clr) == "string" and self._theme[clr] or clr) or self._theme.primaryTextColor
			end
		},
		
		------------------------------
		
		text = {
			set = function(self, text)
				self._text_raw = text
				
				self:_changed(true)
				
				if self._text_wrap then
					self:_wrapText()
				else
					self._text = self._text_raw
					self:_setTextHeight()
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
				else
					self:_setTextHeight()
				end
			end,
			
			get = function(self)
				return self._font or self._theme.font
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