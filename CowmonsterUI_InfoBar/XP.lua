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

function InfoBarXP_OnEvent(self, event, ...)
	if event == "UPDATE_FACTION" or event == "CHAT_MSG_COMBAT_XP_GAIN" or event == "GUILD_XP_UPDATE" or event == "CHAT_MSG_COMBAT_GUILD_XP_GAIN" then
		InfoBarXP_Update()
	elseif event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
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
end