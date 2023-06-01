function InfoBarMem_OnEnter(self)
	if UnitAffectingCombat("player") then return end

	InfoBarTooltip:ClearLines()
	InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	InfoBarTooltip:AddLine("AddOn Memory Usage:")
	InfoBarTooltip:AddLine(" ")

	local AddOnMemoryDB = {}

	for i = 1, GetNumAddOns(), 1 do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		local memory = tonumber(("%.2f"):format(GetAddOnMemoryUsage(i)))

		if enabled and memory > 0 then
			tinsert(AddOnMemoryDB, {["title"] = title, ["memory"] = memory })
		end
	end
	sort(AddOnMemoryDB, function(a,b) return a.memory>b.memory end)

	for k, v in pairs(AddOnMemoryDB) do
		InfoBarTooltip:AddDoubleLine(k..". "..v.title, v.memory.." KB")
	end


	wipe(AddOnMemoryDB)	
	InfoBarTooltip:Show()
end

function InfoBarMem_OnLeave(self)
	InfoBarTooltip:Hide()
	InfoBarTooltip:ClearLines()
end

function InfoBarMem_OnUpdate(self, elapsed)
	InfoBarMem_tmr = (InfoBarMem_tmr or 0) + elapsed

	if InfoBarMem_tmr >= 1 then
		local memory = 0

		for i = 1, GetNumAddOns(), 1 do
			memory = memory+GetAddOnMemoryUsage(i)
		end

		if memory >= 1024 then
			InfoBarSetText("InfoBarMem", "Memory: %.2f MB", (memory/1024))
		else
			InfoBarSetText("InfoBarMem", "Memory: %.2f KB", memory)
		end

		InfoBarMem_tmr = 0
	end
end