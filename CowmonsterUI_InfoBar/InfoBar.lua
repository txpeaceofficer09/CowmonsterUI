local InfoBarXPtoggle
local playerName = UnitName("player")
local playerRealm = GetRealmName()
local tmr = 0
local InfoBarStrings = {
	[1] = {
		["Name"] = "InfoBarMoney",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarMoney_OnEnter",
			["OnLeave"] = "InfoBarMoney_OnLeave",
		},
	},
	[2] = {
		["Name"] = "InfoBarXP",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarXP_OnEnter",
			["OnLeave"] = "InfoBarXP_OnLeave",
			["OnClick"] = "InfoBarXP_OnClick",
		},
	},
	[3] = {
		["Name"] = "InfoBarMem",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarMem_OnEnter",
			["OnLeave"] = "InfoBarMem_OnLeave",
		},
	},
	[4] = {
		["Name"] = "InfoBarLat",
		["JustifyH"] = "RIGHT",
	},
	[5] = {
		["Name"] = "InfoBarFPS",
		["JustifyH"] = "RIGHT",
	},
	[6] = {
		["Name"] = "InfoBarClock",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnUpdate"] = "InfoBarClock_OnUpdate",
		},
	},
}

function InfoBarMoney_OnEnter(self)
	if UnitAffectingCombat("player") then return end

	InfoBarTooltip:ClearLines()
	InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	InfoBarTooltip:AddLine("Money:")
	InfoBarTooltip:AddLine(" ")

	local Money = 0

	for k, v in pairs(CowmonsterUIDB) do
		InfoBarTooltip:AddLine(k)
		InfoBarTooltip:AddLine("-----------------------")

		for a, b in pairs(v) do
			InfoBarTooltip:AddDoubleLine(a, GetCoinTextureString(b.Money or 0))
			Money = Money + (b.Money or 0)
		end
		InfoBarTooltip:AddLine("-----------------------")
	end
	InfoBarTooltip:AddDoubleLine("Total", GetCoinTextureString(Money))

	InfoBarTooltip:Show()
end

function InfoBarMoney_OnLeave(self)
	InfoBarTooltip:Hide()
	InfoBarTooltip:ClearLines()
end

function InfoBarXP_OnEnter(self)
	if UnitAffectingCombat("player") then return end

--	local db = CowmonsterUIDB[GetRealmName()][UnitName("player")].Settings or {}

	InfoBarTooltip:ClearLines()
	InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	if InfoBarXPtoggle == "reputation" then
		InfoBarTooltip:AddLine("Reputation")

		ExpandAllFactionHeaders()
		for i = 1, GetNumFactions(), 1 do
			local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(i)
			if name == "Inactive" then CollapseFactionHeader(i) end

			if not atWarWith and ( hasRep or isChild ) then
				local currentXP, totalXP = (barValue - barMin), (barMax - barMin)

				if standingID == 1 then standing = InfoBarTooltip:AddDoubleLine("|cff800000"..name, floor((currentXP/totalXP)*100).."%") end
				if standingID == 2 then standing = InfoBarTooltip:AddDoubleLine("|cffff0000"..name, floor((currentXP/totalXP)*100).."%") end
				if standingID == 3 then standing = InfoBarTooltip:AddDoubleLine("|cffff8000"..name, floor((currentXP/totalXP)*100).."%") end
				if standingID == 4 then standing = InfoBarTooltip:AddDoubleLine("|cffffff00"..name, floor((currentXP/totalXP)*100).."%") end
				if standingID == 5 then standing = InfoBarTooltip:AddDoubleLine("|cff80ff80"..name, floor((currentXP/totalXP)*100).."%") end
				if standingID == 6 then standing = InfoBarTooltip:AddDoubleLine("|cff00ff00"..name, floor((currentXP/totalXP)*100).."%") end
				if standingID == 7 then standing = InfoBarTooltip:AddDoubleLine("|cff6060ff"..name, floor((currentXP/totalXP)*100).."%") end
				if standingID == 8 then standing = InfoBarTooltip:AddDoubleLine("|cffff00ff"..name, floor((currentXP/totalXP)*100).."%") end
			end
		end
--	elseif InfoBarXPtoggle == "guildxp" then
--		InfoBarTooltip:AddLine("Guild Experience")
--		InfoBarTooltip:AddLine("Click to change displayed information.")
	else
		InfoBarTooltip:AddLine("Experience")
		InfoBarTooltip:AddLine("Click to change displayed information.")
	end

	InfoBarTooltip:Show()
end

function InfoBarXP_OnLeave(self)
	InfoBarTooltip:Hide()
	InfoBarTooltip:ClearLines()
end

function InfoBarXP_OnClick(self, button)
--	local db = CowmonsterUIDB[GetRealmName()][UnitName("player")].Settings or {}
	InfoBarXPtoggle = InfoBarXPtoggle or "xp"

	if InfoBarXPtoggle == "xp" then
		InfoBarXPtoggle = "reputation"
--	elseif InfoBarXPtoggle == "guildxp" then
--		if UnitLevel("player") == GetMaxPlayerLevel() then
--			InfoBarXPtoggle = "reputation"
--		else
--			InfoBarXPtoggle = "xp"
--		end
--	elseif InfoBarXPtoggle == "reputation" then
--		InfoBarXPtoggle = "guildxp"
	else
		InfoBarXPtoggle = "xp"
	end

	SetCVar("InfoBarXPtoggle", InfoBarXPtoggle)

--	CowmonsterUIDB[GetRealmName()][UnitName("player")].Settings = db

	InfoBarXP_OnLeave(self)
	InfoBarXP_OnEnter(self)
	InfoBarXP_Update()
end

function InfoBarXP_Update()
	if not GetCVar("InfoBarXPtoggle") then
		RegisterCVar("InfoBarXPtoggle", "xp")
	end

	InfoBarXPtoggle = GetCVar("InfoBarXPtoggle")

--	local db = CowmonsterUIDB[playerRealm][playerName].Settings or {}
--	InfoBarXPtoggle = InfoBarXPtoggle or "xp"

	if UnitLevel("player") == GetMaxPlayerLevel() and InfoBarXPtoggle == "xp" then InfoBarXPtoggle = "reputation" end

	if InfoBarXPtoggle == "reputation" then
		local name, standingID, barMin, barMax, barValue = GetWatchedFactionInfo()
		local standing

		if name then
			if standingID == 1 then standing = "Hated" end
			if standingID == 2 then standing = "Hostile" end
			if standingID == 3 then standing = "Unfriendly" end
			if standingID == 4 then standing = "Neutral" end
			if standingID == 5 then standing = "Friendly" end
			if standingID == 6 then standing = "Honored" end
			if standingID == 7 then standing = "Revered" end
			if standingID == 8 then standing = "Exalted" end

			local currentXP, totalXP = (barValue - barMin), (barMax - barMin)
			InfoBarSetText("InfoBarXP", "%s: %s / %s (%.2f%%) (%s)", name, ShortNumber(currentXP), ShortNumber(totalXP), ((currentXP/totalXP)*100), standing)
		else
			InfoBarSetText("InfoBarXP", nil, "Faction: None Watched")
		end
--	elseif InfoBarXPtoggle == "guildxp" then
--		if IsInGuild() then
--
--			ExpandAllFactionHeaders()
--			for i = 1, GetNumFactions(), 1 do
--				local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(i)
--				if name == "Inactive" then CollapseFactionHeader(i) end
--
--				if name == GetGuildInfo("player") and ( hasRep or isChild ) then
--					InfoBarSetText("InfoBarXP", "Guild Exp: %s / %s (%.2f%%) (Lvl: %d)", ShortNumber(barValue), ShortNumber(barMax), ((barValue/barMax)*100), GetGuildLevel())
--					return
--				end
--			end

--			local currentXP, nextLevelXP = UnitGetGuildXP("player")
--			totalXP = currentXP + nextLevelXP
--
--			if totalXP > 0 then
--				InfoBarSetText("InfoBarXP", "Guild Exp: %s / %s (%.2f%%) (Lvl: %d)", ShortNumber(currentXP), ShortNumber(totalXP), ((currentXP/totalXP)*100), GetGuildLevel())
--			else
--				InfoBarSetText("InfoBarXP", "Guild Exp: %s", "Not parsed from server yet.")
--			end
--		else
--			InfoBarSetText("InfoBarXP", nil, "Guild Exp: Guildless")
--		end
	else
		if UnitLevel("player") ~= GetMaxPlayerLevel() then
			local currentXP, totalXP = UnitXP("player"), UnitXPMax("player")
			InfoBarSetText("InfoBarXP", "Exp: %s / %s (%.2f%%) (%d Rested)", ShortNumber(currentXP), ShortNumber(totalXP), ((currentXP/totalXP)*100), GetXPExhaustion() or 0)
		else
			InfoBarSetText("InfoBarXP", nil, "Exp: Max Level!")
		end
	end
end

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

function InfoBarClock_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		local timestamp = date("*t", time())
		
		if timestamp.min < 10 then timestamp.min = "0"..timestamp.min end
		if timestamp.sec < 10 then timestamp.sec = "0"..timestamp.sec end

		InfoBarSetText("InfoBarClock", "[%s:%s:%s]", timestamp.hour, timestamp.min, timestamp.sec)

		self.timer = 0
	end
end

local f = CreateFrame("Frame", "InfoBarFrame", UIParent)
local t = CreateFrame("GameTooltip", "InfoBarTooltip", UIParent, "GameTooltipTemplate")

f:SetHeight(20)
f:ClearAllPoints()
f:SetPoint("TOPLEFT", ActionBar1, "BOTTOMLEFT", -2, -2)
f:SetPoint("TOPRIGHT", ActionBar2, "BOTTOMRIGHT", 2, -2)
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )
--f:SetBackdrop( { bgFile = "Interface\\BUTTONS\\BLUEGRAD64", edgeFile = nil, tile = true, tileSize = 20, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

for k, v in ipairs(InfoBarStrings) do
	local b = CreateFrame("Button", v.Name, InfoBarFrame)
	local s = b:CreateFontString(v.Name.."Text", "ARTWORK", "NumberFont_Outline_Med")
	s:SetAllPoints(b)

	s:SetJustifyH(v.JustifyH)
	b:SetHeight(f:GetHeight())

	if v.Scripts then
		for i, a in pairs(v.Scripts) do
			--b:SetScript(i, _G[v.Name.."_"..i])
			b:SetScript(i, _G[a])
		end
	end

	s:Show()
	b:Show()
end

f:Show()

function InfoBarSetText(i, format, ...)
	if type(i) ~= "number" then
		for k, v in pairs(InfoBarStrings) do
			if v.Name == i then i = k end
		end
	end

	if not InfoBarStrings or not InfoBarStrings[i] then
		return
	end

	local btn = _G[InfoBarStrings[i].Name]
	local str = _G[InfoBarStrings[i].Name.."Text"] --or f:CreateFontString(InfoBarStrings[i].Name, "ARTWORK", "NumberFont_Outline_Med")

	if format then
		str:SetFormattedText(format, ...)
	else
		str:SetText(select(1, ...))
	end

	btn:SetWidth(str:GetStringWidth()+30)

	for i = 1, floor(#(InfoBarStrings)/2), 1 do
		local s = _G[InfoBarStrings[i].Name]

		if i == 1 then
			s:SetPoint("TOPLEFT", InfoBarFrame, "TOPLEFT", 10, 0)
		else
			s:SetPoint("TOPLEFT", _G[InfoBarStrings[(i-1)].Name], "TOPRIGHT", 0, 0)
		end
	end

	for i = #(InfoBarStrings), floor(#(InfoBarStrings)/2)+1, -1 do
		local s = _G[InfoBarStrings[i].Name]

		if i == #(InfoBarStrings) then
			s:SetPoint("TOPRIGHT", InfoBarFrame, "TOPRIGHT", -10, 0)
		else
			s:SetPoint("TOPRIGHT", _G[InfoBarStrings[(i+1)].Name], "TOPLEFT", 0, 0)
		end
	end
end

function f.OnUpdate(self, elapsed)
	tmr = tmr + elapsed

	if tmr >= 1 then
		local memory = 0

		for i = 1, GetNumAddOns(), 1 do
			memory = memory+GetAddOnMemoryUsage(i)
		end

		if memory >= 1024 then
			InfoBarSetText("InfoBarMem", "Memory: %.2f MB", (memory/1024))
		else
			InfoBarSetText("InfoBarMem", "Memory: %.2f KB", memory)
		end

		local _, _, home, world = GetNetStats()
		local homeClr = { ["r"] = 0, ["g"] = 0, ["b"] = 0 }
		local worldClr = { ["r"] = 0, ["g"] = 0, ["b"] = 0 }

		if home <= 200 then
			homeClr.g = 255
		elseif home <= 300 then
			homeClr.r = 255
			homeClr.g = 255
		elseif home <= 400 then
			homeClr.r = 255
			homeClr.g = 128
		else
			homeClr.r = 255
		end

		if world <= 200 then
			worldClr.g = 255
		elseif world <= 300 then
			worldClr.r = 255
			worldClr.g = 255
		elseif world <= 400 then
			worldClr.r = 255
			worldClr.g = 128
		else
			worldClr.r = 255
		end

		InfoBarSetText("InfoBarLat", "|cff%02x%02x%02x%.0f |cFFFFFFFF(|cff%02x%02x%02x%.0f|cFFFFFFFF) MS", homeClr.r, homeClr.g, homeClr.b, home, worldClr.r, worldClr.g, worldClr.b, world)

		if GetFramerate() <= 15 then
			InfoBarSetText("InfoBarFPS", "|cFFFF0000%.0f |cFFFFFFFFFPS ", GetFramerate())
		elseif GetFramerate() <= 25 then
			InfoBarSetText("InfoBarFPS", "|cFFFF8000%.0f |cFFFFFFFFFPS ", GetFramerate())
		elseif GetFramerate() <= 35 then
			InfoBarSetText("InfoBarFPS", "|cFFFFFF00%.0f |cFFFFFFFFFPS ", GetFramerate())
		else
			InfoBarSetText("InfoBarFPS", "|cFF00FF00%.0f |cFFFFFFFFFPS ", GetFramerate())
		end			

		tmr = 0
	end
end

function f.OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		InfoBarSetText("InfoBarMoney", nil, GetCoinTextureString(GetMoney()))

		--CowmonsterUIDB[GetRealmName()][UnitName("player")].Money = GetMoney()
	elseif event == "PLAYER_MONEY" then
		InfoBarSetText("InfoBarMoney", nil, GetCoinTextureString(GetMoney()))

		CowmonsterUIDB[GetRealmName()][UnitName("player")].Money = GetMoney()
	end

	if --[[event == "VARIABLES_LOADED" or]] event == "UPDATE_FACTION" or event == "CHAT_MSG_COMBAT_XP_GAIN" or event == "GUILD_XP_UPDATE" or event == "CHAT_MSG_COMBAT_GUILD_XP_GAIN" then
		InfoBarXP_Update()
	end

	if event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
		local currentName = GetWatchedFactionInfo()
		local msg = select(1, ...)
		local newFaction, amount = string.match(msg, "Reputation with (.+) increased by (%d+).")

		if newFaction and newFaction ~= currentName then
			ExpandAllFactionHeaders()

			for i = 1, GetNumFactions(), 1 do
				local name = GetFactionInfo(i)

				if name == newFaction then
					SetWatchedFactionIndex(i)
				end

				if name == "Inactive" then
					CollapseFactionHeader(i)
					break
				end
			end
		end

		InfoBarXP_Update()
	end

	if event == "VARIABLES_LOADED" then
		CowmonsterUIDB[GetRealmName()] = CowmonsterUIDB[GetRealmName()] or {}
		CowmonsterUIDB[GetRealmName()][UnitName("player")] = CowmonsterUIDB[GetRealmName()][UnitName("player")] or {["Settings"]={}}

--		self:SetWidth(GetScreenWidth())
		self:SetPoint("CENTER", UIParent, "CENTER", 0, 10-(GetScreenHeight()/2))
	end
end

f:RegisterEvent("PLAYER_MONEY")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("UPDATE_FACTION")
f:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
f:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
f:RegisterEvent("CHAT_MSG_COMBAT_GUILD_XP_GAIN")
f:RegisterEvent("GUILD_XP_UPDATE")

f:SetScript("OnUpdate", f.OnUpdate)
f:SetScript("OnEvent", f.OnEvent)

local t = f:CreateTexture(nil, "ARTWORK")
t:SetAllPoints(f)
t:Show()
t:SetTexture("Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill")
t:SetVertexColor(0.2, 0.2, 0.2)
