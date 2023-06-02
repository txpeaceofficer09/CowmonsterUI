local f = CreateFrame("Frame", nil, UIParent)
f.NoAnnounce = 0
local taunts = {
	"Growl",
	"Challenging Roar",
	"Mocking Blow",
	"Intimidation",
	"Intimidating Shout",
	"Hand of Reckoning",
}

f:SetScript("OnEvent", function(self, event, ...)
	if event == "COMBATLOG_EVENT_UNFILTERED" then
		local timestamp, event, hideCaster, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _, spellID, spellName, spellSchool = ...

		if ( bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 or bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) > 0 ) and not bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
			if table.contains(taunts, spellName) then
				if bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PET) then
					local owner = GetPlayerInfoByGUID(srcGUID)
					--local message = owner.."'s pet "..srcName.." taunted "..dstName.." using "..spellName
					local message = ("%s's pet, %s, taunted %s using %s."):format(owner, srcName, dstName, spellName)
				else
					--local message = srcName.." taunted "..dstName.." using "..spellName
					local message = ("%s taunted %s using %s."):format(srcName, dstName, spellName)
				end

				if IsInRaid() then
					SendChatMessage(message, "RAID")
				else
					SendChatMessage(message, "PARTY")
				end
			end
		end
	end
end)

--[[
f:SetScript("OnUpdate", function(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		if f.NoAnnounce > 0 then f.NoAnnounce = f.NoAnnounce - 1 end

		self.timer = 0
	end
end)
]]

f:RegisterEvent("COMBATLOG_EVENT_UNFILTERED")