local f = CreateFrame("Frame", "HealBuffFrame", UIParent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("GROUP_JOIN")
f:RegisterEvent("GROUP_LEAVE")
f:RegisterEvent("LEARNED_SPELL_IN_TAB")
f:RegisterEvent("SPELLS_CHANGED")

local buttonSize = 24

local function IsSpellKnown(spellID)
	local tabs = GetNumSpellTabs()

	for tab=1,tabs,1 do
		local _, _, offset, numSlots = GetSpellTabInfo(tab)
		--if offset == 0 then offset = 1 end
		for i=offset,(offset+numSlots),1 do
			_, id = GetSpellBookItemInfo(i, BOOKTYPE_SPELL)

			if id == spellID then return true end
		end
		
	end

	return false
end

local spells = {
	["Death Knight"] = {

	},
	["Druid"] = {
		1126, -- Mark of the Wild
	},
	["Hunter"] = {

	},
	["Mage"] = {
		130, -- Slow Fall
		475, -- Remove Curse
		1459, -- Arcane Brilliance
	},
	["Monk"] = {

	},
	["Paladin"] = {
		114163, -- Eternal Flame
		19750, -- Flash of Light
		633, -- Lay on Hands
		1022, -- Hand of Protectionw
		1044, -- Hand of Freedom
		4987, -- Clense
		20217, -- Blessing of Kings
		7328, -- Resurrection
	},
	["Priest"] = {
		17, -- Power Word: Shield
		139, -- Renew
		2061, -- Flash Heal
		2050, -- Heal
		2060, -- Greater Heal
		47540, -- Penance
		596, -- Prayer of Healing
		33206, -- Pain Suppression
		21562, -- Power Word: Fortitude
		1706, -- Levitate
		528, -- Dispel Magic
		527, -- Purify
		2096, -- Mind Vision
		2006, -- Resurrection
	},
	["Rogue"] = {

	},
	["Warlock"] = {

	},
	["Warrior"] = {

	},
}

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "LEARNED_SPELL_IN_TAB" or event == "SPELLS_CHANGED" then
		if InCombatLockdown() or UnitAffectingCombat("player") then
			f.CombatUpdate = 1
			return false
		end

		for i=1,4,1 do
			local parent = _G[("PartyMemberFrame%s"):format(i)]
			local index = 1
			for k,spellID in pairs(spells[UnitClass("player")]) do
				if IsSpellKnown(spellID) then
					local spellName, _, texture = GetSpellInfo(spellID)
					local button

					if not _G[("%sSpellButton%s"):format(parent:GetName(), index)] then
						button = CreateFrame("Button", ("%sSpellButton%s"):format(parent:GetName(), index), parent, "SecureActionButtonTemplate")
					else
						button = _G[("%sSpellButton%s"):format(parent:GetName(), index)]
					end

					--print(button:GetName())

					button:SetSize(buttonSize, buttonSize)
					button:SetNormalTexture(texture)
					button:SetAttribute("type1", "macro")
					button:SetAttribute("macrotext1", ("#showtooltip\n/cast [@party%s] %s"):format(i, spellName))
					if index <= 8 then
						button:SetPoint("TOPLEFT", parent, "TOPRIGHT", (index*buttonSize)-(buttonSize / 2), 0)
					elseif index <= 16 then
						button:SetPoint("TOPLEFT", parent, "TOPRIGHT", ((index-8)*buttonSize)-(buttonSize / 2), -(buttonSize + 4))
					else
						button:SetPoint("TOPLEFT", parent, "TOPRIGHT", ((index-16)*buttonSize)-(buttonSize / 2), -((buttonSize*2)+8))
					end
					button:Show()

					index = index + 1				
				end
			end
		end

		local parent = PlayerFrame
		index = 1
		for k,spellID in pairs(spells[UnitClass("player")]) do
			if IsSpellKnown(spellID) then
				local spellName, _, texture = GetSpellInfo(spellID)

				if not _G[("%sSpellButton%s"):format(parent:GetName(), index)] then
				local button = CreateFrame("Button", ("%sSpellButton%s"):format(parent:GetName(), index), parent, "SecureActionButtonTemplate")
				else
					local button = _G[("%sSpellButton%s"):format(parent:GetName(), index)]
				end
				local button = CreateFrame("Button", ("%sSpellButton%s"):format(parent:GetName(), k), parent, "SecureActionButtonTemplate")

				button:SetSize(buttonSize, buttonSize)
				button:SetNormalTexture(texture)
				button:SetAttribute("type1", "macro")
				button:SetAttribute("macrotext1", ("#showtooltip\n/cast [@player] %s"):format(spellName))
				if index <= 8 then
					button:SetPoint("TOPLEFT", parent, "TOPRIGHT", (index*buttonSize)-(buttonSize / 2), 0)
				elseif index <= 16 then
					button:SetPoint("TOPLEFT", parent, "TOPRIGHT", ((index-8)*buttonSize)-(buttonSize / 2), -(buttonSize + 4))
				else
					button:SetPoint("TOPLEFT", parent, "TOPRIGHT", ((index-16)*buttonSize)-(buttonSize / 2), -((buttonSize*2)+8))
				end
				--button:SetPoint("LEFT", parent, "RIGHT", (k*28)-14, 0)
				button:Show()

				index = index + 1
			end
		end
	end
end

local function UpdateSpellButtons()
	if InCombatLockdown() or UnitAffectingCombat("player") then
		f.CombatUpdate = 1
		return false
	end

	for i=1,4,1 do
		local parent = _G[("PartyMemberFrame%s"):format(i)]
		local index = 1
		for k,spellID in pairs(spells[UnitClass("player")]) do
			if IsSpellKnown(spellID) then
				local spellName, _, texture = GetSpellInfo(spellID)

				if not _G[("%sSpellButton%s"):format(parent:GetName(), index)] then
					local button = CreateFrame("Button", ("%sSpellButton%s"):format(parent:GetName(), index), parent, "SecureActionButtonTemplate")
				else
					local button = _G[("%sSpellButton%s"):format(parent:GetName(), index)]
				end

				button:SetSize(buttonSize, buttonSize)
				button:SetNormalTexture(texture)
				button:SetAttribute("type1", "macro")
				button:SetAttribute("macrotext1", ("#showtooltip\n/cast [@party%s] %s"):format(i, spellName))
				if index <= 8 then
					button:SetPoint("TOPLEFT", parent, "TOPRIGHT", (index*buttonSize)-(buttonSize / 2), 0)
				elseif index <= 16 then
					button:SetPoint("TOPLEFT", parent, "TOPRIGHT", ((index-8)*buttonSize)-(buttonSize / 2), -(buttonSize + 4))
				else
					button:SetPoint("TOPLEFT", parent, "TOPRIGHT", ((index-16)*buttonSize)-(buttonSize / 2), -((buttonSize*2)+8))
				end
				button:Show()

				index = index + 1				
			end
		end
	end

	local parent = PlayerFrame
	index = 1
	for k,spellID in pairs(spells[UnitClass("player")]) do
		if IsSpellKnown(spellID) then
			local spellName, _, texture = GetSpellInfo(spellID)

			if not _G[("%sSpellButton%s"):format(parent:GetName(), index)] then
				local button = CreateFrame("Button", ("%sSpellButton%s"):format(parent:GetName(), index), parent, "SecureActionButtonTemplate")
				local cdt = button:CreateFontString(button:GetName().."CDText", "OVERLAY")

				cdt:SetFont("Fonts\\ARIALN.ttf", 18, "OUTLINE")
				cdt:SetAllPoints(button)
				button.cdt = cdt

				button:SetScript("OnUpdate", function(self, elapsed)
					self.timer = (self.timer or 0) + elapsed
					local found = 0

					for i=1,40,1 do
						local _, _, _, _, _, duration, expirationTime, source, _, _, spellID = UnitBuff(unit, i)

						if spellID == self.spellID then
							found = 1

							if expirationTime <= 1 then
								self.cdt:SetTextColor(1, 0, 0, 1)
							elseif expirationTime <= 2 then
								self.cdt:SetTextColor(1, 0.5, 0, 1)
							elseif expirationTime <= 3 then
								self.cdt:SetTextColor(1, 1, 0, 1)
							else
								self.cdt:SetTextColor(1, 1, 1, 1)
							end

							if (expirationTime/3600) > 1 then
								self.cdt:SetText(ceil(expirationTime/3600).."h")
							elseif (expirationTime/60) > 1 then
								self.cdt:SetText(ceil(expirationTime/60).."m")
							else
								self.cdt:SetText(("%.1f"):format(expirationTime))
							end
						end
					end
					
					if found == 0 then
						self.cdt:Hide()
					else
						self.cdt:Show()
					end
				end)
			else
				local button = _G[("%sSpellButton%s"):format(parent:GetName(), index)]
			end
			local button = CreateFrame("Button", ("%sSpellButton%s"):format(parent:GetName(), k), parent, "SecureActionButtonTemplate")

			button.parent = parent
			button.spellID = spellID
			button:SetSize(buttonSize, buttonSize)
			button:SetNormalTexture(texture)
			button:SetAttribute("type1", "macro")
			button:SetAttribute("macrotext1", ("#showtooltip\n/cast [@player] %s"):format(spellName))
			if index <= 8 then
				button:SetPoint("TOPLEFT", parent, "TOPRIGHT", (index*buttonSize)-(buttonSize / 2), 0)
			elseif index <= 16 then
				button:SetPoint("TOPLEFT", parent, "TOPRIGHT", ((index-8)*buttonSize)-(buttonSize / 2), -(buttonSize + 4))
			else
				button:SetPoint("TOPLEFT", parent, "TOPRIGHT", ((index-16)*buttonSize)-(buttonSize / 2), -((buttonSize*2)+8))
			end
			--button:SetPoint("LEFT", parent, "RIGHT", (k*28)-14, 0)
			button:Show()

			index = index + 1
			--print(button:GetName())
		end
	end
end

local function OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 0.2 then
		if self.CombatUpdate == 1 and not InCombatLockdown() and not UnitAffectingCombat("player") then
			UpdateSpellButtons()
			self.CombatUpdate = 0
		end
		self.timer = 0
	end
end

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)
