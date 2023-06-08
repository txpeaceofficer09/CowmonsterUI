local f = CreateFrame("ScrollingMessageFrame", "TauntLogFrame", UIParent)

f:EnableKeyboard(false)
f:EnableMouse(true)
f:EnableMouseWheel(true)

f:SetPoint("TOPLEFT", TabParent, "TOPLEFT", 10, -10)
f:SetPoint("BOTTOMRIGHT", TabParent, "BOTTOMRIGHT", -10, 10)
f:SetFading(false)
f:SetFontObject("ChatFontNormal")
f:SetTextColor(1, 1, 1, 1)
f:SetJustifyH("LEFT")
f:SetMaxLines(4096)

CreateTab(TauntLogFrame)

f:Hide()

function IsTauntSpell(spellID)
	local taunts = {
		--Warrior
		355, --Taunt
		1161, --Challenging Shout

		--Death Knight
		49576, --Death Grip
		56222, --Dark Command

		--Paladin
		62124, --Hand of Reckoning
		31789, --Righteous Defense

		--Druid
		6795, --Growl
		5209, --Challenging Roar

		--Hunter
		20736, --Distracting Shot

		--Hunter Pet
		2649, -- Growl

		--Shaman
		73684, --Unleash Earth
			
		--Monk
		115546, --Provoke

		--Warlock
		59671, --Challenging Howl
	};

	for k,v in ipairs(taunts) do
		if v == spellName then
			return true
		end
	end

	return false
end

f:SetScript("OnEvent", function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, event, hideCaster, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _, spellID, spellName, spellSchool = ...
		local msg = nil

		if spellID ~= nil and IsTauntSpell(spellID) then
			if ( bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 or bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) > 0 ) and not bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
				if bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PET) then
					local owner = GetPlayerInfoByGUID(srcGUID)
					msg = ("%s's pet, %s, taunted %s using %s (%s)."):format(owner, srcName, dstName, spellName, spellID)
				else
					msg = ("%s taunted %s using %s (%s)."):format(srcName, dstName, spellName, spellID)
				end
			elseif bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
				if bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PET) > 0 then
					msg = ("My pet, %s, taunted %s using %s (%s)."):format(srcName, dstName, spellName, spellID)
				else
					msg = ("I taunted %s using %s (%s)."):format(dstName, spellName, spellID)
				end
			end

			if msg ~= nil then TauntLogFrame:AddMessage(msg, 1, 1, 1) end
		end
	end
end)

f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

f:SetScript("OnMouseWheel", function(self, delta)
	if delta > 0 then
		self:ScrollUp()
	else
		self:ScrollDown()
	end
end)
