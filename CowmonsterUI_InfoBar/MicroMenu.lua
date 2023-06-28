local MicroButtons = {"Character", "Spellbook", "Talent", "Reputation", "Achievement", "Guild", "QuestLog", "PVP", "LFD", "Companions", "EJ", "Currency", "Store", "MainMenu"}

function InfoBarMicroMenu_OnEnter(self)

end

function InfoBarMicroMenu_OnLeave(self)

end

function InfoBarMicroMenu_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		local menu = CreateFrame("Frame", "InfoBarMicroMenu_MenuFrame", UIParent)

		menu:SetBackdrop(GameTooltip:GetBackdrop())
		menu:SetFrameStrata("HIGH")
		menu:SetBackdropColor(0.1, 0.1, 0.1)
		menu:SetSize(120, 100)
		menu:ClearAllPoints()
		menu:SetPoint("BOTTOM", InfoBarMicroMenu, "TOP", 0, 0)
		--menu:SetScript("OnLeave", function(self) self:Hide() end)
		menu:Hide()

		for k,v in ipairs(MicroButtons) do
			local btn = CreateFrame("Frame", ("%sButton"):format(v), menu)
			btn:CreateFontString(("%sButtonText"):format(v), "OVERLAY", "GameFontNormalSmall")
			_G[("%sButtonText"):format(v)]:SetAllPoints(btn)
			_G[("%sButtonText"):format(v)]:SetJustifyH("LEFT")
			if v == "MainMenu" then
				_G[("%sButtonText"):format(v)]:SetText("|cffffffffMain Menu")
			elseif v == "EJ" then
				_G[("%sButtonText"):format(v)]:SetText("|cffffffffDungeon Journal")
			elseif v == "QuestLog" then
				_G[("%sButtonText"):format(v)]:SetText("|cffffffffQuest Log")
			elseif v == "Companions" then
				_G[("%sButtonText"):format(v)]:SetText("|cffffffffPets & Mounts")
			elseif v == "LFD" then
				_G[("%sButtonText"):format(v)]:SetText("|cffffffffLooking For Group")
			elseif v == "PVP" then
				_G[("%sButtonText"):format(v)]:SetText("|cffffffffPlayer vs Player")
			else
				_G[("%sButtonText"):format(v)]:SetText(("|cffffffff%s"):format(v))
			end
			_G[("%sButtonText"):format(v)]:Show()

			menu:SetHeight(k*16+20)

			btn:SetPoint("TOPLEFT", menu, "TOPLEFT", 10, -(k*16)+6)
			btn:SetSize(menu:GetWidth() - 20, 16)
			btn:SetScript("OnMouseUp", function(self, button)
				InfoBarMicroMenu_ToggleFrame(("%sFrame"):format(v))
			end)
			btn:Show()
		end

		--InfoBarMicroMenu_MenuFrame:ClearAllPoints()
		--InfoBarMicroMenu_MenuFrame:SetPoint("BOTTOM", self, "TOP", 0, 0)
		InfoBarSetText("InfoBarMicroMenu", "Micro Menu")
	end
end

function InfoBarMicroMenu_ToggleFrame(name)
	local panel = _G[name]

	if name == "TalentFrame" then
		ToggleTalentFrame()
	elseif name == "MainMenuFrame" then
		if GameMenuFrame:IsShown() then
			GameMenuFrame:Hide()
		else
			GameMenuFrame:Show()
		end
	elseif name == "LFDFrame" then
		if PVEFrame:IsShown() then
			HideUIPanel(PVEFrame)
		else
			ShowUIPanel(PVEFrame)
		end
	elseif name == "GuildFrame" then
		LoadAddOn("Blizzard_GuildUI")
		if GuildFrame:IsShown() then
			HideUIPanel(GuildFrame)
		else
			ShowUIPanel(GuildFrame)
		end
	elseif name == "AchievementFrame" then
		LoadAddOn("Blizzard_AchievementUI")
		if AchievementFrame:IsShown() then
			HideUIPanel(AchievementFrame)
		else
			ShowUIPanel(AchievementFrame)
		end
	elseif name == "CompanionsFrame" then
		LoadAddOn("Blizzard_PetJournal")
		if PetJournalParent:IsShown() then
			HideUIPanel(PetJournalParent)
		else
			ShowUIPanel(PetJournalParent)
		end
	elseif name == "ReputationFrame" then
		ToggleCharacter("ReputationFrame")
	elseif name == "SpellbookFrame" then
		if SpellBookFrame:IsShown() then
			HideUIPanel(SpellBookFrame)
		else
			ShowUIPanel(SpellBookFrame)
		end
		--ToggleCharacter("SkillFrame")
	elseif name == "PVPFrame" then
		LoadAddOn("Blizzard_PVPUI")
		if PVPUIFrame:IsShown() then
			HideUIPanel(PVPUIFrame)
		else
			ShowUIPanel(PVPUIFrame)
		end
		--ToggleCharacter("PVPFrame")
	elseif name == "CurrencyFrame" then
		ToggleCharacter("TokenFrame")
	elseif name == "EJFrame" then
		if EncounterJournal:IsShown() then
			HideUIPanel(EncounterJournal)
			--EncounterJournal:Hide()
		else
			ShowUIPanel(EncounterJournal)
			--EncounterJournal:Show()
		end
	else
		ShowUIPanel(panel)
	end
	InfoBarMicroMenu_MenuFrame:Hide()
end

function InfoBarMicroMenu_OnClick(self, button)
	if InfoBarMicroMenu_MenuFrame:IsShown() then
		InfoBarMicroMenu_MenuFrame:Hide()
	else
		InfoBarMicroMenu_MenuFrame:Show()
	end
end