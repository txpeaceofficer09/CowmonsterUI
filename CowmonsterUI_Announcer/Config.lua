local config = CreateFrame("Frame", "AnnouncerConfig", UIParent);

local taunts = {
	5209--[[Challenging Roar]],
	1161--[[Challenging Shout]],
	56222--[[Dark Command]],
	49576--[[Death Grip]],
	20736--[[Distracting Shot]],
	6795--[[Growl]],
	2649--[[Growl (Hunter Pet)]],
	62124--[[Hand of Reckoning]],
	31789--[[Righteous Defense]],
	355--[[Taunt]],
	3716--[[Torment (Warlock Pet)]],
}

function config:SetDefaultConfig()
	Announcer_Config = {}
	Announcer_Config.AnnounceMyAuras = 1
	Announcer_Config.AnnounceRaidAuras = 0
	Announcer_Config.PrintRaidAuras = 1

	Announcer_Config.AnnounceMySteals = 1
	Announcer_Config.AnnounceRaidSteals = 0
	Announcer_Config.PrintRaidSteals = 1

	Announcer_Config.AnnounceMyDispells = 1
	Announcer_Config.AnnounceRaidDispells = 0
	Announcer_Config.PrintRaidDispells = 1

	Announcer_Config.AnnounceMyInterrupts = 1
	Announcer_Config.AnnounceRaidInterrupts = 0
	Announcer_Config.PrintRaidInterrupts = 1

	Announcer_Config.AnnounceMyCreates = 1
	Announcer_Config.AnnounceRaidCreates = 0
	Announcer_Config.PrintRaidCreates = 1

	Announcer_Config.AnnounceMyResurrects = 1
	Announcer_Config.AnnounceRaidRessurects = 0
	Announcer_Config.PrintRaidRessurects = 1

	Announcer_Config.AnnounceMyTaunts = 1
	Announcer_Config.AnnounceRaidTaunts = 0
	Announcer_Config.PrintRaidTaunts = 1

	for k, v in pairs(taunts) do
		Announcer_Config["AnnounceTaunt"..v] = 1
		config["AnnounceTaunt"..v]:SetChecked(1)
	end

	Announcer_Config.AnnounceMyCCs = 1
	Announcer_Config.AnnounceRaidCCs = 0
	Announcer_Config.PrintRaidCCs = 1

	Announcer_Config.AnnounceRaidDeaths = 1
	Announcer_Config.PrintRaidDeaths = 0

	Announcer_Config.AnnounceGuildRaidLoots = 1
	Announcer_Config.AnnounceGuildPartyLoots = 0

	config.AnnounceMyAuras:SetChecked(1)
	config.AnnounceRaidAuras:SetChecked(0)
	config.PrintRaidAuras:SetChecked(0)

	config.AnnounceMySteals:SetChecked(1)
	config.AnnounceRaidSteals:SetChecked(0)
	config.PrintRaidSteals:SetChecked(0)

	config.AnnounceMyDispells:SetChecked(1)
	config.AnnounceRaidDispells:SetChecked(0)
	config.PrintRaidDispells:SetChecked(0)

	config.AnnounceMySteals:SetChecked(1)
	config.AnnounceRaidSteals:SetChecked(0)
	config.PrintRaidSteals:SetChecked(0)

	config.AnnounceMyCreates:SetChecked(1)
	config.AnnounceRaidCreates:SetChecked(0)
	config.PrintRaidCreates:SetChecked(0)

	config.AnnounceMyResurrects:SetChecked(1)
	config.AnnounceRaidResurrects:SetChecked(0)
	config.PrintRaidResurrects:SetChecked(0)

	config.AnnounceMyTaunts:SetChecked(1)
	config.AnnounceRaidTaunts:SetChecked(0)
	config.PrintRaidTaunts:SetChecked(1)

	config.AnnounceMyCCs:SetChecked(1)
	config.AnnounceRaidCCs:SetChecked(0)
	config.PrintRaidCCs:SetChecked(1)

	config.AnnounceRaidDeaths:SetChecked(1)
	config.PrintRaidDeaths:SetChecked(1)

	config.AnnounceGuildRaidLoots:SetChecked(1)
	config.AnnounceGuildPartyLoots:SetChecked(0)
end

function config:SetCurrentConfig()
	config.AnnounceMyAuras:SetChecked(Announcer_Config.AnnounceMyAuras)
	config.AnnounceRaidAuras:SetChecked(Announcer_Config.AnnounceRaidAuras)
	config.PrintRaidAuras:SetChecked(Announcer_Config.PrintRaidAuras)

	config.AnnounceMySteals:SetChecked(Announcer_Config.AnnounceMySteals)
	config.AnnounceRaidSteals:SetChecked(Announcer_Config.AnnounceRaidSteals)
	config.PrintRaidSteals:SetChecked(Announcer_Config.PrintRaidSteals)

	config.AnnounceMyDispells:SetChecked(Announcer_Config.AnnounceMyDispells)
	config.AnnounceRaidDispells:SetChecked(Announcer_Config.AnnounceRaidDispells)
	config.PrintRaidDispells:SetChecked(Announcer_Config.PrintRaidDispells)

	config.AnnounceMyInterrupts:SetChecked(Announcer_Config.AnnounceMyInterrupts)
	config.AnnounceRaidInterrupts:SetChecked(Announcer_Config.AnnounceRaidInterrupts)
	config.PrintRaidInterrupts:SetChecked(Announcer_Config.PrintRaidInterrupts)

	config.AnnounceMyCreates:SetChecked(Announcer_Config.AnnounceMyCreates)
	config.AnnounceRaidCreates:SetChecked(Announcer_Config.AnnounceRaidCreates)
	config.PrintRaidCreates:SetChecked(Announcer_Config.PrintRaidCreates)

	config.AnnounceMyResurrects:SetChecked(Announcer_Config.AnnounceMyResurrects)
	config.AnnounceRaidResurrects:SetChecked(Announcer_Config.AnnounceRaidResurrects)
	config.PrintRaidResurrects:SetChecked(Announcer_Config.PrintRaidResurrects)

	config.AnnounceMyTaunts:SetChecked(Announcer_Config.AnnounceMyTaunts)
	config.AnnounceRaidTaunts:SetChecked(Announcer_Config.AnnounceRaidTaunts)
	config.PrintRaidTaunts:SetChecked(Announcer_Config.PrintRaidTaunts)

	config.AnnounceMyCCs:SetChecked(Announcer_Config.AnnounceMyCCs)
	config.AnnounceRaidCCs:SetChecked(Announcer_Config.AnnounceRaidCCs)
	config.PrintRaidCCs:SetChecked(Announcer_Config.PrintRaidCCs)

	for k, v in pairs(taunts) do
		config["AnnounceTaunt"..v]:SetChecked(Announcer_Config["AnnounceTaunt"..v])
	end

	config.AnnounceRaidDeaths:SetChecked(Announcer_Config.AnnounceRaidDeaths)
	config.PrintRaidDeaths:SetChecked(Announcer_Config.PrintRaidDeaths)

	config.AnnounceGuildRaidLoots:SetChecked(Announcer_Config.AnnounceGuildRaidLoots)
	config.AnnounceGuildPartyLoots:SetChecked(Announcer_Config.AnnounceGuildPartyLoots)
end

function config:ChangeState()
	Announcer_Config[self.id] = self:GetChecked() or 0;
end

function config:OpenConfig()
	InterfaceOptionsFrame_OpenToCategory(AnnouncerAurasConfigPanel)
end

function config:Init()
	config.name = "Announcer"
	InterfaceOptions_AddCategory(config);

	local panel = CreateFrame("Frame", "AnnouncerAurasConfigPanel", config)
	panel.name = "Auras"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceMyAuras = CreateFrame("CheckButton", "AnnounceMyAurasCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceMyAuras = AnnounceMyAuras
	AnnounceMyAuras.id = "AnnounceMyAuras"
	AnnounceMyAuras:SetPoint("TOPLEFT", 16, -16)
	AnnounceMyAuras:SetScript("OnClick", config.ChangeState)
	_G[AnnounceMyAuras:GetName().."Text"]:SetText("Announce My Buffs")

	local AnnounceRaidAuras = CreateFrame("CheckButton", "AnnounceRaidAurasCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceRaidAuras = AnnounceRaidAuras
	AnnounceRaidAuras.id = "AnnounceRaidAuras"
	AnnounceRaidAuras:SetPoint("TOPLEFT", AnnounceMyAuras, "BOTTOMLEFT", 0, 0)
	AnnounceRaidAuras:SetScript("OnClick", config.ChangeState)
	_G[AnnounceRaidAuras:GetName().."Text"]:SetText("Announce Raid Buffs")

	local PrintRaidAuras = CreateFrame("CheckButton", "PrintRaidAurasCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.PrintRaidAuras = PrintRaidAuras
	PrintRaidAuras.id = "PrintRaidAuras"
	PrintRaidAuras:SetPoint("TOPLEFT", AnnounceRaidAuras, "BOTTOMLEFT", 0, 0)
	PrintRaidAuras:SetScript("OnClick", config.ChangeState)
	_G[PrintRaidAuras:GetName().."Text"]:SetText("Print Raid Buffs to Chat Frame")

	local panel = CreateFrame("Frame", nil, config)
	panel.name = "Steals"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceMySteals = CreateFrame("CheckButton", "AnnounceMyStealsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceMySteals = AnnounceMySteals
	AnnounceMySteals.id = "AnnounceMySteals"
	AnnounceMySteals:SetPoint("TOPLEFT", 16, -16)
	AnnounceMySteals:SetScript("OnClick", config.ChangeState)
	_G[AnnounceMySteals:GetName().."Text"]:SetText("Announce My Stolen Buffs")

	local AnnounceRaidSteals = CreateFrame("CheckButton", "AnnounceRaidStealsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceRaidSteals = AnnounceRaidSteals
	AnnounceRaidSteals.id = "AnnounceRaidSteals"
	AnnounceRaidSteals:SetPoint("TOPLEFT", AnnounceMySteals, "BOTTOMLEFT", 0, 0)
	AnnounceRaidSteals:SetScript("OnClick", config.ChangeState)
	_G[AnnounceRaidSteals:GetName().."Text"]:SetText("Announce Raid Stolen Buffs")

	local PrintRaidSteals = CreateFrame("CheckButton", "PrintRaidStealsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.PrintRaidSteals = PrintRaidSteals
	PrintRaidSteals.id = "PrintRaidSteals"
	PrintRaidSteals:SetPoint("TOPLEFT", AnnounceRaidSteals, "BOTTOMLEFT", 0, 0)
	PrintRaidSteals:SetScript("OnClick", config.ChangeState)
	_G[PrintRaidSteals:GetName().."Text"]:SetText("Print Raid Stolen Buffs to Chat Frame")

	local panel = CreateFrame("Frame", nil, config)
	panel.name = "Dispells"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceMyDispells = CreateFrame("CheckButton", "AnnounceMyDispellsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceMyDispells = AnnounceMyDispells
	AnnounceMyDispells.id = "AnnounceMyDispells"
	AnnounceMyDispells:SetPoint("TOPLEFT", 16, -16)
	AnnounceMyDispells:SetScript("OnClick", config.ChangeState)
	_G[AnnounceMyDispells:GetName().."Text"]:SetText("Announce My Dispells")

	local AnnounceRaidDispells = CreateFrame("CheckButton", "AnnounceRaidDispellsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceRaidDispells = AnnounceRaidDispells
	AnnounceRaidDispells.id = "AnnounceMyDispells"
	AnnounceRaidDispells:SetPoint("TOPLEFT", AnnounceMyDispells, "BOTTOMLEFT", 0, 0)
	AnnounceRaidDispells:SetScript("OnClick", config.ChangeState)
	_G[AnnounceRaidDispells:GetName().."Text"]:SetText("Announce Raid Dispells")

	local PrintRaidDispells = CreateFrame("CheckButton", "PrintRaidDispellsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.PrintRaidDispells = PrintRaidDispells
	PrintRaidDispells.id = "PrintMyDispells"
	PrintRaidDispells:SetPoint("TOPLEFT", AnnounceRaidDispells, "BOTTOMLEFT", 0, 0)
	PrintRaidDispells:SetScript("OnClick", config.ChangeState)
	_G[PrintRaidDispells:GetName().."Text"]:SetText("Print Raid Dispells to Chat Frame")

	local panel = CreateFrame("Frame", nil, config)
	panel.name = "Interrupts"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceMyInterrupts = CreateFrame("CheckButton", "AnnounceMyInterruptsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceMyInterrupts = AnnounceMyInterrupts
	AnnounceMyInterrupts.id = "AnnounceMyInterrupts"
	AnnounceMyInterrupts:SetPoint("TOPLEFT", 16, -16)
	AnnounceMyInterrupts:SetScript("OnClick", config.ChangeState)
	_G[AnnounceMyInterrupts:GetName().."Text"]:SetText("Announce My Interrupts")

	local AnnounceRaidInterrupts = CreateFrame("CheckButton", "AnnounceRaidInterruptsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceRaidInterrupts = AnnounceRaidInterrupts
	AnnounceRaidInterrupts.id = "AnnounceRaidInterrupts"
	AnnounceRaidInterrupts:SetPoint("TOPLEFT", AnnounceMyInterrupts, "BOTTOMLEFT", 0, 0)
	AnnounceRaidInterrupts:SetScript("OnClick", config.ChangeState)
	_G[AnnounceRaidInterrupts:GetName().."Text"]:SetText("Announce Raid Interrupts")

	local PrintRaidInterrupts = CreateFrame("CheckButton", "PrintRaidInterruptsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.PrintRaidInterrupts = PrintRaidInterrupts
	PrintRaidInterrupts.id = "PrintRaidInterrupts"
	PrintRaidInterrupts:SetPoint("TOPLEFT", AnnounceRaidInterrupts, "BOTTOMLEFT", 0, 0)
	PrintRaidInterrupts:SetScript("OnClick", config.ChangeState)
	_G[PrintRaidInterrupts:GetName().."Text"]:SetText("Print Raid Interrupts to Chat Frame")

	local panel = CreateFrame("Frame", nil, config)
	panel.name = "Conjured Items/Spells"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceMyCreates = CreateFrame("CheckButton", "AnnounceMyCreatesCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceMyCreates = AnnounceMyCreates
	AnnounceMyCreates.id = "AnnounceMyCreates"
	AnnounceMyCreates:SetPoint("TOPLEFT", 16, -16)
	AnnounceMyCreates:SetScript("OnClick", config.ChangeState)
	_G[AnnounceMyCreates:GetName().."Text"]:SetText("Announce My Conjured Stuff")

	local AnnounceRaidCreates = CreateFrame("CheckButton", "AnnounceRaidCreatesCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceRaidCreates = AnnounceRaidCreates
	AnnounceRaidCreates.id = "AnnounceRaidCreates"
	AnnounceRaidCreates:SetPoint("TOPLEFT", AnnounceMyCreates, "BOTTOMLEFT", 0, 0)
	AnnounceRaidCreates:SetScript("OnClick", config.ChangeState)
	_G[AnnounceRaidCreates:GetName().."Text"]:SetText("Announce Raid Conjured Stuff")

	local PrintRaidCreates = CreateFrame("CheckButton", "PrintRaidCreatesCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.PrintRaidCreates = PrintRaidCreates
	PrintRaidCreates.id = "PrintRaidCreates"
	PrintRaidCreates:SetPoint("TOPLEFT", AnnounceRaidCreates, "BOTTOMLEFT", 0, 0)
	PrintRaidCreates:SetScript("OnClick", config.ChangeState)
	_G[PrintRaidCreates:GetName().."Text"]:SetText("Print Raid Conjured Stuff to Chat Frame")

	local panel = CreateFrame("Frame", nil, config)
	panel.name = "Resurrects"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceMyResurrects = CreateFrame("CheckButton", "AnnounceMyResurrectsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceMyResurrects = AnnounceMyResurrects
	AnnounceMyResurrects.id = "AnnounceMyResurrects"
	AnnounceMyResurrects:SetPoint("TOPLEFT", 16, -16)
	AnnounceMyResurrects:SetScript("OnClick", config.ChangeState)
	_G[AnnounceMyResurrects:GetName().."Text"]:SetText("Announce My Resurrects")

	local AnnounceRaidResurrects = CreateFrame("CheckButton", "AnnounceRaidResurrectsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceRaidResurrects = AnnounceRaidResurrects
	AnnounceRaidResurrects.id = "AnnounceRaidResurrects"
	AnnounceRaidResurrects:SetPoint("TOPLEFT", AnnounceMyResurrects, "BOTTOMLEFT", 0, 0)
	AnnounceRaidResurrects:SetScript("OnClick", config.ChangeState)
	_G[AnnounceRaidResurrects:GetName().."Text"]:SetText("Announce Raid Resurrects")

	local PrintRaidResurrects = CreateFrame("CheckButton", "PrintRaidResurrectsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.PrintRaidResurrects = PrintRaidResurrects
	PrintRaidResurrects.id = "PrintRaidResurrects"
	PrintRaidResurrects:SetPoint("TOPLEFT", AnnounceRaidResurrects, "BOTTOMLEFT", 0, 0)
	PrintRaidResurrects:SetScript("OnClick", config.ChangeState)
	_G[PrintRaidResurrects:GetName().."Text"]:SetText("Print Raid Resurrects to Chat Frame")

	local panel = CreateFrame("Frame", nil, config)
	panel.name = "Taunts"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceMyTaunts = CreateFrame("CheckButton", "AnnounceMyTauntsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceMyTaunts = AnnounceMyTaunts
	AnnounceMyTaunts.id = "AnnounceMyTaunts"
	AnnounceMyTaunts:SetPoint("TOPLEFT", 16, -16)
	AnnounceMyTaunts:SetScript("OnClick", config.ChangeState)
	_G[AnnounceMyTaunts:GetName().."Text"]:SetText("Announce My Taunts")

	local AnnounceRaidTaunts = CreateFrame("CheckButton", "AnnounceRaidTauntsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceRaidTaunts = AnnounceRaidTaunts
	AnnounceRaidTaunts.id = "AnnounceMyTaunts"
	AnnounceRaidTaunts:SetPoint("TOPLEFT", AnnounceMyTaunts, "BOTTOMLEFT", 0, 0)
	AnnounceRaidTaunts:SetScript("OnClick", config.ChangeState)
	_G[AnnounceRaidTaunts:GetName().."Text"]:SetText("Announce Raid Taunts")

	local PrintRaidTaunts = CreateFrame("CheckButton", "PrintRaidTauntsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.PrintRaidTaunts = PrintRaidTaunts
	PrintRaidTaunts.id = "PrintMyTaunts"
	PrintRaidTaunts:SetPoint("TOPLEFT", AnnounceRaidTaunts, "BOTTOMLEFT", 0, 0)
	PrintRaidTaunts:SetScript("OnClick", config.ChangeState)
	_G[PrintRaidTaunts:GetName().."Text"]:SetText("Print Raid Taunts to Chat Frame")

	for k, v in ipairs(taunts) do
		local f = CreateFrame("CheckButton", "AnnounceTaunt"..v.."CheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
		config["AnnounceTaunt"..v] = f
		f.id = "AnnounceTaunt"..v
		f:SetPoint("TOPLEFT", PrintRaidTaunts, "BOTTOMLEFT", 0, -((f:GetHeight()*k)-f:GetHeight())-16)
		f:SetScript("OnClick", config.ChangeState)
		_G[f:GetName().."Text"]:SetText(GetSpellInfo(v))
	end

	local panel = CreateFrame("Frame", nil, config)
	panel.name = "Crowd Controls"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceMyCCs = CreateFrame("CheckButton", "AnnounceMyCCsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceMyCCs = AnnounceMyCCs
	AnnounceMyCCs.id = "AnnounceMyCCs"
	AnnounceMyCCs:SetPoint("TOPLEFT", 16, -16)
	AnnounceMyCCs:SetScript("OnClick", config.ChangeState)
	_G[AnnounceMyCCs:GetName().."Text"]:SetText("Announce My Crowd Controls")

	local AnnounceRaidCCs = CreateFrame("CheckButton", "AnnounceRaidCCsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceRaidCCs = AnnounceRaidCCs
	AnnounceRaidCCs.id = "AnnounceMyCCs"
	AnnounceRaidCCs:SetPoint("TOPLEFT", AnnounceMyCCs, "BOTTOMLEFT", 0, 0)
	AnnounceRaidCCs:SetScript("OnClick", config.ChangeState)
	_G[AnnounceRaidCCs:GetName().."Text"]:SetText("Announce Raid Crowd Controls")

	local PrintRaidCCs = CreateFrame("CheckButton", "PrintRaidCCsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.PrintRaidCCs = PrintRaidCCs
	PrintRaidCCs.id = "PrintMyCCs"
	PrintRaidCCs:SetPoint("TOPLEFT", AnnounceRaidCCs, "BOTTOMLEFT", 0, 0)
	PrintRaidCCs:SetScript("OnClick", config.ChangeState)
	_G[PrintRaidCCs:GetName().."Text"]:SetText("Print Raid Crowd Controls to Chat Frame")

	local panel = CreateFrame("Frame", nil, config)
	panel.name = "Deaths"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceRaidDeaths = CreateFrame("CheckButton", "AnnounceRaidDeathsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceRaidDeaths = AnnounceRaidDeaths
	AnnounceRaidDeaths.id = "AnnounceMyDeaths"
	AnnounceRaidDeaths:SetPoint("TOPLEFT", 16, -16)
	AnnounceRaidDeaths:SetScript("OnClick", config.ChangeState)
	_G[AnnounceRaidDeaths:GetName().."Text"]:SetText("Announce Raid Deaths")

	local PrintRaidDeaths = CreateFrame("CheckButton", "PrintRaidDeathsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.PrintRaidDeaths = PrintRaidDeaths
	PrintRaidDeaths.id = "PrintMyDeaths"
	PrintRaidDeaths:SetPoint("TOPLEFT", AnnounceRaidDeaths, "BOTTOMLEFT", 0, 0)
	PrintRaidDeaths:SetScript("OnClick", config.ChangeState)
	_G[PrintRaidDeaths:GetName().."Text"]:SetText("Print Raid Deaths to Chat Frame")

	local panel = CreateFrame("Frame", nil, config)
	panel.name = "Loots"
	panel.parent = config.name
	InterfaceOptions_AddCategory(panel)

	local AnnounceGuildRaidLoots = CreateFrame("CheckButton", "AnnounceGuildRaidLootsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceGuildRaidLoots = AnnounceGuildRaidLoots
	AnnounceGuildRaidLoots.id = "AnnounceGuildRaidLoots"
	AnnounceGuildRaidLoots:SetPoint("TOPLEFT", 16, -16)
	AnnounceGuildRaidLoots:SetScript("OnClick", config.ChangeState)
	_G[AnnounceGuildRaidLoots:GetName().."Text"]:SetText("Announce Guild Raid Loot")

	local AnnounceGuildPartyLoots = CreateFrame("CheckButton", "AnnounceGuildPartyLootsCheckBox", panel, "InterfaceOptionsCheckButtonTemplate")
	config.AnnounceGuildPartyLoots = AnnounceGuildPartyLoots
	AnnounceGuildPartyLoots.id = "AnnounceGuildPartyLoots"
	AnnounceGuildPartyLoots:SetPoint("TOPLEFT", AnnounceGuildRaidLoots, "BOTTOMLEFT", 0, 0)
	AnnounceGuildPartyLoots:SetScript("OnClick", config.ChangeState)
	_G[AnnounceGuildPartyLoots:GetName().."Text"]:SetText("Announce Guild Party Loot")
 
	if not (Announcer_Config) then
		config:SetDefaultConfig();
	else
		config:SetCurrentConfig();
	end
end
