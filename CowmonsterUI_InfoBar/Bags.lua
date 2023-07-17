function InfoBarBags_OnClick(self, button)
	ToggleAllBags()
end

function InfoBarBags_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then

		self.timer = 0
	end
end

function InfoBarBags_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "BAG_UPDATE" then
		local free = 0
		local total = 0

		for i=0,4,1 do
			local numFreeSlots, bagFamily = GetContainerNumFreeSlots(i)
			free = free + numFreeSlots

			local numSlots = GetContainerNumSlots(i)

			total = total + numSlots
		end

		InfoBarSetText("InfoBarBags", "Bags: %s / %s", free, total)
	end
end
