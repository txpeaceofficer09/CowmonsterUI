CreateFrame("Frame", "PetBarFrame", UIParent, "SecureHandlerStateTemplate")
PetBarFrame:SetSize(318, 30)
PetBarFrame:Show()
PetBarFrame:ClearAllPoints()
PetBarFrame:SetPoint("CENTER", ActionBar3, "CENTER", 0, 35)

local LBF

if IsAddOnLoaded("ButtonFacade") then
	LBF = LibStub('LibButtonFacade', true) or nil
	LBF:Group('CowmonsterUI'):Skin('Blizzard')
end

for i = 1, 10, 1 do
	local bf = CreateFrame("CheckButton", "PetBtn"..i, PetBarFrame, "PetActionButtonTemplate")
	bf:SetSize(30, 30)
	bf:SetID(i)
	if i == 1 then
		bf:SetPoint("LEFT", PetBarFrame, "LEFT", 0, 0)
	else
		bf:SetPoint("LEFT", _G["PetBtn"..(i-1)], "RIGHT", 2, 0)
	end
	bf:SetScript("OnEnter", PetActionButton_OnEnter)
	bf:RegisterForClicks("AnyUp")

	if LBF then
		LBF:Group('CowmonsterUI'):AddButton(bf)
	end

	bf:Show()
end

function PetActionBar_Hide()
	if InCombatLockdown() then
		PetBarFrame.CombatUpdate = "hide"
		return
	end

	for i=1,10,1 do
		local btn = _G["PetBtn"..i]

		btn:Hide()
	end
end

function PetActionBar_Show()
	if InCombatLockdown() then
		PetBarFrame.CombatUpdate = "show"
		return
	end

	for i=1,10,1 do
		local btn = _G["PetBtn"..i]

		btn:Show()
	end
end

function PetActionBar_UpdateBindings()
	if InCombatLockdown() then
		PetBarFrame.CombatUpdate = "bindings"
		return
	end

	ClearOverrideBindings(PetBarFrame)

	for i=1,10,1 do
		local button = _G["PetBtn"..i]
		local id = button:GetID()

		local hotkey = _G[button:GetName().."HotKey"]
		local key = GetBindingKey("PETBAR_BUTTON_"..i)
		local text = GetBindingText(key, "KEY_", 1)

		if text == "" then
			hotkey:SetText(RANGE_INDICATOR)
			hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
			hotkey:Hide()
		else
			hotkey:SetText(text)
			hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", -2, -2)
			hotkey:Show()
			SetOverrideBindingClick(PetBarFrame, true, key, button:GetName(), "LeftButton")
		end
	end
end

function PetActionBar_Update()
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine;
 	for i=1, 10, 1 do
 		local buttonName = "PetBtn" .. i;
 		petActionButton = _G[buttonName];
 		petActionIcon = _G[buttonName.."Icon"];
 		petAutoCastableTexture = _G[buttonName.."AutoCastable"];
 		petAutoCastShine = _G[buttonName.."Shine"];
 		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
 		if ( not isToken ) then
 			petActionIcon:SetTexture(texture);
 			petActionButton.tooltipName = name;
 		else
 			petActionIcon:SetTexture(_G[texture]);
 			petActionButton.tooltipName = _G[name];
 		end
 		petActionButton.isToken = isToken;
 		petActionButton.tooltipSubtext = subtext;
 		if ( isActive ) then
 			if ( IsPetAttackAction(i) ) then
 				PetActionButton_StartFlash(petActionButton);
 				-- the checked texture looks a little confusing at full alpha (looks like you have an extra ability selected)
 				petActionButton:GetCheckedTexture():SetAlpha(0.5);
 			else
 				petActionButton:GetCheckedTexture():SetAlpha(1.0);
 			end
 			petActionButton:SetChecked(1);
 		else
 			if ( IsPetAttackAction(i) ) then
 				PetActionButton_StopFlash(petActionButton);
 			end
 			petActionButton:SetChecked(0);
 		end
 		if ( autoCastAllowed ) then
 			petAutoCastableTexture:Show();
 		else
 			petAutoCastableTexture:Hide();
 		end
 		if ( autoCastEnabled ) then
 			AutoCastShine_AutoCastStart(petAutoCastShine);
 		else
 			AutoCastShine_AutoCastStop(petAutoCastShine);
 		end
 		if ( name ) then
 			petActionButton:Show();
 		else
 			if ( PetActionBarFrame.showgrid == 0 ) and not InCombatLockdown() then
 				petActionButton:Hide();
 			end
 		end
 		if ( texture ) then
 			if ( GetPetActionSlotUsable(i) ) then
 				SetDesaturation(petActionIcon, nil);
 			else
 				SetDesaturation(petActionIcon, 1);
 			end
 			petActionIcon:Show();
 			petActionButton:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
 		else
 			petActionIcon:Hide();
 			petActionButton:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
 		end
 	end
 	PetActionBar_UpdateCooldowns()
end

function PetActionBar_UpdateCooldowns()
 	for i=1, 10, 1 do
 		local cooldown = _G["PetBtn"..i.."Cooldown"]
 		local start, duration, enable = GetPetActionCooldown(i)
 		CooldownFrame_SetTimer(cooldown, start, duration, enable)
 		
 		-- Update tooltip
 		local actionButton = _G["PetBtn"..i]
 		if ( GameTooltip:GetOwner() == actionButton ) then
 			PetActionButton_OnEnter(actionButton)
 		end
 	end
end

local function PetBarFrame_OnEvent(self, event, ...)
	if event == "PLAYER_LOGIN" then
		if InCombatLockdown() then
			self.CombatUpdate = "states"
			return
		end

		local button, buttons

		for i = 1, 10, 1 do
			button = _G["PetBtn"..i]
			self:SetFrameRef("PetBtn"..i, button)
		end

		self:Execute([[
			buttons = table.new()
			for i = 1, 10, 1 do
				table.insert(buttons, self:GetFrameRef("PetBtn"..i))
			end
		]])

		self:SetAttribute("_onstate-petstate", [[
			for i, button in ipairs(buttons) do
				if newstate == "pet" then
					button:Show()
				else
					button:Hide()
				end
			end
		]])
		RegisterStateDriver(self, "petstate", "[bonusbar:5] vehicle; [@pet,help,nodead,exists,nobonusbar:5] pet; nopet")
	elseif event == "UPDATE_BINDINGS" then
		PetActionBar_UpdateBindings()
	elseif event == "PLAYER_REGEN_ENABLED" then
		if not InCombatLockdown() then
			if (self.CombatUpdate or false) == "bindings" then
				self.CombatUpdate = false
				PetActionBar_UpdateBindings()
			elseif (self.CombatUpdate or false) == "states" then
				self.CombatUpdate = false
				local button, buttons

				for i = 1, 10, 1 do
					button = _G["PetBtn"..i]
					self:SetFrameRef("PetBtn"..i, button)
				end

				self:Execute([[
					buttons = table.new()
					for i = 1, 10, 1 do
						table.insert(buttons, self:GetFrameRef("PetBtn"..i))
					end
				]])

				self:SetAttribute("_onstate-petstate", [[
					for i, button in ipairs(buttons) do
						if newstate == "pet" then
							button:Show()
						else
							button:Hide()
						end
					end
				]])
				RegisterStateDriver(self, "petstate", "[bonusbar:5] vehicle; [@pet,help,nodead,exists,nobonusbar:5] pet; nopet")
			end
		end
	end
end

PetBarFrame:RegisterEvent("PLAYER_LOGIN")
PetBarFrame:RegisterEvent("UPDATE_BINDINGS")
PetBarFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
PetBarFrame:SetScript("OnEvent", PetBarFrame_OnEvent)