local Settings = {
	["scale"] = 1,
	["barsize"] = 16,
	["texture"] = "",
	["background"] = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark",
	["border"] = "Interface\\Tooltips\\UI-Tooltip-Border",
	["refresh_rate"] = 2,
}

local f = CreateFrame("Frame", "GroupXPFrame", UIParent)

f:SetAllPoints(TabParent)
f.timer = 0

CreateTab(GroupXPFrame)

f:Hide()

local groupxpTbl = {}

local function ShortNumber(number)
	if number >= 1000000000 then
		return ("%.2fB"):format(number/1000000000)
	elseif number >= 1000000 then
		return ("%.2fM"):format(number/1000000)
	elseif number >= 1000 then
		return ("%.2fK"):format(number/1000)
	else
		return number
	end
end

local function DecimalToHexColor(r, g, b, a)
	return ("|c%02x%02x%02x%02x"):format(a*255, r*255, g*255, b*255)
end

local function TableSum(table)
	local retVal = 0

	for _, n in ipairs(table) do
		retVal = retVal + n
	end

	return retVal
end

local function unitIndex(name)
	for k,v in pairs(groupxpTbl) do
		if v["name"] == name then
			return k
		end
	end
	return false
end

local function AddUnit(name, class, level, percent)
	local index = false

	for k,v in pairs(groupxpTbl) do
		if v.name == name then
			index = k
			break
		end
	end

	if index == false then
		table.insert(groupxpTbl, { ["name"] = name, ["class"] = class, ["level"] = level, ["percent"] = percent })
	else
		groupxpTbl[index].level = level
		groupxpTbl[index].percent = percent
	end
end

local function IsInParty(name)
	if strfind(name, UnitName("player"), 1) then
		return true
	end

	if IsInRaid() then
		for i=1,GetNumGroupMembers(),1 do
			if strfind(name, (UnitName("raid"..i) or "Unknown"), 1) then
				return "raid"..i
			end
		end
	elseif GetNumGroupMembers() > 0 then
		for i=1,GetNumGroupMembers(),1 do
			if strfind(name, (UnitName("party"..i) or "Unknown"), 1) then
				return "party"..i
			end
		end
	end

	return false
end

local function UnitFromName(name)
	if strfind(name, UnitName("player"), 1) then
		return true
	end

	if IsInRaid() then
		for i=1,GetNumGroupMembers(),1 do
			if strfind(name, (UnitName("raid"..i) or "Unknown"), 1) then
				return "raid"..i
			end
		end
	elseif GetNumGroupMembers() > 0 then
		for i=1,GetNumGroupMembers(),1 do
			if strfind(name, (UnitName("party"..i) or "Unknown"), 1) then
				return "party"..i
			end
		end
	end

	return false
end

local function GroupXP_Refresh()
	--GroupXPFrameSCParent
	GroupXPFrameSC:SetWidth(GroupXPFrameSCParent:GetWidth())

	local sortTbl = {}
	for k,v in ipairs(groupxpTbl) do table.insert(sortTbl, k) end
	table.sort(sortTbl, function(a,b) return groupxpTbl[a].percent > groupxpTbl[b].percent end)

	local index = 1
	for k,v in ipairs(sortTbl) do
		local bar = _G["GroupXPFrameBar"..index] or GroupXP_AddBar(index)

		--[[
		if IsInGuild(groupxpTbl[v].name) > -1 then
			local _, _, _, level, _, _, _, _, _, _, class = GetGuildRosterInfo(IsInGuild(groupxpTbl[v].name))
			--local level, class = select(4, GetGuildRosterInfoByName(groupxpTbl[v].name))
		
			if level > groupxpTbl[v].level then
				groupxpTbl[v].level = level
			end
		end
		]]

		_G["GroupXPFrameBar"..index.."Name"]:SetText(groupxpTbl[v].name)
		_G["GroupXPFrameBar"..index.."Percent"]:SetText(groupxpTbl[v].percent.."% ["..groupxpTbl[v].level.."]")	

		if groupxpTbl[v].class ~= nil then
			bar:SetStatusBarColor(RAID_CLASS_COLORS[groupxpTbl[v].class].r, RAID_CLASS_COLORS[groupxpTbl[v].class].g, RAID_CLASS_COLORS[groupxpTbl[v].class].b, 1)
		else
			bar:SetStatusBarColor(0, 1, 0, 1)
		end
		bar:SetValue(groupxpTbl[v].percent)

		if IsInParty(groupxpTbl[v].name) ~= false or IsInGuild(groupxpTbl[v].name) > -1 then
			bar:Show()
			index = index + 1
		end
	end
end

local function IsInGuild(name)
	for i=1,GetNumGuildMembers(),1 do
		if strfind(name, GetGuildRosterInfo(i), 1) or name == select(1, GetGuildRosterInfo(i)) then
			return i
		end
	end

	return -1
end

local function GetGuildRosterInfoByName(charName)
	for i=1,GetNumGuildMembers(),1 do
		local name, rank, rankIndex, level, _, _, _, _, _, _, class = GetGuildRosterInfo(i)
		if strfind(charName, name, 1) or charName == name then
			return name, rank, rankIndex, level, class
		end
	end
end

function GroupXP_AddBar(i)
	if _G["GroupXPFrameBar"..i] then return end

	local sb = CreateFrame("StatusBar", "GroupXPFrameBar"..i, GroupXPFrameSC)
	sb:SetMinMaxValues(0, 100)
	sb:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	sb:GetStatusBarTexture():SetHorizTile(false)
	sb:SetStatusBarColor(0, 1, 0)
	sb:SetValue(0)
	sb:SetHeight(Settings.barsize)

	sb:SetPoint("TOPLEFT", GroupXPFrameSC, "TOPLEFT", 0, (-2-(i*(Settings.barsize + 2)))+(Settings.barsize + 2))
	sb:SetPoint("TOPRIGHT", GroupXPFrameSC, "TOPRIGHT", -2, (-2-(i*(Settings.barsize + 2)))+(Settings.barsize + 2))

	local t = sb:CreateFontString("GroupXPFrameBar"..i.."Name", "OVERLAY", "NumberFont_Outline_Med")
	t:SetJustifyH("LEFT")
	t:SetPoint("LEFT", sb, "LEFT", 2, 0)

	local t = sb:CreateFontString("GroupXPFrameBar"..i.."Percent", "OVERLAY", "NumberFont_Outline_Med")
	t:SetJustifyH("RIGHT")
	t:SetPoint("RIGHT", sb, "RIGHT", -2, 0)

	_G["GroupXPFrameBar"..i]:SetWidth(GroupXPFrameSC:GetWidth())
	_G["GroupXPFrameBar"..i.."Name"]:SetSize((_G["GroupXPFrameBar"..i]:GetWidth()/2), Settings.barsize)
	_G["GroupXPFrameBar"..i.."Percent"]:SetSize((_G["GroupXPFrameBar"..i]:GetWidth()/2), Settings.barsize)

	GroupXPFrameSC:SetHeight(i*(Settings.barsize + 2))
	maxScroll = GroupXPFrameSC:GetHeight()-128
	numBars = i
	return _G["GroupXPFrameBar"..i]
end

local function SendXP()
	local xp = ("%.0f"):format((UnitXP("player") / UnitXPMax("player"))*100)
	if IsInRaid() then
		SendAddonMessage("GROUPXP", xp, "RAID")
	elseif GetNumGroupMembers() > 0 then
		SendAddonMessage("GROUPXP", xp, "PARTY")
	end
	SendAddonMessage("GROUPXP", xp, "GUILD")
end

local function SendRefresh()
	if IsInRaid() then
		SendAddonMessage("GROUPXP", "REFRESH", "RAID")
	elseif GetNumGroupMembers() > 0 then
		SendAddonMessage("GROUPXP", "REFRESH", "PARTY")
	end
	SendAddonMessage("GROUPXP", "REFRESH", "GUILD")
end

local function OnEvent(self, event, ...)
	if event == "PLAYER_XP_UPDATE" or event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" then
		if event == "PLAYER_ENTERING_WORLD" then
			SendRefresh()
		end
		SendXP()

		GroupXP_Refresh()
	elseif event == "PLAYER_LEVEL_UP" then
		local level = ...
		local _, GroupType = IsInInstance()

		if IsInRaid() then
			SendChatMessage("DING! Level "..level.."!", "RAID")
		elseif GetNumGroupMembers() > 0 then
			SendChatMessage("DING! Level "..level.."!", "PARTY")
		end
		SendChatMessage("DING! Level "..level.."!", "GUILD")
		SendXP()
	elseif event == "CHAT_MSG_ADDON" then
		local prefix, message, channel, sender = ...

		if prefix == "GROUPXP" then
			local class
			local level

			if GetNumGroupMembers() > 0 then
				for i=1,GetNumGroupMembers(),1 do
					if strfind(sender, (UnitName("raid"..i) or "Unknown"), 1) then
						class = select(2, UnitClass("raid"..i))
						level = UnitLevel("raid"..i)
					elseif strfind(sender, (UnitName("party"..i) or "Unknown"), 1) then
						class = select(2, UnitClass("party"..i))
						level = UnitLevel("party"..i)
					end
				end
			end
			if strfind(sender, (UnitName("player") or "Unknown"), 1) then
				class = select(2, UnitClass("player"))
				level = UnitLevel("player")
			end

			if IsInGuild(sender) > -1 then
				level, class = select(4, GetGuildRosterInfoByName(sender))
			end

			if message == "REFRESH" then
				if not strfind(sender, UnitName("player"), 1) then
					SendXP()
				end
			else
				AddUnit(sender, class, level, message)
				GroupXP_Refresh()
			end
		end
	end

	GroupXP_Refresh()
end

f:SetScript("OnEvent", OnEvent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_XP_UPDATE")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_LEVEL_UP")

RegisterAddonMessagePrefix("GROUPXP")

local scp = CreateFrame("ScrollFrame", "GroupXPFrameSCParent", GroupXPFrame)
scp:SetPoint("TOPLEFT", GroupXPFrame, "TOPLEFT", 4, -4)
scp:SetPoint("BOTTOMRIGHT", GroupXPFrame, "BOTTOMRIGHT", -4, 4)

local sc = CreateFrame("Frame", "GroupXPFrameSC", GroupXPFrameSCParent)
sc:EnableMouse(true)
sc:EnableMouseWheel(true)
--sc:SetWidth(GroupXPFrameSCParent:GetWidth())
sc:SetWidth(GroupXPFrame:GetWidth())
sc:SetHeight(((Settings.barsize + 2)*25)-2)

GroupXPFrameSCParent:SetScrollChild(sc)

f:SetScript("OnMouseWheel", function(self, delta)
	local scp = GroupXPFrameSCParent

	if delta > 0 then
		if scp:GetVerticalScroll() > 20 then
			scp:SetVerticalScroll(scp:GetVerticalScroll()-20)
		else
			scp:SetVerticalScroll(0)
		end
	else
		if scp:GetVerticalScroll() < maxScroll then
			scp:SetVerticalScroll(scp:GetVerticalScroll()+20)
		else
			scp:SetVerticalScroll(maxScroll)
		end
	end
end)
