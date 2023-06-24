local f = CreateFrame("ScrollingMessageFrame", "LootTabFrame", UIParent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UPDATE_CHAT_COLOR")
f:RegisterEvent("UPDATE_CHAT_WINDOWS")
f:RegisterEvent("UPDATE_INSTANCE_INFO")
f:RegisterEvent("UPDATE_CHAT_COLOR_NAME_BY_CLASS")
f:RegisterEvent("CHAT_SERVER_DISCONNECTED")
f:RegisterEvent("CHAT_SERVER_RECONNECTED")
--f:RegisterEvent("VARIABLES_LOADED")

f:Hide()

local events = {
--	"CHAT_MSG_ADDON",
--	"CHAT_MSG_CHANNEL",
--	"CHAT_MSG_EMOTE",
--	"CHAT_MSG_GUILD",
--	"CHAT_MSG_MONSTER_SAY",
--	"CHAT_MSG_MONSTER_WHISPER",
--	"CHAT_MSG_PARTY",
--	"CHAT_MSG_RAID",
--	"CHAT_MSG_RAID_LEADER",
--	"CHAT_MSG_SAY",
--	"CHAT_MSG_WHISPER",
--	"CHAT_MSG_YELL",
--	"LFG_LIST_UPDATE",
--	"WHO_LIST_UPDATE",
	"CHAT_MSG_LOOT",
	"CHAT_MSG_MONEY",
	"BONUS_ROLL_RESULT",
	"START_LOOT_ROLL",
}

local chatColors = {
	["CHAT_MSG_ADDON"] = {
		["r"] = 0.5,
		["g"] = 0,
		["b"] = 0.5,		
	},
	["CHAT_MSG_CHANNEL"] = {
		["r"] = 0.5,
		["g"] = 0.8,
		["b"] = 0.9,
	},
	["CHAT_MSG_EMOTE"] = {
		["r"] = 0,
		["g"] = 0.5,
		["b"] = 0,
	},
	["CHAT_MSG_GUILD"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
	},
	["CHAT_MSG_MONSTER_SAY"] = {
		["r"] = 1,
		["g"] = 0.6,
		["b"] = 0,
	},
	["CHAT_MSG_MONSTER_WHISPER"] = {
		["r"] = 1,
		["g"] = 0,
		["b"] = 0,
	},
	["CHAT_MSG_PARTY"] = {
		["r"] = 0,
		["g"] = 1,
		["b"] = 0,
	},
	["CHAT_MSG_RAID"] = {
		["r"] = 0.7,
		["g"] = 0.8,
		["b"] = 0.9,
	},
	["CHAT_MSG_RAID_LEADER"] = {
		["r"] = 0.4,
		["g"] = 0,
		["b"] = 0.4,
	},
	["CHAT_MSG_SAY"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 1,
	},
	["CHAT_MSG_WHISPER"] = {
		["r"] = 1,
		["g"] = 0.4,
		["b"] = 0.7,
	},
	["CHAT_MSG_YELL"] = {
		["r"] = 0.5,
		["g"] = 0.3,
		["b"] = 0.1,
	},
}

f:EnableKeyboard(true)
f:EnableMouse(true)
f:EnableMouseWheel(true)

f:SetHeight(150)

f:SetAllPoints(TabParent)
CreateTab(LootTabFrame)

f:SetFading(false)
--f:SetFontObject("ChatFontNormal")
f:SetFont("FOnts\\ARIALN.TTF", 16, "OUTLINE")
f:SetTextColor(1, 1, 1, 1)
f:SetJustifyH("LEFT")
f:SetMaxLines(4096)
f:SetID(1)
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

LootTabFrame.flashTimer = 0
LootTabFrame.tellTimer = GetTime()
LootTabFrame.channelList = {}
LootTabFrame.zoneChannelList = {}
LootTabFrame.messageTypeList = {}
LootTabFrame.defaultLanguage = GetDefaultLanguage()

LootTabFrame.show = {
	["achievement"] = true,
	["enchant"] = true,
	["glyph"] = true,
	["item"] = true,
	["instancelock"] = true,
	["quest"] = true,
	["spell"] = true,
	["talent"] = true,
	["unit"] = true,
}

local function OnHyperlinkEnter(self, linkData, link)
	if self.show[linkData:match("^(.-):")] then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
--	elseif linkData:match("^(.-):") == "player" then
--		--print(linkData:match("player:(.-):"))
--		LootTabFrame.who = linkData:match("player:(.-):")
--		SetWhoToUI(0)
--		SendWho(self.who)
	end
end

local function OnHyperlinkLeave(self, linkData, link)
	if self.show[linkData:match("^(.-):")] then
		HideUIPanel(GameTooltip)
	end
end

f:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
f:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)

f:SetScript("OnEvent", function(self, event, ...)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		self.defaultLanguage = GetDefaultLanguage();
	
		for k,v in pairs(events) do
			LootTabFrame:RegisterEvent(v)
			ChatFrame1:UnregisterEvent(v)
		end
	elseif event == "CHAT_MSG_MONEY" then
		local msg = ...
	
		self:AddMessage(msg, 1, 1, 0, 1)
	elseif event == "CHAT_MSG_LOOT" then
		local msg = ...
	
		self:AddMessage(msg, 0, 1, 0, 1)
	elseif event == "BONUS_ROLL_RESULT" then
		local typeIdentifier, itemLink, quantity, specID, sex, personalLootToast, currencyID, isSecondaryResult, corrupted = ...
	
		print(event, ...)
	elseif event == "START_LOOT_ROLL" then
		local rollID, rollTime, lootHandle = ...

		print(event, ...)
	elseif event == "LOOT_ROLLS_COMPLETE" then
		print(event, ...)
	end
end)

local function OnHyperlinkShow(self, link, text, button)
    SetItemRef(link, text, button, ChatFrame1);
end

f:SetScript("OnHyperlinkClick", OnHyperlinkShow)
f:SetScript("OnMouseWheel", function(self, delta)
	if delta > 0 then
		self:ScrollUp();
	else
		self:ScrollDown();
	end
end)
