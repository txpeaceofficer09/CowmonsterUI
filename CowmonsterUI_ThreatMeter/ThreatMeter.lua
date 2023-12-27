local f = CreateFrame("Frame", "ThreatFrame", UIParent)

f:SetAllPoints(TabParent)
f.timer = 0

CreateTab(ThreatFrame)

f:Hide()

local function UpdateThreat(threatTarget)
	local isInstance, instanceType = IsInInstance()
	local threatTbl = {}
	local sortTbl = {}

	if UnitExists(threatTarget) then
		if IsInRaid() and GetNumGroupMembers() > 0 then
			for i=1,GetNumGroupMembers(),1 do
				local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("raid"..i, threatTarget)

				table.insert(threatTbl, {["isTanking"] = isTanking or 0, ["status"] = status or 0, ["scaledPercent"] = scaledPercent or 0, ["rawPercent"] = rawPercent or 0, ["threatValue"] = threatValue or 0, ["unit"] = "raid"..i, ["name"] = UnitName("raid"..i) })

				if UnitExists("raid"..i.."pet") then
					local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("raid"..i.."pet", threatTarget)

					table.insert(threatTbl, {["isTanking"] = isTanking or 0, ["status"] = status or 0, ["scaledPercent"] = scaledPercent or 0, ["rawPercent"] = rawPercent or 0, ["threatValue"] = threatValue, ["unit"] = "raid"..i.."pet", ["name"] = UnitName("raid"..i.."pet") })
				end
			end
		elseif GetNumGroupMembers() > 0 then
			for i=1,GetNumGroupMembers(),1 do
				local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("party"..i, threatTarget)

				table.insert(threatTbl, {["isTanking"] = isTanking or 0, ["status"] = status or 0, ["scaledPercent"] = scaledPercent or 0, ["rawPercent"] = rawPercent or 0, ["threatValue"] = threatValue or 0, ["unit"] = "party"..i, ["name"] = UnitName("party"..i) })

				if UnitExists("party"..i.."pet") then
					local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("party"..i.."pet", threatTarget)

					table.insert(threatTbl, {["isTanking"] = isTanking or 0, ["status"] = status or 0, ["scaledPercent"] = scaledPercent or 0, ["rawPercent"] = rawPercent or 0, ["threatValue"] = threatValue or 0, ["unit"] = "party"..i.."pet", ["name"] = UnitName("party"..i.."pet") })
				end
			end

			local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("player", threatTarget)

			table.insert(threatTbl, {["isTanking"] = isTanking or 0, ["status"] = status or 0, ["scaledPercent"] = scaledPercent or 0, ["rawPercent"] = rawPercent or 0, ["threatValue"] = threatValue or 0, ["unit"] = "player", ["name"] = UnitName("player") })

			if UnitExists("playerpet") then
				local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("playerpet", threatTarget)

				table.insert(threatTbl, {["isTanking"] = isTanking or 0, ["status"] = status or 0, ["scaledPercent"] = scaledPercent or 0, ["rawPercent"] = rawPercent or 0, ["threatValue"] = threatValue or 0, ["unit"] = "playerpet", ["name"] = UnitName("playerpet") })
			end
		else
			local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("player", threatTarget)

			table.insert(threatTbl, {["isTanking"] = isTanking or 0, ["status"] = status or 0, ["scaledPercent"] = scaledPercent or 0, ["rawPercent"] = rawPercent or 0, ["threatValue"] = threatValue or 0, ["unit"] = "player", ["name"] = UnitName("player") })

			if UnitExists("playerpet") then
				local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("playerpet", threatTarget)

				table.insert(threatTbl, {["isTanking"] = isTanking or 0, ["status"] = status or 0, ["scaledPercent"] = scaledPercent or 0, ["rawPercent"] = rawPercent or 0, ["threatValue"] = threatValue or 0, ["unit"] = "playerpet", ["name"] = UnitName("playerpet") })
			end
		end
	end

	for k,v in pairs(threatTbl) do table.insert(sortTbl, k) end

	table.sort(sortTbl, function(a,b) return threatTbl[a].rawPercent > threatTbl[b].rawPercent end)

	for k,v in ipairs(sortTbl) do
		if k <= 8 then
			_G["ThreatFrameBar"..k.."Name"]:SetText(threatTbl[v].name)
			_G["ThreatFrameBar"..k.."Percent"]:SetText((threatTbl[v].threatValue or 0).." ("..string.format("%.0f", threatTbl[v].scaledPercent).."%)")
			_G["ThreatFrameBar"..k]:SetValue(threatTbl[v].scaledPercent)

			if threatTbl[v].scaledPercent > 0 then
				if (threatTbl[v].unit):find("pet") then
					_G["ThreatFrameBar"..k]:SetStatusBarColor(0, 1, 0, 1)
				else
					_G["ThreatFrameBar"..k]:SetStatusBarColor(RAID_CLASS_COLORS[select(2, UnitClass(threatTbl[v].unit))].r, RAID_CLASS_COLORS[select(2, UnitClass(threatTbl[v].unit))].g, RAID_CLASS_COLORS[select(2, UnitClass(threatTbl[v].unit))].b, RAID_CLASS_COLORS[select(2, UnitClass(threatTbl[v].unit))].a)
				end

				_G["ThreatFrameBar"..k]:Show()
			else
				_G["ThreatFrameBar"..k]:Hide()
			end
		end
	end
end

for i=1, 8, 1 do
	local sb = CreateFrame("StatusBar", "ThreatFrameBar"..i, ThreatFrame)

	sb:SetMinMaxValues(0, 100)
	sb:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	sb:GetStatusBarTexture():SetHorizTile(false)
	sb:SetStatusBarColor(0.5, 0.5, 0.5)
	sb:SetValue(0)
	--sb:SetSize(ThreatFrame:GetWidth()-4, 16)
	sb:SetHeight(16)

	--sb:SetPoint("TOPLEFT", ThreatFrame, "TOPLEFT", 2, -2-((sb:GetHeight()*i)-sb:GetHeight()))
	if i == 1 then
		sb:SetPoint("TOPLEFT", ThreatFrame, "TOPLEFT", 2, -2)
		sb:SetPoint("TOPRIGHT", ThreatFrame, "TOPRIGHT", -2, -2)
	else
		sb:SetPoint("TOPLEFT", _G["ThreatFrameBar"..(i-1)], "BOTTOMLEFT", 0, -2)
		sb:SetPoint("TOPRIGHT", _G["ThreatFrameBar"..(i-1)], "BOTTOMRIGHT", 0, -2)
	end

	local t = sb:CreateFontString(sb:GetName().."Name", "OVERLAY", "NumberFont_Outline_Med")
	t:SetJustifyH("LEFT")
	t:SetSize((sb:GetWidth()/2)-4, sb:GetHeight())
	t:SetPoint("LEFT", sb, "LEFT", 2, 0)
	t:SetTextColor(0.8, 0.8, 0.8, 1)

	local t = sb:CreateFontString(sb:GetName().."Percent", "OVERLAY", "NumberFont_Outline_Med")
	t:SetJustifyH("RIGHT")
	t:SetSize((sb:GetWidth()/2)-4, sb:GetHeight())
	t:SetPoint("RIGHT", sb, "RIGHT", -2, 0)
	t:SetTextColor(0.8, 0.8, 0.8, 1)
end

--local function OnUpdate(self, elapsed)
--	if ( UnitExists(threatTarget) and UnitIsFriend("player", threatTarget) ) or not f:IsShown() or select(2, IsInInstance()) == "battleground" or select(2, IsInInstance()) == "arena" then return end
--
--	self.timer = self.timer + elapsed
--
--	if self.timer >= 0.5 then
--		UpdateThreat(threatTarget)
--
--		self.timer = 0
--	end
--end

local function OnEvent(self, event, ...)
	if event == "UNIT_THREAT_LIST_UPDATE" and select(2, IsInInstance()) ~= "pvp" and select(2, IsInInstance()) ~= "arena" then
		local tgt = ... or "target"

		if UnitExists(tgt) and UnitIsFriend("player", tgt) then
			-- Possibly use targettarget instead of nil to display a threat list.
			UpdateThreat(tgt)
		else
			UpdateThreat("target")
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		for i=1,8,1 do
			_G["ThreatFrameBar"..i]:Hide()
		end
	end
end

f:SetScript("OnEvent", OnEvent)
--f:SetScript("OnUpdate, OnUpdate)

f:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
