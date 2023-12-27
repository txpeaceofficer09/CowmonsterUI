-- Still need to add a table and SavedVariable to only invite players to guild once.
-- Add a whisper feature to guild invite anyone who whispers the key words "guild" and "invite" or "ginv" or "ginvite".

local f = CreateFrame("Frame", nil, UIParent)

f.level = 1

local function OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 5 then
		SetWhoToUI(0)
		SendWho(self.level.."-"..self.level)
		if self.level < 90 then
			self.level = self.level + 1
		else
			self.level = 1
		end
		self.timer = 0
	end
end

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		--DEFAULT_CHAT_FRAME:AddMessage("GuildInvite player entering world.")
	elseif event == "VARIABLES_LOADED" then
		if GuildInvites == nil then GuildInvites = {} end
	elseif event == "WHO_LIST_UPDATE" then
		local total = GetNumWhoResults()

		if total > 0 then
			for i=1,total,1 do
				local name, guild, level, race, class, zone = GetWhoInfo(i)
				if guild == "" or guild == nil then
					GuildInvite(name)
					GuildInvites[#(GuildInvites)] = name
				end
			end
		end
	end
end

f:RegisterEvent("WHO_LIST_UPDATE")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)
