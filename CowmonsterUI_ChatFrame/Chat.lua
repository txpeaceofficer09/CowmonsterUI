local f = CreateFrame("ScrollingMessageFrame", "ChatFrame", UIParent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UPDATE_CHAT_COLOR")
f:RegisterEvent("UPDATE_CHAT_WINDOWS")
f:RegisterEvent("UPDATE_INSTANCE_INFO")
f:RegisterEvent("UPDATE_CHAT_COLOR_NAME_BY_CLASS")
f:RegisterEvent("CHAT_SERVER_DISCONNECTED")
f:RegisterEvent("CHAT_SERVER_RECONNECTED")
f:RegisterEvent("VARIABLES_LOADED")

f:EnableKeyboard(true)
f:EnableMouse(true)
f:EnableMouseWheel(true)

f:SetHeight(150)

if IsAddOnLoaded("CowmonsterUI_InfoBar") then
	f:SetPoint("BOTTOMLEFT", InfoBarFrame, "TOPLEFT", 0, 0)
else
	f:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
end

if IsAddOnLoaded("CowmonsterUI_ActionBars") then
	f:SetPoint("BOTTOMRIGHT", ActionBar1, "BOTTOMLEFT", 0, 0)
else
	f:SetWidth(500)
end

f:SetFading(false)
--f:SetFontObject("ChatFontNormal")
f:SetFont("FOnts\\ARIALN.TTF", 16, "OUTLINE")
f:SetTextColor(1, 1, 1, 1)
f:SetJustifyH("LEFT")
f:SetMaxLines(4096)
f:SetID(1)
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

ChatFrame.flashTimer = 0
ChatFrame.tellTimer = GetTime()
ChatFrame.channelList = {}
ChatFrame.zoneChannelList = {}
ChatFrame.messageTypeList = {}
ChatFrame.defaultLanguage = GetDefaultLanguage()

ChatFrame.show = {
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
--		ChatFrame.who = linkData:match("player:(.-):")
--		SetWhoToUI(0)
--		SendWho(self.who)
	end
end

local function OnHyperlinkLeave(self, linkData, link)
	if self.show[linkData:match("^(.-):")] then
		HideUIPanel(GameTooltip)
--	elseif linkData:match("^(.-):") == "player" then
--		ChatFrame.who = ""
	end
end

f:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
f:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)

--function ChatFrame_BNOnlineAddNameFilter(self, event, presenceID)
--	local _, _, _, toonName, _, client = BNGetFriendInfoByID(presenceID)
--
--	if client == "WoW" then
--		DEFAULT_CHAT_FRAME:AddMessage("|Hplayer:"..toonName.."|h["..toonName.."]|h has come online.", 1, 1, 0, 1)
--		return true
--	else
--		return false
--	end
--end

--function ChatFrame_BNChatAddNameFilter(self, event, msg, author, ...)
--	local presenceID = select(11, ...)
--
--	local _, _, _, toonName, _, client = BNGetFriendInfoByID(presenceID)
--
--	if client == "WoW" then
--		return false, string.format("|Hplayer:%s|h(%s)|h %s", toonName, toonName, msg), author, ...
--	else
--		return false
--	end
--end

function ChatFrame1:AddMessage(...)
	local msg, r, g, b, a = ...

	msg = "["..BetterDate("%H:%M:%S", time()).."] "..msg
	ChatFrame:AddMessage(msg, r, g, b, a)
end

function IsInCity()
	if select(2, EnumerateServerChannels()) == "Trade" then
		return true
	else
		return false
	end
end

f:SetScript("OnEvent", function(self, event, ...)
	local arg1, arg2, arg3, arg4 = ...;

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		self.defaultLanguage = GetDefaultLanguage();

		SetCVar("colorChatNamesByClass", 1, true)

		ChatFrame1ButtonFrame:Hide()
	end

	if event == "VARIABLES_LOADED" then
--		ChatFrame_AddMessageEventFilter("BN_FRIEND_ACCOUNT_ONLINE", ChatFrame_BNOnlineAddNameFilter)
--		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", ChatFrame_BNChatAddNameFilter)
--		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", ChatFrame_BNChatAddNameFilter)
	end

	if event == "UPDATE_CHAT_WINDOWS" or event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
		for k,v in pairs(ChatTypeInfo) do
			v.colorNameByClass = true
		end

		ChatFrame1EditBox:ClearAllPoints()
		ChatFrame1EditBox:SetPoint("BOTTOMLEFT", ChatFrame, "TOPLEFT", -5, -5)
		ChatFrame1EditBox:SetPoint("BOTTOMRIGHT", ChatFrame, "TOPRIGHT", 5, -5)
		ChatFrame1EditBox:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 10, right = 10, top = 10, bottom = 10 } } )
		ChatFrame1EditBoxLeft:Hide()
		ChatFrame1EditBoxRight:Hide()
		ChatFrame1EditBoxMid:Hide()

		for i=1, NUM_CHAT_WINDOWS do
			local n = _G["ChatFrame"..i]
			local t = _G["ChatFrame"..i.."Tab"]

			t:Hide()

			t:SetScript("OnShow", function(self) self:Hide() end)

			n:ClearAllPoints()
			n:SetClampedToScreen(false)
			n:SetPoint("RIGHT", UIParent, "LEFT", -500, 0)
		end

--		FriendsMicroButton:Hide()
--		FriendsMicroButton:HookScript("OnShow", function(self) self:Hide() end)

--		ChatFrameMenuButton:Hide()
--		ChatFrameMenuButton:HookScript("OnShow", function(self) self:Hide() end)

		return true
	elseif ( event == "UPDATE_CHAT_COLOR" ) then
		local info = ChatTypeInfo[strupper(arg1)];
		if ( info ) then
			info.r = arg2;
			info.g = arg3;
			info.b = arg4;
			self:UpdateColorByID(info.id, info.r, info.g, info.b);

			if ( strupper(arg1) == "WHISPER" ) then
				info = ChatTypeInfo["REPLY"];
				if ( info ) then
					info.r = arg2;
					info.g = arg3;
					info.b = arg4;
					self:UpdateColorByID(info.id, info.r, info.g, info.b);
				end
			end
		end
		return true;
	elseif ( event == "UPDATE_CHAT_COLOR_NAME_BY_CLASS" ) then
		local info = ChatTypeInfo[strupper(arg1)];
		if ( info ) then
			info.colorNameByClass = true;
			if ( strupper(arg1) == "WHISPER" ) then
				info = ChatTypeInfo["REPLY"];
				if ( info ) then
					info.colorNameByClass = true;
				end
			end
		end
		return true;
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

--f:SetScript("OnUpdate", function(self, elapsed)
--	self.timer = (self.timer or 0) + elapsed
--
--	if self.timer >= 1 then
--		if BNGetMatureLanguageFilter() then BNSetMatureLanguageFilter(false) end
--	end
--end)
