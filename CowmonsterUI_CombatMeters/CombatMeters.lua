local f = CreateFrame("Frame", "CombatMetersFrame", UIParent)

function f.TableCount(tbl)
	local cnt = 0

	for k,v in pairs(tbl) do
		cnt = cnt + 1
	end

	return cnt
end

local Buttons = {
	"Reset",
	"Menu",
	"Report",
	"Segment",
}

local CombatMetersDisplay = "dps"
local CombatMetersFightIndex = "current"

local maxScroll = 0
local numBars = 1

local pets = {}

f:SetAllPoints(TabParent)
f:SetScript("OnShow", CombatMeters_Refresh)

CreateFrame("ScrollFrame", "CombatMetersFrameSCParent", CombatMetersFrame)
CombatMetersFrameSCParent:SetPoint("TOPLEFT", CombatMetersFrame, "TOPLEFT", 0, -22)
CombatMetersFrameSCParent:SetPoint("BOTTOMRIGHT", CombatMetersFrame, "BOTTOMRIGHT", 0, 0)

local sc = CreateFrame("Frame", "CombatMetersFrameSC", CombatMetersFrameSCParent)
sc:EnableMouse(true)
sc:EnableMouseWheel(true)

CombatMeters = { [1] = { } }

for k, v in pairs(Buttons) do
	--local b = CreateFrame("Button", "CombatMetersFrame"..v.."Button", CombatMetersFrame)
	local b = CreateFrame("Frame", "CombatMetersFrame"..v.."Button", CombatMetersFrame)
	b:ClearAllPoints()
	b:SetSize(40, 18)
--	b:RegisterForClicks("AnyUp")
	if k == 1 then
		--b:SetPoint("TOPLEFT", CombatMetersFrame, "TOPLEFT", 2, -2)
		b:SetPoint("TOPRIGHT", CombatMetersFrame, "TOPRIGHT", -2, -2)
	else
		--b:SetPoint("LEFT", _G["CombatMetersFrame"..Buttons[(k-1)].."Button"], "RIGHT", 2, 0)
		b:SetPoint("RIGHT", _G["CombatMetersFrame"..Buttons[(k-1)].."Button"], "LEFT", -2, 0)
	end

	local t = b:CreateFontString(b:GetName().."Text", "OVERLAY")
	t:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
	t:SetAllPoints(b)
	t:SetJustifyH("CENTER")
	t:SetText(v)
	b:SetWidth(t:GetStringWidth()+20)
	b:SetBackdrop( { bgFile = "Interface\\BUTTONS\\GRADBLUE", edgeFile = nil, tile = false, tileSize = b:GetWidth(), edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

	t:SetTextColor(1, 1, 1, 1)
	b:SetBackdropColor(1, 0.5, 0.5, 1)

	--[[
	if v == "Damage" then b:SetScript("OnMouseUp", function(self, button) CombatMeters_Refresh("dmg") end) end
	if v == "DPS" then b:SetScript("OnMouseUp", function(self, button) CombatMeters_Refresh("dps") end) end
	if v == "Heals" then b:SetScript("OnMouseUp", function(self, button) CombatMeters_Refresh("hps") end) end
	if v == "Interrupts" then b:SetScript("OnMouseUp", function(self, button) CombatMeters_Refresh("interrupts") end) end
	if v == "Dispells" then b:SetScript("OnMouseUp", function(self, button) CombatMeters_Refresh("dispells") end) end
	if v == "Miss" then b:SetScript("OnMouseUp", function(self, button) CombatMeters_Refresh("miss") end) end
	]]
	if v == "Report" then b:SetScript("OnMouseUp", function(self, button) if CombatMetersReportMenu:IsVisible() then CombatMetersReportMenu:Hide() else CombatMetersReportMenu:Show() end end) end
	if v == "Menu" then b:SetScript("OnMouseUp", function(self, button) if CombatMetersMenu:IsVisible() then CombatMetersMenu:Hide() else CombatMetersMenu:Show() end end) end
	if v == "Reset" then b:SetScript("OnMouseUp", function(self, button) CombatMeters_Reset() end) end
	if v == "Segment" then b:SetScript("OnMouseUp", function(self, button) if CombatMetersSegment:IsVisible() then CombatMetersSegment:Hide() else CombatMetersSegment:Show() end end) end

	--b:SetScript("OnMouseUp", b.OnMouseUp(self, button))

	t:Show()
    b:Show()
end

--[[
function CombatMetersFrameReportButton.OnMouseUp(self, button)
	if CombatMetersReportMenu:IsVisible() then
		CombatMetersReportMenu:Hide()
	else
		CombatMetersReportMenu:Show()
	end
end
CombatMetersFrameReportButton:SetScript("OnMouseUp", CombatMetersFrameReportButton.OnMouseUp(self, button))

function CombatMetersFrameMenuButton.OnMouseUp(self, button)
	if CombatMetersMenu:IsVisible() then
		CombatMetersMenu:Hide()
	else
		CombatMetersMenu:Show()
	end
end
CombatMetersFrameMenuButton:SetScript("OnMouseUp", CombatMetersFrameMenuButton.OnMouseUp(self, button))

function CombatMetersFrameResetButton.OnMouseUp(self, button)
	CombatMeters_Reset()
end
CombatMetersFrameResetButton:SetScript("OnMouseUp", CombatMetersFrameResetButton.OnMouseUp(self, button))

function CombatMetersFrameSegmentButton.OnMouseUp(self, button)
	if CombatMetersSegment:IsVisible() then
		CombatMetersSegment:Hide()
	else
		CombatMetersSegment:Show()
	end
end
CombatMetersFrameSegmentButton:SetScript("OnMouseUp", CombatMetersFrameSegementButton.OnMouseUp(self, button))
]]

local b = CreateFrame("Frame", "CombatMetersFrameTypeLabel", CombatMetersFrame)
b:ClearAllPoints()
b:SetPoint("TOPLEFT", CombatMetersFrame, "TOPLEFT", 2, -2)
b:SetPoint("BOTTOMRIGHT", _G["CombatMetersFrame"..Buttons[f.TableCount(Buttons)].."Button"], "BOTTOMLEFT", -2, 0)

local t = b:CreateFontString(b:GetName().."Text", "OVERLAY")
t:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
--t:SetAllPoints(b)
t:SetPoint("LEFT", b, "LEFT", 2, 0)
t:SetPoint("RIGHT", b, "RIGHT", -2, 0)
t:SetJustifyH("LEFT")
t:SetText(v)
--b:SetWidth(t:GetStringWidth()+20)
b:SetBackdrop( { bgFile = "Interface\\BUTTONS\\GRADBLUE", edgeFile = nil, tile = false, tileSize = b:GetWidth(), edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

t:SetTextColor(1, 1, 1, 1)
b:SetBackdropColor(1, 0.5, 0.5, 1)

t:Show()
b:Show()

b:SetScript("OnMouseWheel", function(self, delta)
	if delta < 0 then
		if CombatMetersDisplay == "dmg" then
			CombatMeters_Refresh("dps")
		elseif CombatMetersDisplay == "dps" then
			CombatMeters_Refresh("heal")
		elseif CombatMetersDisplay == "heal" then
			CombatMeters_Refresh("hps")
		elseif CombatMetersDisplay == "hps" then
			CombatMeters_Refresh("overheal")
		elseif CombatMetersDisplay == "overheal" then
			CombatMeters_Refresh("miss")
		elseif CombatMetersDisplay == "miss" then
			CombatMeters_Refresh("interrupts")
		elseif CombatMetersDisplay == "interrupts" then
			CombatMeters_Refresh("dispells")
		elseif CombatMetersDisplay == "dispells" then
			CombatMeters_Refresh("taunt")
		elseif CombatMetersDisplay == "taunt" then
			CombatMeters_Refresh("dmg")
		else
			CombatMeters_Refresh("dps")
		end
	else
		if CombatMetersDisplay == "dmg" then
			CombatMeters_Refresh("taunt")
		elseif CombatMetersDisplay == "dps" then
			CombatMeters_Refresh("dmg")
		elseif CombatMetersDisplay == "heal" then
			CombatMeters_Refresh("dps")
		elseif CombatMetersDisplay == "hps" then
			CombatMeters_Refresh("heal")
		elseif CombatMetersDisplay == "overheal" then
			CombatMeters_Refresh("hps")
		elseif CombatMetersDisplay == "miss" then
			CombatMeters_Refresh("overheal")
		elseif CombatMetersDisplay == "interrupts" then
			CombatMeters_Refresh("miss")
		elseif CombatMetersDisplay == "dispells" then
			CombatMeters_Refresh("interrupts")
		elseif CombatMetersDisplay == "taunt" then
			CombatMeters_Refresh("dispells")
		else
			CombatMeters_Refresh("dps")
		end	
	end
end)


local b = CreateFrame("Frame", "CombatMetersFrameButton", CombatMetersFrame)
b:ClearAllPoints()
b:SetPoint("BOTTOMLEFT", CombatMetersFrameResetButton, "BOTTOMRIGHT", 2, 0)
b:SetPoint("TOPRIGHT", CombatMetersFrame, "TOPRIGHT", -2, -2)
b:SetBackdrop( { bgFile = "Interface\\BUTTONS\\GRADBLUE", edgeFile = nil, tile = false, tileSize = b:GetWidth(), edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )
b:SetBackdropColor(1, 0.5, 0.5, 1)
b:Show()

local sb = CreateFrame("StatusBar", "CombatMetersFrameBar1", CombatMetersFrameSC)
sb:SetMinMaxValues(0, 100)
sb:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
sb:GetStatusBarTexture():SetHorizTile(false)
sb:SetStatusBarColor(0, 1, 0)
sb:SetValue(0)
sb:SetHeight(16)

sb:SetPoint("TOPLEFT", CombatMetersFrameSC, "TOPLEFT", 0, 0)
sb:SetPoint("TOPRIGHT", CombatMetersFrameSC, "TOPRIGHT", 0, 0)

local t = sb:CreateFontString("CombatMetersFrameName1", "OVERLAY", "NumberFont_Outline_Med")
t:SetJustifyH("LEFT")
t:SetPoint("LEFT", sb, "LEFT", 2, 0)

local t = sb:CreateFontString("CombatMetersFrameDPS1", "OVERLAY", "NumberFont_Outline_Med")
t:SetJustifyH("RIGHT")
t:SetPoint("RIGHT", sb, "RIGHT", -2, 0)

function CombatMeters_AddBar(i)
	if _G["CombatMetersFrameBar"..i] or i == 1 then return end

	local sb = CreateFrame("StatusBar", "CombatMetersFrameBar"..i, CombatMetersFrameSC)
	sb:SetMinMaxValues(0, 100)
	sb:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	sb:GetStatusBarTexture():SetHorizTile(false)
	sb:SetStatusBarColor(0, 1, 0)
	sb:SetValue(0)
	sb:SetHeight(16)

	sb:SetPoint("TOPLEFT", _G["CombatMetersFrameBar"..(i-1)], "BOTTOMLEFT", 0, -2)
	sb:SetPoint("TOPRIGHT", _G["CombatMetersFrameBar"..(i-1)], "BOTTOMRIGHt", 0, -2)

	local t = sb:CreateFontString("CombatMetersFrameName"..i, "OVERLAY", "NumberFont_Outline_Med")
	t:SetJustifyH("LEFT")
	t:SetPoint("LEFT", sb, "LEFT", 2, 0)

	local t = sb:CreateFontString("CombatMetersFrameDPS"..i, "OVERLAY", "NumberFont_Outline_Med")
	t:SetJustifyH("RIGHT")
	t:SetPoint("RIGHT", sb, "RIGHT", -2, 0)

	--_G["CombatMetersFrameBar"..i]:SetWidth(CombatMetersFrameSC:GetWidth())
	_G["CombatMetersFrameName"..i]:SetSize((_G["CombatMetersFrameBar"..i]:GetWidth()/2), 16)
	_G["CombatMetersFrameDPS"..i]:SetSize((_G["CombatMetersFrameBar"..i]:GetWidth()/2), 16)

	CombatMetersFrameSC:SetHeight(i*18)
	maxScroll = CombatMetersFrameSC:GetHeight()-128
	numBars = i
	return _G["CombatMetersFrameBar"..i]
end

CreateTab(CombatMetersFrame)

f:Hide()

local menu = CreateFrame("Frame", "CombatMetersSegment", CombatMetersFrame)
menu:SetBackdrop(GameTooltip:GetBackdrop())
menu:SetBackdropColor(0.1, 0.1, 0.1)
menu:SetSize(100, (f.TableCount(CombatMeters)*16)+16)
menu:SetPoint("BOTTOMRIGHT", CombatMetersFrameMenuButton, "TOPRIGHT", 0, 0)

menu:Hide()

for k,v in pairs(CombatMeters) do
	local btn = CreateFrame("Frame", "CMS"..k, CombatMetersSegment)
	btn:SetSize(menu:GetWidth()-20, 16)
	btn:CreateFontString("CMS"..k.."Text", "OVERLAY", "GameFontNormalSmall")
	_G["CMS"..k.."Text"]:SetAllPoints(btn)
	if k == #CombatMeters then
		_G["CMS"..k.."Text"]:SetText("|cffffffffCurrent Fight")
	else	
		_G["CMS"..k.."Text"]:SetText("|cffffffffFight "..k)
	end
	_G["CMS"..k.."Text"]:Show()
	btn:SetPoint("TOPLEFT", CombatMetersSegment, "TOPLEFT", 10, -((k*16)-6))
end

local menubtns = {
	["dmg"]="Damage",
	["dps"]="DPS",
	["heal"]="Heals",
	["hps"]="HPS",
	["overheal"]="Overhealing",
	["interrupts"]="Interrupts",
	["dispells"]="Dispells",
	["miss"]="Miss",
	["taunt"]="Taunts",
}

local menu = CreateFrame("Frame", "CombatMetersMenu", CombatMetersFrame)
menu:SetBackdrop(GameTooltip:GetBackdrop())
menu:SetBackdropColor(0.1, 0.1, 0.1)
menu:SetSize(100, (f.TableCount(menubtns)*16)+16)
menu:SetPoint("BOTTOMRIGHT", CombatMetersFrameMenuButton, "TOPRIGHT", 0, 0)
--menu:SetScript("OnLeave", function(self) self:Hide() end)

menu:Hide()

local i = 1
for k,v in pairs(menubtns) do
	local btn = CreateFrame("Frame", "CMM"..v, CombatMetersMenu)
	btn:SetSize(menu:GetWidth()-20, 16)
	btn:CreateFontString("CMM"..v.."Text", "OVERLAY", "GameFontNormalSmall")
	_G["CMM"..v.."Text"]:SetAllPoints(btn)
	_G["CMM"..v.."Text"]:SetText("|cffffffff"..v)
	_G["CMM"..v.."Text"]:Show()
	btn:SetPoint("TOPLEFT", CombatMetersMenu, "TOPLEFT", 10, -((i*16)-6))
	btn:SetScript("OnMouseUp", function(self, button) CombatMeters_Refresh(k) end)
	btn:SetScript("OnEnter", function(self)
		CombatMetersMenu:Show()
		self:SetBackdropColor(0.5, 0.5, 0)
	end)
	btn:SetScript("OnLeave", function(self) self:SetBackdropColor(0.1, 0.1, 0.1) end)
	btn:Show()
	i = i + 1
end

local reportmenu = CreateFrame("Frame", "CombatMetersReportMenu", CombatMetersFrame)
reportmenu:SetBackdrop(GameTooltip:GetBackdrop())
reportmenu:SetBackdropColor(0.1, 0.1, 0.1)
reportmenu:SetSize(80, 100)
reportmenu:SetPoint("BOTTOMRIGHT", CombatMetersFrameReportButton, "TOPRIGHT", 0, 0)
reportmenu:SetScript("OnLeave", function(self) self:Hide() end)

local btn = CreateFrame("Frame", "CMRMGuild", CombatMetersReportMenu)
btn:SetSize(60, 16)
btn:CreateFontString("CMRMGuildText", "OVERLAY", "GameFontNormalSmall")
CMRMGuildText:SetAllPoints(btn)
CMRMGuildText:SetText("|cff00ff00Guild")
CMRMGuildText:Show()
btn:SetPoint("TOPLEFT", CombatMetersReportMenu, "TOPLEFT", 10, -10)
btn:SetScript("OnMouseUp", function(self, button) CombatMeters_Report("GUILD") end)
btn:SetScript("OnEnter", function(self) CombatMetersReportMenu:Show() end)
btn:Show()

local btn = CreateFrame("Frame", "CMRMRaid", CombatMetersReportMenu)
btn:SetSize(60, 16)
btn:CreateFontString("CMRMRaidText", "OVERLAY", "GameFontNormalSmall")
CMRMRaidText:SetAllPoints(btn)
CMRMRaidText:SetText("|cffff8000Raid")
CMRMRaidText:Show()
btn:SetPoint("TOP", CMRMGuild, "BOTTOM", 0, 0)
btn:SetScript("OnMouseUp", function(self, button) CombatMeters_Report("RAID") end)
btn:SetScript("OnEnter", function(self) CombatMetersReportMenu:Show() end)
btn:Show()

local btn = CreateFrame("Frame", "CMRMParty", CombatMetersReportMenu)
btn:SetSize(60, 16)
btn:CreateFontString("CMRMPartyText", "OVERLAY", "GameFontNormalSmall")
CMRMPartyText:SetAllPoints(btn)
CMRMPartyText:SetText("|cff0080ffParty")
CMRMPartyText:Show()
btn:SetPoint("TOP", CMRMRaid, "BOTTOM", 0, 0)
btn:SetScript("OnMouseUp", function(self, button) CombatMeters_Report("PARTY") end)
btn:SetScript("OnEnter", function(self) CombatMetersReportMenu:Show() end)
btn:Show()

local btn = CreateFrame("Frame", "CMRMYell", CombatMetersReportMenu)
btn:SetSize(60, 16)
btn:CreateFontString("CMRMYellText", "OVERLAY", "GameFontNormalSmall")
CMRMYellText:SetAllPoints(btn)
CMRMYellText:SetText("|cffff0000Yell")
CMRMYellText:Show()
btn:SetPoint("TOP", CMRMParty, "BOTTOM", 0, 0)
btn:SetScript("OnMouseUp", function(self, button) CombatMeters_Report("YELL") end)
btn:SetScript("OnEnter", function(self) CombatMetersReportMenu:Show() end)
btn:Show()

local btn = CreateFrame("Frame", "CMRMSay", CombatMetersReportMenu)
btn:SetSize(60, 16)
btn:CreateFontString("CMRMSayText", "OVERLAY", "GameFontNormalSmall")
CMRMSayText:SetAllPoints(btn)
CMRMSayText:SetText("|cffffffffSay")
CMRMSayText:Show()
btn:SetPoint("TOP", CMRMYell, "BOTTOM", 0, 0)
btn:SetScript("OnMouseUp", function(self, button) CombatMeters_Report("SAY") end)
btn:SetScript("OnEnter", function(self) CombatMetersReportMenu:Show() end)
btn:Show()

reportmenu:Hide()

function CombatMeters_Reset(unitGUID)
	if unitGUID then
--		for k, v in pairs(CombatMeters) do
--			CombatMeters[k][unitGUID] = {}
--		end
		CombatMeters[1][unitGUID] = {}
	else
		CombatMetersSegment:SetHeight(36)
		for i=2, #CombatMeters, 1 do
			_G["CMS"..i]:Hide()
		end

		CombatMeters = nil
		CombatMeters = { [1] = {} }

		CombatMeters_Clear()
	end
end

function CombatMeters_NewSegment()
--	tinsert(CombatMeters, #CombatMeters+1, {})
	tinsert(CombatMeters, 1, {})
	CombatMeters_PruneData()

	if CombatMeters[#CombatMeters] == {} then CombatMeters[#CombatMeters] = nil end

	for k,v in pairs(CombatMeters) do
		if not _G["CMS"..k] then		
			local btn = CreateFrame("Frame", "CMS"..k, CombatMetersSegment)
			btn:SetSize(menu:GetWidth()-20, 16)
			btn:CreateFontString("CMS"..k.."Text", "OVERLAY", "GameFontNormalSmall")
			_G["CMS"..k.."Text"]:SetAllPoints(btn)

			btn.id = k
			btn:SetScript("OnMouseUp", function(self, button)
				CombatMetersFightIndex = self.id
				CombatMeters_Refresh(CombatMetersDisplay)
				
			end)
			btn:SetPoint("TOPLEFT", CombatMetersSegment, "TOPLEFT", 10, -((k*16)-6))
			CombatMetersSegment:SetSize(100, (f.TableCount(CombatMeters)*16)+16)
			_G["CMS"..k.."Text"]:Show()
		end
		if k == 1 then
			_G["CMS"..k.."Text"]:SetText("|cffffffffCurrent Fight")
		else
			_G["CMS"..k.."Text"]:SetText("|cffffffffFight "..k)
		end
		_G["CMS"..k]:Show()
	end

--	CombatMeters_Reset()
end

function CombatMeters_CurrentIndex()
	if CombatMetersFightIndex == "overall" then
		return 0
	elseif CombatMetersFightIndex == "current" then
		return 1
	else
		return CombatMetersFightIndex
	end
end

function CombatMeters_AddData(srcGUID, srcName, srcClass, type, amount)
	if srcGUID == nil or srcName == nil or srcClass == nil or type == nil then return end

	local db = CombatMeters[1][srcGUID] or { ["name"] = srcName, ["class"] = srcClass, ["startTime"] = GetTime(), ["endTime"] = GetTime(), ["dmg"] = 0, ["hit"] = 0, ["miss"] = 0, ["heal"] = 0, ["dispells"] = 0, ["interrupts"] = 0, ["taunts"] = 0 }
	--local db = CombatMeters[1][srcGUID] or { ["name"] = srcName, ["class"] = srcClass, ["startTime"] = GetTime(), ["endTime"] = GetTime(), ["dmg"] = 0, ["hit"] = 0, ["miss"] = 0, ["heal"] = 0, ["dispells"] = 0, ["interrupts"] = 0, ["taunts"] = 0 }

	--if (GetTime() - db.endTime) > 10 then CombatMeters_Reset(srcGUID) end

	if type and type ~= "heal" and type ~= "miss" and type ~= "dispells" and type ~= "interrupts" and type ~= taunts then db.hit = db.hit + 1 end
	if type then db[type] = (db[type] or 0) + amount end

	db.endTime = GetTime()
	--if db ~= nil then CombatMeters[1][srcGUID] = db	end
	if db ~= nil then CombatMeters[1][srcGUID] = db	end

--	local db = CombatMeters[1]["Total"] or { ["name"] = "Total", ["class"] = "total", ["startTime"] = GetTime(), ["endTime"] = GetTime(), ["dmg"] = 0, ["hit"] = 0, ["miss"] = 0, ["heal"] = 0, ["dispells"] = 0, ["interrupts"] = 0 }
--
--	if type and type ~= "heal" and type ~= "miss" and type ~= "dispells" and type ~= "interrupts" then db.hit = db.hit + 1 end
--	if type then db[type] = db[type] + amount end
--
--	db.endTime = GetTime()
--	CombatMeters[1]["Total"] = db				
end

function CombatMeters_PruneData()
	for k, v in pairs(CombatMeters) do
		if k >= 10 then
			CombatMeters[k] = nil
		end
	end
end

function CombatMeters_Clear(index)
	index = (index or 0) + 1

	if index <= numBars then
		for i = index, numBars, 1 do
			_G["CombatMetersFrameBar"..i]:Hide()
		end
	end

--	while _G["CombatMetersFrameBar"..index] do
--		_G["CombatMetersFrameBar"..index]:Hide()
--
--		index = index + 1
--	end
end

function CombatMeters_Refresh(index)
	if not CombatMetersFrame:IsVisible() then return end

	CombatMetersFrameSC:SetWidth(TabParent:GetWidth())

	if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena" then
		if index ~= "dmg" and index ~= "hps" then
			index = "dmg"
		end
	end

	if CombatMetersDisplay ~= index then
		CombatMetersDisplay = index
		CombatMeters_Clear()
	end

	CombatMetersFrameTypeLabelText:SetText(menubtns[index])

	local tempTbl = {}
	local sortTbl = {}
	local curData = {}
	local max = 0

	if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena" then
		for i=1, GetNumBattlefieldScores() do
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec = GetBattlefieldScore(i)

			tempTbl[i] = {
				["name"] = name,
				["dmg"] = damageDone,
				["hps"] = healingDone,
				["heals"] = healingDone,
				["class"] = classToken,
				["spec"] = talentSpec or "None",
				["faction"] = faction,
			}
			table.insert(sortTbl, i)
		end
	else
		for k,v in pairs(CombatMeters[CombatMeters_CurrentIndex()]) do
			CombatMeters[CombatMeters_CurrentIndex()][k].combatTime = CombatMeters[CombatMeters_CurrentIndex()][k].endTime - CombatMeters[CombatMeters_CurrentIndex()][k].startTime
			if CombatMeters[CombatMeters_CurrentIndex()][k].combatTime < 1 then CombatMeters[CombatMeters_CurrentIndex()][k].combatTime = 2 end
			CombatMeters[CombatMeters_CurrentIndex()][k].dps = ceil(CombatMeters[CombatMeters_CurrentIndex()][k].dmg / CombatMeters[CombatMeters_CurrentIndex()][k].combatTime)
			CombatMeters[CombatMeters_CurrentIndex()][k].hps = ceil(CombatMeters[CombatMeters_CurrentIndex()][k].heal / CombatMeters[CombatMeters_CurrentIndex()][k].combatTime)
			table.insert(sortTbl, k)
		end
	end

	if index == "dmg" then
		--[[
		CombatMetersFrameDamageButton:SetBackdropColor(1, 1, 1, 1)
		CombatMetersFrameHealsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		]]

		if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena" then
			--[[
			CombatMetersFrameDPSButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			CombatMetersFrameDispellsButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			CombatMetersFrameInterruptsButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			CombatMetersFrameMissButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			]]

			table.sort(sortTbl, function(a, b)
				return tempTbl[a].dmg > tempTbl[b].dmg
			end)

			for k, v in pairs(sortTbl) do
				curData[k] = tempTbl[v]
			end
		else
			--[[
			CombatMetersFrameDPSButton:SetBackdropColor(1, 0.5, 0.5, 1)
			CombatMetersFrameDispellsButton:SetBackdropColor(1, 0.5, 0.5, 1)
			CombatMetersFrameInterruptsButton:SetBackdropColor(1, 0.5, 0.5, 1)
			CombatMetersFrameMissButton:SetBackdropColor(1, 0.5, 0.5, 1)
			]]

			table.sort(sortTbl, function(a, b)
				return CombatMeters[CombatMeters_CurrentIndex()][a].dmg > CombatMeters[CombatMeters_CurrentIndex()][b].dmg
			end)

			for k, v in pairs(sortTbl) do
				curData[k] = CombatMeters[CombatMeters_CurrentIndex()][v]
				curData[k].unitGUID = v
			end
		end
	elseif index == "dps" then
		--[[
		CombatMetersFrameDamageButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameDPSButton:SetBackdropColor(1, 1, 1, 1)
		CombatMetersFrameHealsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameDispellsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameInterruptsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameMissButton:SetBackdropColor(1, 0.5, 0.5, 1)
		]]

		table.sort(sortTbl, function(a, b)
			local time1 = CombatMeters[CombatMeters_CurrentIndex()][a].endTime-CombatMeters[CombatMeters_CurrentIndex()][a].startTime
			if time1 < 1 then time1 = 2 end

			dps1 = (CombatMeters[CombatMeters_CurrentIndex()][a].dmg / time1)

			local time2 = CombatMeters[CombatMeters_CurrentIndex()][b].endTime-CombatMeters[CombatMeters_CurrentIndex()][b].startTime
			if time2 < 1 then time2 = 2 end

			dps2 = (CombatMeters[CombatMeters_CurrentIndex()][b].dmg / time2)

			return dps1 > dps2
		end)

		for k, v in pairs(sortTbl) do
			curData[k] = CombatMeters[CombatMeters_CurrentIndex()][v]
			curData[k].unitGUID = v
		end
	elseif index == "hps" then
		--[[
		CombatMetersFrameDamageButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameHealsButton:SetBackdropColor(1, 1, 1, 1)
		]]

		if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena" then
			--[[
			CombatMetersFrameDPSButton:SetBackdropColor(1, 0.5, 0.5, 1)
			CombatMetersFrameDispellsButton:SetBackdropColor(1, 0.5, 0.5, 1)
			CombatMetersFrameInterruptsButton:SetBackdropColor(1, 0.5, 0.5, 1)
			CombatMetersFrameMissButton:SetBackdropColor(1, 0.5, 0.5, 1)
			]]

			table.sort(sortTbl, function(a, b)
				return tempTbl[a].hps > tempTbl[b].hps
			end)

			for k, v in pairs(sortTbl) do
				curData[k] = tempTbl[v]
			end
		else
			--[[
			CombatMetersFrameDPSButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			CombatMetersFrameDispellsButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			CombatMetersFrameInterruptsButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			CombatMetersFrameMissButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			]]

			table.sort(sortTbl, function(a, b)
				local time1 = CombatMeters[CombatMeters_CurrentIndex()][a].endTime-CombatMeters[CombatMeters_CurrentIndex()][a].startTime
				if time1 < 1 then time1 = 2 end

				dps1 = (CombatMeters[CombatMeters_CurrentIndex()][a].heal / time1)

				local time2 = CombatMeters[1][b].endTime-CombatMeters[CombatMeters_CurrentIndex()][b].startTime
				if time2 < 1 then time2 = 2 end

				dps2 = (CombatMeters[CombatMeters_CurrentIndex()][b].heal / time2)

				return dps1 > dps2
			end)

			for k, v in pairs(sortTbl) do
				curData[k] = CombatMeters[CombatMeters_CurrentIndex()][v]
				curData[k].unitGUID = v
			end
		end
	elseif index == "heals" then
		--[[
		CombatMetersFrameDamageButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameHealsButton:SetBackdropColor(1, 1, 1, 1)
		]]

		if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena" then
			--[[
			CombatMetersFrameDPSButton:SetBackdropColor(1, 0.5, 0.5, 1)
			CombatMetersFrameDispellsButton:SetBackdropColor(1, 0.5, 0.5, 1)
			CombatMetersFrameInterruptsButton:SetBackdropColor(1, 0.5, 0.5, 1)
			CombatMetersFrameMissButton:SetBackdropColor(1, 0.5, 0.5, 1)
			]]

			table.sort(sortTbl, function(a, b)
				return tempTbl[a].heal > tempTbl[b].heal
			end)

			for k, v in pairs(sortTbl) do
				curData[k] = tempTbl[v]
			end
		else
			--[[
			CombatMetersFrameDPSButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			CombatMetersFrameDispellsButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			CombatMetersFrameInterruptsButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			CombatMetersFrameMissButton:SetBackdropColor(0.5, 0.5, 0.5, 1)
			]]

			table.sort(sortTbl, function(a, b)
				--local time1 = CombatMeters[CombatMeters_CurrentIndex()][a].endTime-CombatMeters[CombatMeters_CurrentIndex()][a].startTime
				--if time1 < 1 then time1 = 2 end

				--dps1 = (CombatMeters[CombatMeters_CurrentIndex()][a].heal / time1)
				dps1 = CombatMeters[CombatMeters_CurrentIndex()][a].heal

				--local time2 = CombatMeters[CombatMeters_CurrentIndex()][b].endTime-CombatMeters[CombatMeters_CurrentIndex()][b].startTime
				--if time2 < 1 then time2 = 2 end

				--dps2 = (CombatMeters[CombatMeters_CurrentIndex()][b].heal / time2)
				dps2 = CombatMeters[CombatMeters_CurrentIndex()][b].heal

				return dps1 > dps2
			end)

			for k, v in pairs(sortTbl) do
				curData[k] = CombatMeters[CombatMeters_CurrentIndex()][v]
				curData[k].unitGUID = v
			end
		end
	elseif index == "taunts" then
		table.sort(sortTbl, function(a, b) 
			return CombatMeters[CombatMeters_CurrentIndex()][a].taunts > CombatMeters[CombatMeters_CurrentIndex()][b].taunts 
		end)

		for k, v in pairs(sortTbl) do
			curData[k] = CombatMeters[CombatMeters_CurrentIndex()][v]
			curData[k].unitGUID = v
		end
	elseif index == "dispells" then
		--[[
		CombatMetersFrameDamageButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameDPSButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameHealsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameDispellsButton:SetBackdropColor(1, 1, 1, 1)
		CombatMetersFrameInterruptsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameMissButton:SetBackdropColor(1, 0.5, 0.5, 1)
		]]

		table.sort(sortTbl, function(a, b)
			return CombatMeters[1][a].dispells > CombatMeters[CombatMeters_CurrentIndex()][b].dispells
		end)

		for k, v in pairs(sortTbl) do
			curData[k] = CombatMeters[CombatMeters_CurrentIndex()][v]
			curData[k].unitGUID = v
		end
	elseif index == "interrupts" then
		--[[
		CombatMetersFrameDamageButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameDPSButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameHealsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameDispellsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameInterruptsButton:SetBackdropColor(1, 1, 1, 1)
		CombatMetersFrameMissButton:SetBackdropColor(1, 0.5, 0.5, 1)
		]]

		table.sort(sortTbl, function(a, b)
			return CombatMeters[CombatMeters_CurrentIndex()][a].interrupts > CombatMeters[CombatMeters_CurrentIndex()][b].interrupts
		end)

		for k, v in pairs(sortTbl) do
			curData[k] = CombatMeters[CombatMeters_CurrentIndex()][v]
			curData[k].unitGUID = v
		end
	elseif index == "miss" then
		--[[
		CombatMetersFrameDamageButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameDPSButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameHealsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameDispellsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameInterruptsButton:SetBackdropColor(1, 0.5, 0.5, 1)
		CombatMetersFrameMissButton:SetBackdropColor(1, 1, 1, 1)
		]]

		table.sort(sortTbl, function(a, b)
			return CombatMeters[CombatMeters_CurrentIndex()][a].miss > CombatMeters[CombatMeters_CurrentIndex()][b].miss
		end)

		for k, v in pairs(sortTbl) do
			curData[k] = CombatMeters[CombatMeters_CurrentIndex()][v]
			curData[k].unitGUID = v
		end
	end

	for k, v in ipairs(curData) do
		max = max + v[index]
	end

	for k, v in ipairs(curData) do
		if k <= 41 then
			local s = _G["CombatMetersFrameBar"..k] or CombatMeters_AddBar(k)
			local n = _G["CombatMetersFrameName"..k]
			local d = _G["CombatMetersFrameDPS"..k]

			if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena" then
				if select(2, IsInInstance()) == "pvp" then
					if v.faction == 0 then
						s:SetStatusBarColor(1, 0, 0, 0.5)
					else
						s:SetStatusBarColor(0, 0, 1, 0.5)
					end
				else
					if v.faction == 0 then
						s:SetStatusBarColor(0, 1, 0, 0.5)
					else
						s:SetStatusBarColor(1, 1, 0, 0.5)
					end
				end

				if v.class and RAID_CLASS_COLORS[v.class] then
					n:SetTextColor(RAID_CLASS_COLORS[v.class].r, RAID_CLASS_COLORS[v.class].g, RAID_CLASS_COLORS[v.class].b, RAID_CLASS_COLORS[v.class].a)
				else
					n:SetTextColor(1, 1, 1, 1)
				end

				if v.spec == "Restoration" or v.spec == "Discipline" or v.spec == "Holy" then
					n:SetText(k..". "..v.name.." |cff00ff00("..v.spec..")")
				else
					n:SetText(k..". "..v.name.." ("..v.spec..")")
				end

				if max == 0 then
					s:SetValue(100)
					d:SetText("0 (0%)")

					s:Show()
				else
					if k == 1 then missing = 100-floor((v[index]/max)*100) end

					s:SetValue(floor((v[index]/max)*100)+missing)
					d:SetText(ShortNumber(v[index]).." ("..floor((v[index]/max)*100).."%)")

					if v[index] > 0 then
						s:Show()
					else
						s:Hide()
					end
				end

				if ( v[index] > 0 and max > 0 ) or max == 0 then
					s:Show()
				else
					s:Hide()
				end
			else
				if v.class == "pet" then
					s:SetStatusBarColor(0, 1, 0, 1)
				elseif v.class == "total" then
					s:SetStatusBarColor(0.5, 0.5, 0.5, 1)
				else
					s:SetStatusBarColor(RAID_CLASS_COLORS[v.class].r, RAID_CLASS_COLORS[v.class].g, RAID_CLASS_COLORS[v.class].b, RAID_CLASS_COLORS[v.class].a)
				end

				n:SetTextColor(1, 1, 1, 1)

	--			n:SetText((k-1)..". "..v.name)
				n:SetText(k..". "..v.name)
	--				if k == 1 then max = v[index] end
				if k == 1 then missing = 100-floor((v[index]/max)*100) end
	
				if index == "miss" then
					s:SetValue(floor((v[index] / (v[index]+v.hit))*100))
					d:SetText(v[index].." / "..(v[index]+v.hit).." ("..(floor((v[index] / (v[index]+v.hit))*100)).."%)")
				else
					s:SetValue(floor((v[index] / max)*100)+missing)
					d:SetText(ShortNumber(v[index]).." ("..floor((v[index] / max)*100).."%)")
				end


				if v[index] >= 0 and max > 0 then
					s:Show()
				else
					s:Hide()
				end
			end
		end
	end

--	if #(sortTbl) < numBars then
--		local i = #(sortTbl)
--		i = i + 1
--		while i <= numBars do
--			_G["CombatMetersFrameBar"..i]:Hide()
--			i = i + 1
--		end
--	end

--	local i = #(curData) + 1
--	while _G["CombatMetersFrameBar"..i] do
--		_G["CombatMetersFrameBar"..i]:Hide()
--		i = i + 1
--	end
	CombatMeters_Clear(#(sortTbl))
end

function CombatMeters_Report(chan)
	local index = CombatMetersDisplay

	if #(CombatMeters) <= 0 then return end

	local sortTbl = {}

	for k,v in pairs(CombatMeters[1]) do
		table.insert(sortTbl, k)
	end

	if index == "dmg" then
		if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena" then
			table.sort(sortTbl, function(a, b)
				return tempTbl[a].dmg > tempTbl[b].dmg
			end)


			if #(sortTbl) > 0 then
				SendChatMessage("Damage for current BG:", chan)

				for k, v in pairs(sortTbl) do
					if tempTbl[v].dmg > 0 then SendChatMessage(k..". "..tempTbl[v].name.." ("..tempTbl[v].spec..") "..ShortNumber(tempTbl[v].dmg), chan) end
				end
			end
		else
			table.sort(sortTbl, function(a, b)
				return CombatMeters[1][a].dmg > CombatMeters[1][b].dmg
			end)

			if #(sortTbl) > 0 then
				SendChatMessage("Damage for last fight:", chan)

				for k,v in ipairs(sortTbl) do
					if CombatMeters[1][v].dmg > 0 then SendChatMessage(k..". "..CombatMeters[1][v].name.." "..ShortNumber(CombatMeters[1][v].dmg), chan) end
				end
			end
		end
	elseif index == "dps" then
		table.sort(sortTbl, function(a, b)
			local time1 = CombatMeters[1][a].endTime-CombatMeters[1][a].startTime
			if time1 < 1 then time1 = 2 end

			dps1 = (CombatMeters[1][a].dmg / time1)

			local time2 = CombatMeters[1][b].endTime-CombatMeters[1][b].startTime
			if time2 < 1 then time2 = 2 end

			dps2 = (CombatMeters[1][b].dmg / time2)

			return dps1 > dps2
		end)

		if #(sortTbl) > 0 then
			SendChatMessage("DPS for last fight:", chan)

			for k,v in ipairs(sortTbl) do
				local dpsTime = CombatMeters[1][v].endTime-CombatMeters[1][v].startTime
				if dpsTime < 1 then dpsTime = 2 end
				local dps = ceil(CombatMeters[1][v].dmg/dpsTime)

				if dps > 0 then SendChatMessage(k..". "..CombatMeters[1][v].name.." "..ShortNumber(dps), chan) end
			end
		end
	elseif index == "heal" then
		if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena" then
			table.sort(sortTbl, function(a, b)
				return tempTbl[a].dmg > tempTbl[b].dmg
			end)


			if #(sortTbl) > 0 then
				SendChatMessage("Heals for current BG:", chan)

				for k, v in pairs(sortTbl) do
					if tempTbl[v].hps > 0 then SendChatMessage(k..". "..tempTbl[v].name.." "..ShortNumber(tempTbl[v].hps), chan) end
				end
			end
		else
			table.sort(sortTbl, function(a, b)
				local time1 = CombatMeters[1][a].endTime-CombatMeters[1][a].startTime
				if time1 < 1 then time1 = 2 end

				dps1 = (CombatMeters[1][a].heal / time1)

				local time2 = CombatMeters[1][b].endTime-CombatMeters[1][b].startTime
				if time2 < 1 then time2 = 2 end

				dps2 = (CombatMeters[1][b].heal / time2)

				return dps1 > dps2
			end)


			if #(sortTbl) > 0 then
				SendChatMessage("HPS for last fight:", chan)

				for k,v in ipairs(sortTbl) do
					local dpsTime = CombatMeters[1][v].endTime-CombatMeters[1][v].startTime
					if dpsTime < 1 then dpsTime = 2 end
					local dps = ceil(CombatMeters[1][v].heal/dpsTime)

					if dps > 0 then SendChatMessage(k..". "..CombatMeters[1][v].name.." "..ShortNumber(dps), chan) end
				end
			end
		end
	elseif index == "dispell" then
		table.sort(sortTbl, function(a, b)
			return CombatMeters[1][a].dispells > CombatMeters[1][b].dispells
		end)

		if #(sortTbl) > 0 then
			SendChatMessage("Dispells for last fight:", chan)

			for k,v in ipairs(sortTbl) do
				if CombatMeters[1][v].dispells > 0 then SendChatMessage(k..". "..CombatMeters[1][v].name.." "..CombatMeters[1][v].dispells, chan) end
			end
		end
	elseif index == "interrupt" then
		table.sort(sortTbl, function(a, b)
			return CombatMeters[1][a].interrupts > CombatMeters[1][b].interrupts
		end)

		if #(sortTbl) > 0 then
			SendChatMessage("Interrupts for last fight:", chan)

			for k,v in ipairs(sortTbl) do
				if CombatMeters[1][v].interrupts > 0 then SendChatMessage(k..". "..CombatMeters[1][v].name.." "..CombatMeters[1][v].interrupts, chan) end
			end
		end
	elseif index == "miss" then
		table.sort(sortTbl, function(a, b)
			return CombatMeters[1][a].miss > CombatMeters[1][b].miss
		end)

		if #(sortTbl) > 0 then
			SendChatMessage("Miss for last fight:", chan)

			for k,v in ipairs(sortTbl) do
				if CombatMeters[1][v].miss > 0 then SendChatMessage(k..". "..CombatMeters[1][v].name.." "..CombatMeters[1][v].miss.." / "..(CombatMeters[1][v].miss+CombatMeters[1][v].hit), chan) end
			end
		end
	end
end

function AssociatePets()
	if IsInRaid() and GetNumGroupMembers() >= 1 then
		for i=1,GetNumGroupMembers(),1 do
			if UnitExists("raid"..i.."pet") then
				pets[UnitGUID("raid"..i.."pet")] = UnitGUID("raid"..i)
			end
		end
	elseif GetNumGroupMembers() >= 1 then
		for i=1,GetNumGroupMembers(),1 do
			if UnitExists("party"..i.."pet") then
				pets[UnitGUID("party"..i.."pet")] = UnitGUID("party"..i)
			end
		end
	end
end

function f.IsTauntSpell(spellID)
	local taunts = {
		--Warrior
		355, --Taunt
		1161, --Challenging Shout

		--Death Knight
		49576, --Death Grip
		56222, --Dark Command

		--Paladin
		62124, --Hand of Reckoning
		31789, --Righteous Defense

		--Druid
		6795, --Growl
		5209, --Challenging Roar

		--Hunter
		20736, --Distracting Shot

		--Hunter Pet
		2649, -- Growl

		--Shaman
		73684, --Unleash Earth
			
		--Monk
		115546, --Provoke

		--Warlock
		59671, --Challenging Howl
	};

	for k,v in ipairs(taunts) do
		if v == spellID then
			return true
		end
	end

	return false
end

function f.OnEvent(self, event, ...)
	if event == "VARIABLES_LOADED" then
		local sc = _G[self:GetName().."SC"]

		sc:SetWidth(CombatMetersFrameSCParent:GetWidth())
		sc:SetHeight((18*25)-2)

		CombatMetersFrameSCParent:SetScrollChild(sc)

		CombatMetersFrameBar1:SetWidth(sc:GetWidth())
		CombatMetersFrameName1:SetSize((CombatMetersFrameBar1:GetWidth()/2), 16)
		CombatMetersFrameDPS1:SetSize((CombatMetersFrameBar1:GetWidth()/2), 16)

		self.timer = 0
		self.inCombat = 0
		self:UnregisterEvent("VARIABLES_LOADED")
	elseif event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED" then
		AssociatePets()
	elseif event == "PLAYER_REGEN_ENABLED" then
		if CombatMeters_CheckCombat() == 0 then self.inCombat = 0 end
		CombatMetersFightIndex = 2
		CombatMeters_NewSegment()
	elseif event == "PLAYER_REGEN_DISABLED" then
		--CombatMeters = {}
		--if self.inCombat == 0 then CombatMeters_NewSegment() end
		CombatMetersFightIndex = 1
		self.inCombat = 1
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, event, hideCaster, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags = ...

--		if srcName == "" or hideCaster then srcName = "UNKNOWN" end
		if srcName == "" or hideCaster then return end

		if not ( bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 or bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) > 0 or bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 ) then return end

		if bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 and bit.band(srcFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0 and srcName ~= nil and srcGUID ~= nil then
			local srcClass

			if bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
				srcClass = select(2, GetPlayerInfoByGUID(srcGUID))
			else
				if bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
					srcGUID = UnitGUID("player")
					srcName = UnitName("player")
					srcClass = select(2, UnitClass("player"))
				else
					AssociatePets()

					if srcGUID ~= "" and srcGUID ~= nil then
						--if self.IsPet(srcGUID) then
						if pets[srcGUID] ~= nil then
							srcClass = "pet"
							srcGUID = pets[srcGUID] -- set the source GUID to that of the pet owner
						else
							_, srcClass, _, _, _, srcName = GetPlayerInfoByGUID(srcGUID)
						end
					end
				end
			end

			--if srcGUID == nil or srcGUID == "" then return end

			if spellID ~= nil and self.IsTauntSpell(spellID) then
				CombatMeters_AddData(srcGUID, srcName, srcClass, "taunts", 1)
			end

			if string.find(event, "_INTERRUPT") then
				CombatMeters_AddData(srcGUID, srcName, srcClass, "interrupts", 1)
			elseif string.find(event, "_DISPELL") then
				CombatMeters_AddData(srcGUID, srcName, srcClass, "dispells", 1)
			elseif string.find(event, "_HEAL") then
				local amount, _, absorbed = select(15, ...)

				CombatMeters_AddData(srcGUID, srcName, srcClass, "heal", ((amount or 0) + (absorbed or 0)) )
			elseif string.find(event, "_MISS") then
				CombatMeters_AddData(srcGUID, srcName, srcClass, "miss", 1)
			elseif string.find(event, "_DAMAGE") or string.find(event, "_EXTRA_ATTACKS") then
				local amount

				if strsub(event, 1, 5) == "SWING" then
					amount = select(12, ...)
				else
					amount = select(15, ...)
				end

				CombatMeters_AddData(srcGUID, srcName, srcClass, "dmg", amount)
			elseif string.find(event, "_DRAIN") or string.find(event, "_LEECH") then
				local spellID, spellName, spellSchool, amount, powerType = select(12, ...)

				if powerType == -2 then
					CombatMeters_AddData(srcGUID, srcName, srcClass, "dmg", amount)
				else
					CombatMeters_AddData(srcGUID, srcName, srcClass, nil, amount)
				end
			elseif string.find(event, "_SUMMON") then
				if dstGUID ~= nil and dstGUID ~= "" and srcGUID ~= nil and srcGUID ~= "" then
					pets[dstGUID] = srcGUID
				end
--				print(srcName.." summoned "..dstName)
			end
		end
	end
end

function CombatMeters_CheckCombat()
	local isInstance, instanceType = IsInInstance()
	local inCombat = 0

	if GetNumGroupMembers() > 0 then
		for i=1,GetNumGroupMembers() do
			if UnitExists("raid"..i) and UnitAffectingCombat("raid"..i) then
				inCombat = inCombat + 1
			elseif UnitExists("party"..i) and UnitAffectingCombat("party"..i) then
				inCombat = inCombat + 1
			end
		end
	end

	if UnitAffectingCombat("player") or InCombatLockdown() then
		inCombat = inCombat + 1
	end

	if CombatMetersFrame.inCombat == 0 and inCombat > 0 then
		CombatMetersFrame.inCombat = 1
		CombatMeters_NewSegment()
	elseif CombatMetersFrame.inCombat ==1 and inCombat == 0 then
		CombatMetersFrame.inCombat = 0
	end

	return inCombat
end

f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PARTY_MEMBERS_CHANGED")
f:RegisterEvent("RAID_ROSTER_UPDATE")
f:RegisterEvent("ADDON_LOADED")

f:SetScript("OnEvent", f.OnEvent)
f:SetScript("OnShow", function(self)
	self.timer = 2
	self:SetScript("OnUpdate", function(self, elapsed)
		self.timer = self.timer or 0
		self.timer = self.timer + elapsed

		if self.timer >= 0.2 then
			if CombatMeters_CheckCombat() == 0 then
				self.inCombat = 0
			else
				self.inCombat = 1
			end
			CombatMeters_Refresh(CombatMetersDisplay)

			self.timer = 0
		end
	end)
end)

f:SetScript("OnHide", function(self)
	self.timer = 0
	self:SetScript("OnUpdate", nil)
end)

f:SetScript("OnMouseWheel", function(self, delta)
	local scp = CombatMetersFrameSCParent

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

SwitchTab(CombatMetersFrame)
