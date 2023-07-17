local f = CreateFrame("Frame", "GroupXPFrame", UIParent)

f:SetAllPoints(TabParent)
f.timer = 0

CreateTab(GroupXPFrame)

f:Hide()

local groupxpTbl = {}

local function unitIndex(name)
	for k,v in pairs(groupxpTbl) do
		if v["name"] == name then
			return k
		end
	end
	return false
end

local function AddUnit(name, class, percent)
	local index = false

	for k,v in pairs(groupxpTbl) do
		if v.name == name then
			index = k
			break
		end
	end

	if index == false then
		table.insert(groupxpTbl, { ["name"] = name, ["class"] = class, ["percent"] = percent })
	else
		groupxpTbl[index].percent = percent
	end
end

local function IsInParty(name)
	if strfind(name, UnitName("player"), 1) then
		return true
	end

	if GetNumGroupMembers() > 0 then
		for i=1,GetNumGroupMembers(),1 do
			if strfind(name, UnitName("party"..i), 1) then
				return true
			end
		end
	end

	return false
end

for i=1, 8, 1 do
	local sb = CreateFrame("StatusBar", "GroupXPFrameBar"..i, GroupXPFrame)

	sb:SetMinMaxValues(0, 100)
	sb:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	sb:GetStatusBarTexture():SetHorizTile(false)
	sb:SetStatusBarColor(0.5, 0.5, 0.5)
	sb:SetValue(0)
	--sb:SetSize(GroupXPFrame:GetWidth()-4, 16)
	sb:SetHeight(16)

	--sb:SetPoint("TOPLEFT", GroupXPFrame, "TOPLEFT", 2, -2-((sb:GetHeight()*i)-sb:GetHeight()))
	if i == 1 then
		sb:SetPoint("TOPLEFT", GroupXPFrame, "TOPLEFT", 2, -2)
		sb:SetPoint("TOPRIGHT", GroupXPFrame, "TOPRIGHT", -2, -2)
	else
		sb:SetPoint("TOPLEFT", _G["GroupXPFrameBar"..(i-1)], "BOTTOMLEFT", 0, -2)
		sb:SetPoint("TOPRIGHT", _G["GroupXPFrameBar"..(i-1)], "BOTTOMRIGHT", 0, -2)
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

local function OnEvent(self, event, ...)
	if event == "PLAYER_XP_UPDATE" or event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" then
		--local xp = ("%s / %s (%.2f%%)"):format(UnitXP("player"), UnitXPMax("player"), (UnitXP("player") / UnitXPMax("player"))*100)
		local xp = ("%.0f"):format((UnitXP("player") / UnitXPMax("player"))*100)
		if GetNumGroupMembers() > 0 then
			SendAddonMessage("GROUPXP", xp, "PARTY")
		else
			SendAddonMessage("GROUPXP", xp, "GUILD")
		end

		--groupxpTbl[UnitName("player")] = xp
	elseif event == "PLAYER_LEVEL_UP" then
		local level = ...
		SendChatMessage("DING! Level "..level.."!", "GUILD")
	elseif event == "CHAT_MSG_ADDON" then
		local prefix, message, channel, sender = ...

		if prefix == "GROUPXP" then
			local class
			if GetNumGroupMembers() > 0 then
				for i=1,GetNumGroupMembers(),1 do
					if strfind(sender, (UnitName("party"..i) or "Unknown"), 1) then
						class = select(2, UnitClass("party"..i))
					end
				end
			end
			if strfind(sender, (UnitName("player") or "Unknown"), 1) then
				class = select(2, UnitClass("player"))
			end

			--groupxpTbl[sender] = { ["percent"] = message, ["class"] = class, ["name"] = sender }
			AddUnit(sender, class, message)
		end
	end

	local sortTbl = {}
	for k,v in ipairs(groupxpTbl) do table.insert(sortTbl, k) end
	table.sort(sortTbl, function(a,b) return groupxpTbl[a].percent > groupxpTbl[b].percent end)

	local index = 1
	for k,v in ipairs(sortTbl) do
		if index <= 8 then
			if IsInParty(groupxpTbl[v].name) ~= false then
				local bar = _G["GroupXPFrameBar"..index]
				_G["GroupXPFrameBar"..index.."Name"]:SetText(groupxpTbl[v].name)
				_G["GroupXPFrameBar"..index.."Percent"]:SetText(groupxpTbl[v].percent.."%")	

				if groupxpTbl[v].class ~= nil then
					bar:SetStatusBarColor(RAID_CLASS_COLORS[groupxpTbl[v].class].r, RAID_CLASS_COLORS[groupxpTbl[v].class].g, RAID_CLASS_COLORS[groupxpTbl[v].class].b, 1)
				else
					bar:SetStatusBarColor(0, 1, 0, 1)
				end

				bar:SetValue(groupxpTbl[v].percent)
				bar:Show()
				index = index + 1
			end
		end
	end
end

f:SetScript("OnEvent", OnEvent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_XP_UPDATE")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_LEVEL_UP")

RegisterAddonMessagePrefix("GROUPXP")