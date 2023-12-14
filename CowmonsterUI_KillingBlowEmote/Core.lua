local f = CreateFrame("Frame", nil, UIParent)

local function GetRandomEmote()
	return emotes[math.random(1, #(emotes))]
end

local function OnEvent(self, event, ...)
	local _, subEvent, _, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags = ...
	
	if subEvent == "PARTY_KILL" then
		if srcGUID == UnitGUID("player") and ( bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 and bit.band(dstFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 ) and not ( bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 or bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) > 0 or bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 ) then
			if select(4, GetAchievementInfo(247)) then -- Check if you already have the achievement for hugging a fallen enemy.
				DoEmote(GetRandomEmote(), dstName) -- You already have the hug achievement, so just do a random emote from the list.
			else
				DoEmote("HUG", dstName) -- You do not yet have the achievement so try to hug the enemy before they release.
			end
		end
	end
end

f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

f:SetScript("OnEvent", OnEvent)