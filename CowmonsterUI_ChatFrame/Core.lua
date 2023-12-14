--local f = CreateFrame("ScrollingMessageFrame", "ChatFrame", UIParent)

local ChatTabs = {
	[1] = {
		["title"] = "Chat",
		["frame"] = "ChatFrame",
		["events"] = {
			"PLAYER_ENTERING_WORLD",
			"UPDATE_CHAT_COLOR",
			"UPDATE_CHAT_WINDOWS",
			"UPDATE_INSTANCE_INFO",
			"UPDATE_CHAT_COLOR_NAME_BY_CLASS",
			"CHAT_SERVER_DISCONNECTED",
			"CHAT_SERVER_RECONNECTED",
			"VARIABLES_LOADED",
			--"CHAT_MSG_ADDON",
			"CHAT_MSG_CHANNEL",
			"CHAT_MSG_EMOTE",
			"CHAT_MSG_MONSTER_SAY",
			"CHAT_MSG_MONSTER_WHISPER",
			"CHAT_MSG_SAY",
			"CHAT_MSG_YELL",
		},
	},
	[2] = {
		["title"] = "Guild",
		["frame"] = "GuildChatFrame",
		["events"] = {
			"CHAT_MSG_GUILD",
		},
	},
	[3] = {
		["title"] = "Party",
		["frame"] = "PartyChatFrame",
		["events"] = {
			"CHAT_MSG_PARTY",
			"CHAT_MSG_SAY",
			"CHAT_MSG_YELL",
		},
	},
	[4] = {
		["title"] = "Raid",
		["frame"] = "RaidChatFrame",
		["events"] = {
			"CHAT_MSG_RAID",
			"CHAT_MSG_RAID_LEADER",
		},
	},
	[5] = {
		["title"] = "Whisper",
		["frame"] = "WhisperChatFrame",
		["events"] = {
			"CHAT_MSG_WHISPER",
		},
	},
}

local events = {
	--"CHAT_MSG_ADDON",
	--"CHAT_MSG_CHANNEL",
	--"CHAT_MSG_EMOTE",
	--"CHAT_MSG_GUILD",
	--"CHAT_MSG_MONSTER_SAY",
	--"CHAT_MSG_MONSTER_WHISPER",
	--"CHAT_MSG_PARTY",
	--"CHAT_MSG_RAID",
	--"CHAT_MSG_RAID_LEADER",
	--"CHAT_MSG_SAY",
	--"CHAT_MSG_WHISPER",
	--"CHAT_MSG_YELL",
	--"LFG_LIST_UPDATE",
	--"WHO_LIST_UPDATE",
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
		["r"] = 0,
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

--[[
for k,v in pairs(events) do
	ChatFrame:RegisterEvent(v)
	ChatFrame1:UnregisterEvent(v)
end
]]

local function ChatTabExists(name)
        for k, v in pairs(ChatTabs) do
                if v.frame == name then return k end
        end

        return false
end

local function SwitchChatTab(parent)
	if not ChatTabExists(parent:GetName()) then return end

	for k,v in pairs(ChatTabs) do
		if v.frame == parent:GetName() then
			_G[v.frame.."Tab"]:SetAlpha(1)
			_G[v.frame.."TabText"]:SetTextColor(1, 1, 1, 1)
			_G[v.frame.."Tab"].alerting = 0
			_G[v.frame]:Show()
		else
			_G[v.frame.."Tab"]:SetAlpha(0.5)
			_G[v.frame.."TabText"]:SetTextColor(0.5, 0.5, 0.5, 1)
			_G[v.frame]:Hide()
		end
	end
end

local function OnEvent(self, event, ...)
	--print(event)
	if event == "PLAYER_ENTERING_WORLD" then
		self.defaultLanguage = GetDefaultLanguage()
		SetCVar("colorChatNamesByClass", 1, true)
		ChatFrame1ButtonFrame:Hide()

		--GuildChatFrame:AddMessageEventFilter("CHAT_MSG_GUILD", AddPlayerLevel)
	end

	if event == "UPDATE_CHAT_WINDOWS" or event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
		for k,v in pairs(ChatTypeInfo) do
			v.colorNameByClass = true
		end

		ChatFrame1EditBox:ClearAllPoints()
		ChatFrame1EditBox:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -5, -5)
		ChatFrame1EditBox:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 5, -5)

		ChatFrame1EditBox:SetBackdrop(nil)
		ChatFrame1EditBoxLeft:Hide()
		ChatFrame1EditBoxRight:Hide()
		ChatFrame1EditBoxMid:Hide()
		ChatFrame1EditBox:Hide()

		for i=1, NUM_CHAT_WINDOWS, 1 do
			local n = _G["ChatFrame"..i]
			local t = _G["ChatFrame"..i.."Tab"]

			t:Hide()

			t:SetScript("OnShow", function(self) self:Hide() end)

			n:ClearAllPoints()
			n:SetClampedToScreen(false)
			n:SetPoint("RIGHT", UIParent, "LEFT", -500, 0)
		end
	elseif event == "UPDATE_CHAT_COLOR" then
		local arg1, arg2, arg3, arg4 = ...
		local info = ChatTypeInfo[strupper(arg1)]

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
	elseif event == "UPDATE_CHAT_COLOR_NAME_BY_CLASS" then
		local arg1 = ...
		local info = ChatTypeInfo[strupper(arg1)]

		if ( info ) then
			info.colorNameByClass = true;
			if ( strupper(arg1) == "WHISPER" ) then
				info = ChatTypeInfo["REPLY"];
				if ( info ) then
					info.colorNameByClass = true;
				end
			end
		end
	elseif event == "UPDATE_INSTANCE_INFO" then

	elseif event == "CHAT_SERVER_DISCONNECTED" then

	elseif event == "CHAT_SERVER_RECONNECTED" then

	else
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end		

		local text, playerName, languageName, channelName, _, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, suppressRaidIcons = ...
		local msg = "["..BetterDate("%H:%M:%S", time()).."] "

		if playerName ~= nil then
			local name, rank, _, level = GetGuildInfoByName(playerName)

			if guid ~= nil then
				local class = select(2, GetPlayerInfoByGUID(guid))
				playerName = ("|cff%02x%02x%02x%s|r"):format((RAID_CLASS_COLORS[class].r * 255), (RAID_CLASS_COLORS[class].g * 255), (RAID_CLASS_COLORS[class].b * 255), playerName)
			end
			msg = msg.."["..playerName.."]"
			if event == "CHAT_MSG_GUILD" then
				if name ~= false then
					msg = ("%s[%s:%s]"):format(msg, rank, level)
				end
			end
		elseif channelName ~= nil then
			msg = msg.."["..channelName.."]"
		end

		--[[
		if specialFlags ~= nil then
			msg = msg.."("..specialFlags..")"
		end
		]]

		msg = msg..": "..text

		self:AddMessage(msg, chatColors[event].r, chatColors[event].g, chatColors[event].b, 1)
	end
end

local function ChatTab_OnUpdate(self, elapsed)
        self.timer = (self.timer or 0) + elapsed

        if self.timer >= 0.1 then
                if self.alerting == 1 then
                        if self.colorIndex == 1 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 1, 0, 1)
                                self.colorIndex = 2
                        elseif self.colorIndex == 2 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.9, 0, 1)
                                self.colorIndex = 3
                        elseif self.colorIndex == 3 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.8, 0, 1)
                                self.colorIndex = 4
                        elseif self.colorIndex == 4 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.7, 0, 1)
                                self.colorIndex = 5
                        elseif self.colorIndex == 5 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.6, 0, 1)
                                self.colorIndex = 6
                        elseif self.colorIndex == 6 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.5, 0, 1)
                                self.colorIndex = 7
                        elseif self.colorIndex == 7 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.4, 0, 1)
                                self.colorIndex = 8
                        elseif self.colorIndex == 8 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.3, 0, 1)
                                self.colorIndex = 9
                        elseif self.colorIndex == 9 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.2, 0, 1)
                                self.colorIndex = 10
                        elseif self.colorIndex == 10 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.1, 0, 1)
                                self.colorIndex = 11
                        elseif self.colorIndex == 11 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.0, 0, 1)
                                self.colorIndex = 12
                        elseif self.colorIndex == 12 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.1, 0, 1)
                                self.colorIndex = 13
                        elseif self.colorIndex == 13 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.2, 0, 1)
                                self.colorIndex = 14
                        elseif self.colorIndex == 14 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.3, 0, 1)
                                self.colorIndex = 15
                        elseif self.colorIndex == 15 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.4, 0, 1)
                                self.colorIndex = 16
                        elseif self.colorIndex == 16 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.5, 0, 1)
                                self.colorIndex = 17
                        elseif self.colorIndex == 17 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.6, 0, 1)
                                self.colorIndex = 18
                        elseif self.colorIndex == 18 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.7, 0, 1)
                                self.colorIndex = 19
                        elseif self.colorIndex == 19 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.8, 0, 1)
                                self.colorIndex = 20
                        elseif self.colorIndex == 20 then
                                _G[self:GetName().."Text"]:SetTextColor(0, 0.9, 0, 1)
                                self.colorIndex = 1
                        else
                                _G[self:GetName().."Text"]:SetTextColor(0, 1, 0, 1)
                                self.colorIndex = 1
                        end
                end

                self.timer = 0
        end
end

for i=1,#(ChatTabs),1 do
	local cf = _G[ChatTabs[i].frame] or CreateFrame("ScrollingMessageFrame", ChatTabs[i].frame, UIParent)

	local ct = CreateFrame("Button", cf:GetName().."Tab", UIParent)

	if i == 1 then
		ct:SetPoint("BOTTOMLEFT", cf, "TOPLEFT", 2, 0)
	elseif i % 5 == 1 then
		ct:SetPoint("BOTTOMLEFT", _G[ChatTabs[(i-5)].frame.."Tab"], "TOPLEFT", 0, 0)
	else
		ct:SetPoint("LEFT", _G[ChatTabs[(i-1)].frame.."Tab"], "RIGHT", 2, 0)
	end
	ct:SetAlpha(0.5)
	ct:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

	local ctl = ct:CreateFontString(ct:GetName().."Text", "OVERLAY")
	ctl:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
	ctl:SetAllPoints(ct)
	ctl:SetJustifyH("CENTER")
	ctl:SetText(ChatTabs[i].title)
	ct:SetSize(ctl:GetStringWidth()+30, 18)
	ctl:SetTextColor(0.5, 0.5, 0.5, 1)
	ctl:Show()
	ct:Show()
	ct:SetScript("OnClick", function(self, button)
		SwitchChatTab(_G[(self:GetName()):sub(1, -4)])
	end)
	ct.timer = 0
	ct.colorIndex = 1
	ct.alerting = 0
	ct:SetScript("OnUpdate", ChatTab_OnUpdate)

	cf:EnableKeyboard(true)
	cf:EnableMouse(true)
	cf:EnableMouseWheel(true)
	cf:SetFading(false)

	cf:SetFont("Fonts\\ARIALN.TTF", 16, "OUTLINE")
	cf:SetTextColor(1, 1, 1, 1)
	cf:SetJustifyH("LEFT")
	cf:SetMaxLines(4096)
	cf:SetID(i)
	cf:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

	cf:SetHeight(150)

	if IsAddOnLoaded("CowmonsterUI_InfoBar") then
		cf:SetPoint("BOTTOMLEFT", InfoBarFrame, "TOPLEFT", 0, 0)
	else
		cf:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	end

	if IsAddOnLoaded("CowmonsterUI_ActionBars") then
		cf:SetPoint("BOTTOMRIGHT", ActionBar1, "BOTTOMLEFT", 0, 0)
	else
		cf:SetWidth(500)
	end

	for k,v in pairs(ChatTabs[i].events) do
		cf:RegisterEvent(v)
		ChatFrame1:UnregisterEvent(v)
		--print("Registered event: "..v)
	end

	cf.show = {
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

	cf.flashTimer = 0
	cf.tellTimer = GetTime()
	cf.channelList = {}
	cf.zoneCHannelList = {}
	cf.messageTypeList = {}
	cf.defaultLanguage = GetDefaultLanguage()

	cf:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
	cf:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)

	cf:SetScript("OnEvent", OnEvent)

	cf:SetScript("OnHyperlinkClick", OnHyperlinkShow)
	cf:SetScript("OnMouseWheel", function(self, delta)
		if delta > 0 then
			self:ScrollUp()
		else
			self:ScrollDown()
		end
	end)
end

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

--[[
function f.IsChatEvent(event)
	for k,v in pairs(events) do
		if v == event then return true end
	end
	return false
end
]]

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

function GetGuildInfoByName(memberName)
	for i=1,GetNumGuildMembers(),1 do
		local name, rank, rankIndex, level, class = GetGuildRosterInfo(i)

		if name == memberName or name:sub(1, name:find("-")-1) == memberName then
			return name, rank, rankIndex, level, class
		end
	end
	return false
end

local function AddPlayerLevel(self, event, msg, author, ...)
	local name, rank, rankIndex, level, class = GetGuildInfoByName(author)

	if name ~= false then
		return false, "["..level.."]"..msg, author, ...
	end
end

local function OnHyperlinkShow(self, link, text, button)
	--SetItemRef(link, text, button, ChatFrame1);
	SetItemRef(link, text, button, self)
end

ChatFrame1EditBox:HookScript("OnShow", function(self)
	ChatFrame1EditBox:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 10, right = 10, top = 10, bottom = 10 } } )
end)

ChatFrame1EditBox:HookScript("OnHide", function(self)
	ChatFrame1EditBox:SetBackdrop(nil)
	ChatFrame1EditBoxLeft:Hide()
	ChatFrame1EditBoxRight:Hide()
	ChatFrame1EditBoxMid:Hide()
	ChatFrame1EditBox:Hide()
end)

SwitchChatTab(_G[ChatTabs[1].frame])
