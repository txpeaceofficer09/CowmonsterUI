local f = CreateFrame("Frame", nil, UIParent)

local function OnEvent(self, event, ...)
	MainMenuBarBackpackButton:SetParent(UIParent)
	MainMenuBarBackpackButton:SetSize(30, 30)
	MainMenuBarBackpackButton:ClearAllPoints()
	MainMenuBarBackpackButton:SetPoint("BOTTOMLEFT", ChatFrame, "TOPLEFT", 0, (ChatFrame.topOffset or 19))

	for i=0,3,1 do
		local b = _G["CharacterBag"..i.."Slot"]

		b:SetParent(UIParent)
		b:ClearAllPoints()
		if i == 0 then
			b:SetPoint("BOTTOMLEFT", MainMenuBarBackpackButton, "BOTTOMRIGHT", 2, 0)
		else
			b:SetPoint("BOTTOMLEFT", _G["CharacterBag"..(i-1).."Slot"], "BOTTOMRIGHT", 2, 0)
		end
	end

	local MicroButtons = {"Character", "Spellbook", "Talent", "Achievement", "Guild", "QuestLog", "PVP", "LFD", "Companions", "EJ", "Store", "MainMenu", "Friends"}

	for i,v in ipairs(MicroButtons) do
		local b = _G[v.."MicroButton"]

		b:SetParent(UIParent)
		b:SetScale(0.8)
		b:ClearAllPoints()
		if i == 1 then
			b:SetPoint("BOTTOMLEFT", CharacterBag3Slot, "BOTTOMRIGHT", 2, 0)
		else
			b:SetPoint("BOTTOMLEFT", _G[MicroButtons[(i-1)].."MicroButton"], "BOTTOMRIGHT", 2, 0)
		end
		b:Show()
	end

	if event == "PLAYER_ENTERING_WORLD" then
		LOCK_ACTIONBAR = 1

		SHOW_MULTI_ACTIONBAR_1 = 0
		SHOW_MULTI_ACTIONBAR_2 = 0
		SHOW_MULTI_ACTIONBAR_3 = 0
		SHOW_MULTI_ACTIONBAR_4 = 0
		--MultiActionBar_Update()
		SetActionBarToggles(0, 0, 0, 0)
		--[[
		MainMenuBarArtFrame:ClearAllPoints()
		MainMenuBarArtFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -1000)
		MainMenuBarArtFrame:SetClampedToScreen(false)

		MainMenuBar:ClearAllPoints()
		MainMenuBar:SetPoint("CENTER", UIParent, "CENTER", 0, -1000)
		MainMenuBar:SetClampedToScreen(false)
		]]

		--MainMenuBarArtFrame:Hide()
		--MainMenuBar:Hide()

		--VehicleMenuBar:HookScript("OnShow", function(self) self:Hide() end)
		--MainMenuBar:HookScript("OnShow", function(self) self:Hide() end)
		--MainMenuBarArtFrame:HookScript("OnShow", function(self) self:Hide() end)

		MainMenuBar:SetClampedToScreen(false)
		MainMenuBar:ClearAllPoints()
		MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, -200)

		MainMenuBar:HookScript("OnShow", function(self)
			MainMenuBar:ClearAllPoints()
			MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, -200)
		end)

		MultiBarLeft:ClearAllPoints()
		MultiBarLeft:SetPoint("LEFT", UIParent, "RIGHT", 100, 0)
		MultiBarLeft:Hide()
		MultiBarRight:ClearAllPoints()
		MultiBarRight:SetPoint("LEFT", UIParent, "RIGHT", 100, 0)
		MultiBarRight:Hide()
		MultiBarRight:SetScale(0.0001)	
	end
end

f:SetScript("OnEvent", OnEvent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
f:RegisterEvent("PLAYER_GAINS_VEHICLE_DATA")
f:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
f:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
