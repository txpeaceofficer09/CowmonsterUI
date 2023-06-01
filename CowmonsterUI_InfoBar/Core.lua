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
			["OnEvent"] = "InfoBarMoney_OnEvent",
		},
		["Events"] = {
			"PLAYER_MONEY",
			"PLAYER_ENTERING_WORLD",
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
		["Events"] = {
			"UPDATE_FACTION",
			"CHAT_MSG_COMBAT_FACTION_CHANGE",
			"CHAT_MSG_COMBAT_XP_GAIN",
			"CHAT_MSG_COMBAT_GUILD_XP_GAIN",
			"GUILD_XP_UPDATE",
		},
	},
	[3] = {
		["Name"] = "InfoBarMem",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarMem_OnEnter",
			["OnLeave"] = "InfoBarMem_OnLeave",
			["OnUpdate"] = "InfoBarMem_OnUpdate",
		},
	},
	[4] = {
		["Name"] = "InfoBarLat",
		["JustifyH"] = "RIGHT",
	},
	[5] = {
		["Name"] = "InfoBarFPS",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnUpdate"] = "InfoBarFPS_OnUpdate",
		},
	},
	[6] = {
		["Name"] = "InfoBarClock",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnUpdate"] = "InfoBarClock_OnUpdate",
		},
	},
}

local f = CreateFrame("Frame", "InfoBarFrame", UIParent)
local t = CreateFrame("GameTooltip", "InfoBarTooltip", UIParent, "GameTooltipTemplate")

--f:SetHeight(20)
f:ClearAllPoints()
--f:SetPoint("TOPLEFT", ActionBar1, "BOTTOMLEFT", -2, -2)
--f:SetPoint("TOPRIGHT", ActionBar2, "BOTTOMRIGHT", 2, -2)
f:SetSize(36*24, 20)
f:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
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

	if v.Events then
		for i, a in pairs(v.Events) do
			b:RegisterEvent(a)
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

function f.OnEvent(self, event, ...)
	if event == "VARIABLES_LOADED" then
		CowmonsterUIDB[GetRealmName()] = CowmonsterUIDB[GetRealmName()] or {}
		CowmonsterUIDB[GetRealmName()][UnitName("player")] = CowmonsterUIDB[GetRealmName()][UnitName("player")] or {["Settings"]={}}

		--self:SetPoint("CENTER", UIParent, "CENTER", 0, 10-(GetScreenHeight()/2))
	end
end

f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", f.OnEvent)

local t = f:CreateTexture(nil, "ARTWORK")
t:SetAllPoints(f)
t:Show()
t:SetTexture("Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill")
t:SetVertexColor(0.2, 0.2, 0.2)