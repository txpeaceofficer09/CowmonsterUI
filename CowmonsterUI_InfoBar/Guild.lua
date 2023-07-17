function InfoBarGuild_OnClick(self, button)
	LoadAddOn("Blizzard_GuildUI")
	if GuildFrame:IsShown() then
		HideUIPanel(GuildFrame)
	else
		ShowUIPanel(GuildFrame)
	end
end

function InfoBarGuild_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if elapsed >= 1 then
		local numTotalGuildMembers, numOnlineGuildMembers, numOnlineAndMobileMembers = GetNumGuildMembers()

		InfoBarSetText("InfoBarGuild", "Guild: %s / %s", numOnlineGuildMembers, numTotalGuildMembers)
	end
end

function InfoBarGuild_OnEvent(self, event, ...)
	if event == "GUILD_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
		local numTotalGuildMembers, numOnlineGuildMembers, numOnlineAndMobileMembers = GetNumGuildMembers()

		InfoBarSetText("InfoBarGuild", "Guild: %s / %s", numOnlineGuildMembers, numTotalGuildMembers)		
	end
end