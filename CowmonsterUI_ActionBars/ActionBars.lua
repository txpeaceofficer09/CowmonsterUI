LOCK_ACTIONBAR = 1

local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("RAID_ROSTER_UPDATE")
f:RegisterEvent("PARTY_MEMBERS_CHANGED")

--f:SetScript("OnUpdate", function(self, elapsed)
--	self.timer = (self.timer or 0) + elapsed
--
--	if self.timer >= 0.2 then
--		if GetNumGroupMembers() > 0 then
--			MoveRaidFrames()
--		end
--
--		self.timer = 0
--	end
--end)

f:SetScript("OnEvent", function(self, event, ...)
	if event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED" then
--		MoveRaidFrames()
	else
--		PlayerFrame:ClearAllPoints()
--		PlayerFrame:SetPoint("LEFT", UIParent, "LEFT", 500, 0)

--		TargetFrame:ClearAllPoints()
--		TargetFrame:SetPoint("RIGHT", UIParent, "RIGHT", -500, 0)

		LOCK_ACTIONBAR = 1

		SHOW_MULTI_ACTIONBAR_1 = 0
		SHOW_MULTI_ACTIONBAR_2 = 0
		SHOW_MULTI_ACTIONBAR_3 = 0
		SHOW_MULTI_ACTIONBAR_4 = 0
		MultiActionBar_Update()
		SetActionBarToggles(0, 0, 0, 0)

		MainMenuBarArtFrame:Hide()
		MainMenuBar:Hide()

		--VehicleMenuBar:HookScript("OnShow", function(self) self:Hide() end)
		MainMenuBar:HookScript("OnShow", function(self) self:Hide() end)
		MainMenuBarArtFrame:HookScript("OnShow", function(self) self:Hide() end)

		MultiBarLeft:ClearAllPoints()
		MultiBarLeft:SetPoint("LEFT", UIParent, "RIGHT", 100, 0)
		MultiBarLeft:Hide()
		MultiBarRight:ClearAllPoints()
		MultiBarRight:SetPoint("LEFT", UIParent, "RIGHT", 100, 0)
		MultiBarRight:Hide()
		MultiBarRight:SetScale(0.0001)

	--	CastingBarFrame:HookScript("OnShow", function(self)
	--		self:ClearAllPoints()
	--		self:SetPoint("BOTTOM", UIParent, "CENTER", 0, -((GetScreenHeight()/2)-40))
	--	end)

	end
end)

local LBF

if IsAddOnLoaded("ButtonFacade") then
	LBF = LibStub('LibButtonFacade', true) or nil
	LBF:Group('CowmonsterUI'):Skin('Blizzard')
end

function f.CreateButton(id, pid)
	local bf = CreateFrame("CheckButton", "ActionBar"..pid.."Button"..id, _G["ActionBar"..pid], "ActionBarButtonTemplate", i)

	bf:RegisterForClicks("AnyUp")
	bf:SetSize(36, 36)

	bf:SetAttribute("type", "action")
	bf:SetAttribute("action", ((pid*12)-12)+id)
	bf:SetID(((pid*12)-12)+id)
	bf:SetAttribute("checkselfcast", true)
	bf:SetAttribute("checkfocuscast", true)
	bf:SetAttribute("showgrid", 1)

--	SetOverrideBindingClick(ActionBar1, true, binds[1][i], "ActionBar1Button"..i, "LeftButton")

	if id == 1 then
		bf:SetPoint("LEFT", _G["ActionBar"..pid], "LEFT", 0, 0)
	else
		bf:SetPoint("LEFT", _G["ActionBar"..pid.."Button"..(id-1)], "RIGHT", 2, 0)
	end

	if LBF then
		LBF:Group('CowmonsterUI'):AddButton(bf)
	end

	_G[bf:GetName().."Name"]:Hide()

	bf:Show()

	local cdt = bf:CreateFontString(bf:GetName().."CDText", "OVERLAY")
	cdt:SetFont("Fonts\\ARIALN.ttf", 18, "OUTLINE")
	cdt:SetPoint("CENTER", bf, "CENTER", 0, 0)
	cdt:SetSize(36, 36)

	bf:HookScript("OnUpdate", function(self)
		local name = self:GetName()
		local start, duration, enable = GetActionCooldown(self.action)
		local cooldown = _G[name.."CDText"]
		local endTime = start+duration
		local remain

		if endTime > GetTime() and duration > 1.5 then
			remain = endTime-GetTime()

			if remain <= 1 then
				cooldown:SetTextColor(1, 0, 0, 1)
			elseif remain <= 2 then
				cooldown:SetTextColor(1, 0.5, 0, 1)
			elseif remain <= 3 then
				cooldown:SetTextColor(1, 1, 0, 1)
			else
				cooldown:SetTextColor(1, 1, 1, 1)
			end

			if (remain/3600) > 1 then
				remain = ceil(remain/3600).."h"
			elseif (remain/60) > 1 then
				remain = ceil(remain/60).."m"
			else
				remain = ("%.1f"):format(remain)
			end

			cooldown:SetText(remain)
			cooldown:Show()
		else
			cooldown:Hide()
		end
	end)

	bf:SetScript("OnDragStart", function(self, button)
		if IsModifiedClick("PICKUPACTION") then
			SpellFlyout:Hide();
			PickupAction(self.action);
			ActionButton_UpdateState(self);
			ActionButton_UpdateFlash(self);
		end
	end)
end

for i=1,6,1 do
	local bar = CreateFrame("Frame", "ActionBar"..i, UIParent, "SecureHandlerStateTemplate")
	bar:SetSize(454, 36)
	bar:Show()

	for id=1,12,1 do
		f.CreateButton(id, i)
	end
end

-- Position the action bars.  All bars positioned based on the first bar.  Position the first bar at the bottom or right above InfoBar if InfoBar addon loaded.
if IsAddOnLoaded("CowmonsterUI_InfoBar") then
	ActionBar1:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", 0, 22) -- Main Bar w/ InfoBar
else
	ActionBar1:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", 0, 0) -- Main Bar w/o InfoBar
end
ActionBar6:SetPoint("BOTTOMLEFT", ActionBar1, "TOPLEFT", 0, 2) -- Bottom Left Bar
ActionBar5:SetPoint("BOTTOMLEFT", ActionBar6, "TOPLEFT", 0, 2)
ActionBar2:SetPoint("LEFT", ActionBar1, "RIGHT", 2, 0)
ActionBar3:SetPoint("LEFT", ActionBar5, "RIGHT", 2, 0)
ActionBar4:SetPoint("LEFT", ActionBar6, "RIGHT", 2, 0)


CreateFrame("Button", "VehicleExitButton", UIParent, "SecureActionButtonTemplate")
VehicleExitButton:RegisterForClicks("AnyUp")
VehicleExitButton:SetScript("OnClick", function(self) VehicleExit() end)
VehicleExitButton:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
VehicleExitButton:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
VehicleExitButton:SetHighlightTexture("Interface\\Vehciles\\UI-Vehicles-Button-Exit-Down")
VehicleExitButton:SetSize(36, 36)
VehicleExitButton:SetPoint("BOTTOMRIGHT", ActionBar6, "TOPRIGHT", 0, 2)
VehicleExitButton:SetScript("OnEnter", function(self) GameTooltip_AddNewbieTip(self, LEAVE_VEHICLE, 1.0, 1.0, 1.0, nil) end)
VehicleExitButton:SetScript("OnLeave", function(self) GameTooltip_Hide() end)

VehicleExitButton:Hide()

local Page = {
    ["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] %s; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
    ["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
    ["PRIEST"] = "[bonusbar:1] 7;",
    ["ROGUE"] = "[bonusbar:1] 7; [form:3] 8;",
    ["WARLOCK"] = "[form:2] 7;",
    ["DEFAULT"] = "[bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6; [bonusbar:5] 11;",
}

local function GetBar()
	local myclass = select(2, UnitClass("player"))
	local condition = Page["DEFAULT"]
	local page = Page[myclass]
	if page then
		if myclass == "DRUID" then
			-- Handles prowling, prowling has no real stance, so this is a hack which utilizes the Tree of Life bar for non-resto druids.
			if IsSpellKnown(33891) then -- Tree of Life form
				page = page:format(7)
			else
				page = page:format(8)
			end
		end
		condition = condition.." "..page
	end
	condition = condition.." 1"

	return condition
end

function ActionBar_UpdateAllHotkeys()
	for i = 1, NUM_ACTIONBAR_BUTTONS, 1 do
		for k = 1, 6, 1 do
			local button = _G["ActionBar"..k.."Button"..i]
			local id = button:GetID()

			local hotkey = _G["ActionBar"..k.."Button"..i.."HotKey"]
			local key = GetBindingKey("CLICK "..button:GetName()..":LeftButton")
			local text = GetBindingText(key, "KEY_", 1)
			if text == "" then
				hotkey:SetText(RANGE_INDICATOR)
				hotkey:SetPoint("TOPLEFT", _G["ActionBar"..k.."Button"..i], "TOPLEFT", 1, -2)
				hotkey:Hide()
			else
				hotkey:SetText(text)
				hotkey:SetPoint("TOPLEFT", _G["ActionBar"..k.."Button"..i], "TOPLEFT", -2, -2)
				hotkey:Show()
			end
		end
	end
end

function f.UpdateBindings()
	if UnitAffectingCombat("player") then return end

	for pid=1,6,1 do
		local bar = _G[("ActionBar%d"):format(pid)]
		ClearOverrideBindings(bar)

		for id=1,12,1 do
			local button = "ACTIONBAR_"..pid.."_BUTTON_"..id
			local wow_button = button

			if pid == 1 then
				wow_button = ("ACTIONBUTTON%d"):format(id)
			elseif pid == 2 then
				wow_button = ("MULTIACTIONBAR4BUTTON%d"):format(id)
			elseif pid == 3 then
				wow_button = ("MULTIACTIONBAR3BUTTON%d"):format(id)
			elseif pid == 4 then
				
			elseif pid == 5 then
				wow_button = ("MULTIACTIONBAR2BUTTON%d"):format(id)
			elseif pid == 6 then
				wow_button = ("MULTIACTIONBAR1BUTTON%d"):format(id)
			end

			for k=1, select('#', GetBindingKey(wow_button)) do
				local key = select(k, GetBindingKey(wow_button))
				--SetOverrideBindingClick(bar, false, key, button, "LeftButton")
			end

			local hotkey = _G["ActionBar"..pid.."Button"..id.."HotKey"]
			key = GetBindingKey(wow_button)
			local text = GetBindingText(key, "KEY_", 1)

			if text == "" then
				hotkey:SetText(RANGE_INDICATOR)
				hotkey:SetPoint("TOPLEFT", _G["ActionBar"..pid.."Button"..id], "TOPLEFT", 1, -2)
				hotkey:Hide()
			else
				hotkey:SetText(text)
				hotkey:SetPoint("TOPLEFT", _G["ActionBar"..pid.."Button"..id], "TOPLEFT", -2, -2)
				hotkey:Show()
				--SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
			end
		end
	end
end

local function ActionBar_OnEvent(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button, buttons

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G[self:GetName().."Button"..i]
			self:SetFrameRef(self:GetName().."Button"..i, button)
		end

		self:Execute([[
			buttons = table.new()
			for i = 1, 12, 1 do
				table.insert(buttons, self:GetFrameRef(self:GetName().."Button"..i))
			end
		]])


		if self:GetName() == "ActionBar1" then
			self:SetAttribute("_onstate-page", [[
				for i, button in ipairs(buttons) do
					button:SetAttribute("actionpage", tonumber(newstate))
				end
			]])

			RegisterStateDriver(self, "page", GetBar())
		else
			self:SetAttribute("_onstate-vehicle", [[
				for i, button in ipairs(buttons) do
					if newstate == "vehicle" then
						button:Hide()
					else
						button:Show()
					end
				end
			]])

			RegisterStateDriver(self, "vehicle", "[bonusbar:5] vehicle; novehicle")
		end

		VehicleExitButton:Hide()
	elseif event == "UPDATE_BINDINGS" then
		f.UpdateBindings()
		--[[
		for i=1,GetNumBindings(),1 do
			local command, key1, key2 = GetBinding(i)

			ChatFrame1:AddMessage(command.." "..(key1 or "").." "..(key2 or ""))
		end
		]]
		--[[
		if UnitAffectingCombat("player") then return end

		for pid=1,6,1 do
			local bar = _G[("ActionBar%d"):format(pid)]
			ClearOverrideBindings(bar)

			for id=1,12,1 do
				local button = _G["ActionBar"..pid.."Button"..id]
				local wow_button = button:GetName()

				if pid == 1 then
					wow_button = ("ActionButton%d"):format(id)
				elseif pid == 2 then
					wow_button = ("MultiBarRightButton%d"):format(id)
				elseif pid == 3 then
					wow_button = ("MutliBarBottomRightButton%d"):format(id)
				elseif pid == 4 then
					wow_button = ("MultiBarLeftButton%d"):format(id)
				elseif pid == 5 then
					wow_button = ("MultiBarBottomLeftButton%d"):format(id)
				end

				wow_button = ("ActionButton%d"):format(((pid*12)-12)+id)

				for k=1, select('#', GetBindingKey(wow_button)) do
					local key = select(k, GetBindingKey(wow_button))
					SetOverrideBindingClick(self, false, key, button:GetName())
				end

				local hotkey = _G["ActionBar"..pid.."Button"..id.."HotKey"]
				key = GetBindingKey(wow_button)
				local text = GetBindingText(key, "KEY_", 1)

				if text == "" then
					hotkey:SetText(RANGE_INDICATOR)
					hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
					hotkey:Hide()
				else
					hotkey:SetText(text)
					hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", -2, -2)
					hotkey:Show()
					--SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
				end
			end
		end
		]]
	elseif event == "UNIT_ENTERED_VEHICLE" then
		if select(1, ...) == "player" then
			VehicleExitButton:Show()
		end
	elseif event == "UNIT_EXITED_VEHICLE" then
		if select(1, ...) == "player" then
			VehicleExitButton:Hide()
		end
	elseif event == "COMBAT_LOG_EVENT_PET_BATTLE_START" then
		for i=1,6,1 do
			_G["ActionBar"..i]:Hide();
		end
	elseif event == "COMBAT_LOG_EVENT_PET_BATTLE_BATTLE_END" then
		for i=1,6,1 do
			_G["ActionBar"..i]:Show();
		end
	else
--		print(event, ...)
	end
end

ActionBar1:RegisterEvent("UPDATE_BINDINGS")
ActionBar1:RegisterEvent("PLAYER_GAINS_VEHICLE_DATA")
ActionBar1:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
ActionBar1:RegisterEvent("UNIT_ENTERED_VEHICLE")
ActionBar1:RegisterEvent("UNIT_EXITED_VEHICLE")

ActionBar1:RegisterEvent("COMBAT_LOG_EVENT_PET_BATTLE_START")
ActionBar1:RegisterEvent("COMBAT_LOG_EVENT_PET_BATTLE_BATTLE_END")

for i = 1, 6, 1 do
	local bar = _G["ActionBar"..i]

	bar:RegisterEvent("PLAYER_LOGIN")
	bar:SetScript("OnEvent", ActionBar_OnEvent)
end

--f:SetScript("OnUpdate", function(self, elapsed)
--	for k,v in pairs(binds) do
--		for i,b in pairs(v) do
--			SetOverrideBindingClick(self, true, binds[k][i], "ActionBar"..k.."Button"..i, "LeftButton")
--
--			local bind
--
--			if strsub(binds[k][i], 1, 5) == "SHIFT" then
--				bind = "s"..strsub(binds[k][i], 6)
--			elseif strsub(binds[k][i], 1, 4) == "CTRL" then
--				bind = "c"..strsub(binds[k][i], 5)
--			elseif strsub(binds[k][i], 1, 3) == "ALT" then
--				bind = "a"..strsub(binds[k][i], 4)
--			else
--				bind = binds[k][i]
--			end
--
--			_G["ActionBar"..k.."Button"..i.."HotKey"]:SetText(bind)
--			_G["ActionBar"..k.."Button"..i.."HotKey"]:Show()
--		end
--	end
--end)
