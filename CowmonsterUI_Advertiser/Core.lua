CowmonsterUI_AdvertiserDB = { ["msg"] = "<Prochoice> is a twink guild recruiting new members for the 20-24, 30-34, 40-44 and 50-54 brackets. We accept any levels, but the guild focus is twink PvP. Whisper for invite." }

local function IsInCity()
	if select(2, EnumerateServerChannels()) == "Trade" then
		return true
	else
		return false
	end
end

local f = CreateFrame("Frame", nil, UIParent)

local function OnUpdate(self, elapsed)
	self.timer = ( self.timer or 0) + elapsed

	if self.timer >= 300 then
		if not ( UnitIsAFK("player") or UnitIsDND("player") ) and IsInCity() and CowmonsterUI_AdvertiserDB.msg ~= "" and IsInGuild() and GetGuildInfo("player") == "Prochoice" then SendChatMessage(CowmonsterUI_AdvertiserDB.msg, "CHANNEL", nil, 2) end

		self.timer = 0
	end
end

local function OnEvent(self, event, ...)
	if not ( UnitIsAFK("player") or UnitIsDND("player") ) and IsInCity() and CowmonsterUI_AdvertiserDB.msg ~= "" and IsInGuild() and GetGuildInfo("player") == "Prochoice" then SendChatMessage(CowmonsterUI_AdvertiserDB.msg, "CHANNEL", nil, 2) end
end

f:SetScript("OnUpdate", OnUpdate)
f:SetScript("OnEvent", OnEvent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
--f:RegisterEvent("ZONE_CHANGED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
--f:RegisterEvent("ZONE_CHANGED_INDOORS")

local function SlashCmdHandler(...)
	local msg = ""

	if ... == "" then
		DEFAULT_CHAT_FRAME:AddMessage("|cffff8000CowmonsterUI_Advertiser:|r "..CowmonsterUI_AdvertiserDB.msg, 1, 1, 1, 1)
	else
		for _, v in pairs({...}) do
			msg = msg.." "..v
		end

		CowmonsterUI_AdvertiserDB.msg = msg
	end
end

SlashCmdList['CUIADVERT_SLASHCMD'] = SlashCmdHandler
SLASH_CUIADVERT_SLASHCMD1 = '/cuiad'
SLASH_CUIADVERT_SLASHCMD2 = '/cuiadvert'
SLASH_CUIADVERT_SLASHCMD3 = '/cuia'