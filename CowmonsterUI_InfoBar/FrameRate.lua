function InfoBarFPS_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		if GetFramerate() <= 15 then
			InfoBarSetText("InfoBarFPS", "|cFFFF0000%.0f |cFFFFFFFFFPS ", GetFramerate())
		elseif GetFramerate() <= 25 then
			InfoBarSetText("InfoBarFPS", "|cFFFF8000%.0f |cFFFFFFFFFPS ", GetFramerate())
		elseif GetFramerate() <= 35 then
			InfoBarSetText("InfoBarFPS", "|cFFFFFF00%.0f |cFFFFFFFFFPS ", GetFramerate())
		else
			InfoBarSetText("InfoBarFPS", "|cFF00FF00%.0f |cFFFFFFFFFPS ", GetFramerate())
		end			

		self.timer = 0
	end
end