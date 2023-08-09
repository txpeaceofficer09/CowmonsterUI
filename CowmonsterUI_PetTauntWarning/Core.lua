local f = CreateFrame("Frame", nil, UIParent)
f.timer = 0
f.lastWarning = 0

local function OnEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, event, _, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _, spellID, spellName, spellClass, failType = ...

		if event == "SPELL_CAST_SUCCESS" or event == "SPELL_MISSED" or event == "SPELL_AURA_APPLIED" then
			if bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and spellID == 2649 then
				DEFAULT_CHAT_FRAME:AddMessage("|cffff8000PetTauntWarning:|r "..srcName.." taunted "..dstName.." using "..GetSpellLink(2649)..".", 1, 1, 1, 1)
			end
		end
	end
end

local function OnUpdate(self, elapsed)

end

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)

f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
