local f = CreateFrame("Frame", nil, UIParent)

function MoveRaidFrames()
	if IsInRaid() and GetNumGroupMembers() > 0 then
		limit = GetNumGroupMembers()
	elseif GetNumGroupMembers() > 0 then
		limit = GetNumGroupMembers()+1
	else
		return
	end

	for i=1,limit do
		local crf = _G["CompactRaidFrame"..i]
		crf:ClearAllPoints()

		if crf ~= nil then
			if i == 1 then
				crf:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 500, 180)
			elseif i <= 12 then
				crf:SetPoint("LEFT", _G["CompactRaidFrame"..(i-1)], "RIGHT", 2, 0)
			else
				crf:SetPoint("BOTTOM", _G["CompactRaidFrame"..(i-12)], "TOP", 0, 2)
			end
		end
	end
end

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED" then
		PlayerFrame:ClearAllPoints()
		PlayerFrame:SetPoint("BOTTOMLEFT", 500, 250, UIParent, "BOTTOMLEFT")

		TargetFrame:ClearAllPoints()
		TargetFrame:SetPoint("BOTTOMRIGHT", -500, 250, UIParent, "BOTTOMRIGHT")

		-- MoveRaidFrames()
	elseif event == "VARIABLES_LOADED" then

	end
end

f:SetScript("OnEvent", OnEvent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("RAID_ROSTER_UPDATE")
f:RegisterEvent("PARTY_MEMBERS_UPDATE")
-- f:RegisterEvent("VARIABLES_LOADED")