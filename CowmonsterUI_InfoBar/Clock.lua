function InfoBarClock_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		local timestamp = date("*t", time())
		
		if timestamp.min < 10 then timestamp.min = "0"..timestamp.min end
		if timestamp.sec < 10 then timestamp.sec = "0"..timestamp.sec end

		InfoBarSetText("InfoBarClock", "[%s:%s:%s]", timestamp.hour, timestamp.min, timestamp.sec)

		if TimeManagerClockButton:IsShown() then
			TimeManagerClockButton:Hide()
		end

		self.timer = 0
	end
end