local f = CreateFrame("Frame", "StanceBar", UIParent, "SecureHandlerStateTemplate")

local LBF

if IsAddOnLoaded("ButtonFacade") then
	LBF = LibStub('LibButtonFacade', true) or nil
	LBF:Group('CowmonsterUI'):Skin('Blizzard')
end

f:SetSize(318, 30)
f:SetPoint("CENTER", ActionBar5, "CENTER", 0, 35)

for i=1,10 do
	local bf = CreateFrame("CheckButton", "StanceBtn"..i, StanceBar, "StanceButtonTemplate")

	bf:SetSize(30, 30)
	bf:SetID(i)

	if i == 1 then
		bf:SetPoint("LEFT", StanceBar, "LEFT", 0, 0)
	else
		bf:SetPoint("LEFT", _G["StanceBtn"..(i-1)], "RIGHT", 4, 0)
	end

	if LBF then
		LBF:Group('CowmonsterUI'):AddButton(bf)
	end

	bf:Hide()
end

function f.ShowShapeshiftBar()
	local numForms = GetNumShapeshiftForms()

	for i = 1, 10, 1 do
		if i <= numForms then
			_G["StanceBtn"..i]:Show();
		else
			_G["StanceBtn"..i]:Hide();
		end
	end
end

function f.UpdateState ()
	local numForms = GetNumShapeshiftForms();
	local texture, name, isActive, isCastable;
	local button, icon, cooldown;
	local start, duration, enable;

	for i=1, numForms do
		button = _G["StanceBtn"..i];
		icon = _G["StanceBtn"..i.."Icon"];
		if ( i <= numForms ) then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i);
			icon:SetTexture(texture);
			
			button:SetAttribute("type", "spell");
			button:SetAttribute("spell", name);

			--Cooldown stuffs
			cooldown = _G["StanceBtn"..i.."Cooldown"];
			if ( texture ) then
				cooldown:Show();
			else
				cooldown:Hide();
			end
			start, duration, enable = GetShapeshiftFormCooldown(i);
			CooldownFrame_SetTimer(cooldown, start, duration, enable);
			
			if ( isActive ) then
				-- ShapeshiftBarFrame.lastSelected = _G["ShapeshiftButton"..i]:GetID();
				-- ShapeshiftBarFrame.lastSelected = _G["StanceBtn"..i]:GetID();
				button:SetChecked(1);
			else
				button:SetChecked(0);
			end

			if ( isCastable ) then
				icon:SetVertexColor(1.0, 1.0, 1.0);
			else
				icon:SetVertexColor(0.4, 0.4, 0.4);
			end

			button:Show();
		else
			button:Hide();
		end
	end
end

function f.HideShapeshiftBar()
	for i = 1, 10, 1 do
		_G["StanceBtn"..i]:Hide()
	end
end

function f.OnEvent (self, event, ...)
	if event == "UPDATE_BINDINGS" then
		if UnitAffectingCombat("player") then return end

		ClearOverrideBindings(self)

		for i=1,10,1 do
			local button = _G["StanceBtn"..i]
			-- local id = button:GetID()
			-- local id = i

			local wow_button, button = ("SHAPESHIFTBUTTON%d"):format(i), ("SHAPESHIFTBAR_BUTTON_%d"):format(i)

			for k=1, select('#', GetBindingKey(wow_button)) do
				local key = select(k, GetBindingKey(wow_button))
				SetOverrideBindingClick(self, true, key, button, "LeftButton")
			end

			local hotkey = _G[("StanceBtn%dHotKey"):format(i)]
			local key = GetBindingKey(wow_button)
			local text = GetBindingText(key, "KEY_", 1)

			if text == "" then
				hotkey:SetText(RANGE_INDICATOR)
				hotkey:SetPoint("TOPLEFT", _G["StanceBtn"..i], "TOPLEFT", 1, -2)
				hotkey:Hide()
			else
				hotkey:SetText(text)
				hotkey:SetPoint("TOPLEFT", _G["StanceBtn"..i], "TOPLEFT", -2, -2)
				hotkey:Show()
			end
		end
	else
		if GetNumShapeshiftForms() == 0 then
			f.HideShapeshiftBar()
			return
		end

		local button, buttons

		if not UnitAffectingCombat("player") then
			self:Execute([[
				buttons = table.new()
				for i = 1, 10, 1 do
					table.insert(buttons, self:GetFrameRef("StanceBtn"..i))
				end
			]])

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
			f.ShowShapeshiftBar()
		end
	-- else
		f.UpdateState()
	end
end

function f.OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		if UnitAffectingCombat("player") == false then
			for i = 1, 10, 1 do
				local b = _G["StanceBtn"..i]

				if i <= GetNumShapeshiftForms() then
					b:Show()
				else
					b:Hide()
				end
			end
		end

		self.timer = 0
	end
end

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
f:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
f:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
f:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
f:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
f:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
f:RegisterEvent("UPDATE_POSSESS_BAR")
f:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("UPDATE_BINDINGS")

f:SetScript("OnEvent", f.OnEvent)