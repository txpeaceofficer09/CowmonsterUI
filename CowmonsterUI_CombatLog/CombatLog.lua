local f = CreateFrame("ScrollingMessageFrame", "CombatLogFrame", UIParent)

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

CreateTab(CombatLogFrame)

f:Hide()

--COMBATLOG = CombatLogFrame

function f.OnEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, event, hideCaster, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _ = ...
		local msg, srcClass, dstClass, srcLink, dstLink

		if srcName == nil then srcName = "Unknown" end

		if string.find(event, "_DAMAGE") then
			local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing

			if strsub(event, 1, 5) == "SWING" then
				amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...)
				spellName = "Auto Attack"
				spellSchool = 1
			elseif not srcName then
				spellName, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...)
				srcName = "Environment"
				spellSchool = 1
			else
				spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...)
			end

			if ( bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 ) or (bit.band(dstFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 and bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 ) then
				msg = "[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] [|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r] [|c"..CombatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r] "..amount
				if overkill and overkill > 0 then msg = msg.." ("..overkill.." |cffff0000Overkill|r)" end
				if blocked and blocked > 0 then msg = msg.." ("..blocked.." |cff0000ffBlocked|r)" end
				if absorbed and absorbed > 0 then msg = msg.." ("..absorbed.." |cff00ff00Absorbed|r)" end
				if glancing then msg = msg.." (|cffff0080Glancing|r)" end
				if crushing then msg = msg.." (|cff8000Crushing|r)" end
				if resisted and resisted > 0 then msg = msg.." ("..resisted.." |cff8080ffResisted|r)" end
				if critical then msg = msg.." (|cffffff00Critical|r)" end
			end
		elseif string.find(event, "_MISSED") then
			local spellID, spellName, spellSchool, amount, missType

			if strsub(event, 1, 5) == "SWING" then
				missType, amountMissed = select(12, ...)
				spellName = "Auto Attack"
				spellSchool = 1
			else
				spellID, spellName, spellSchool, missType, amountMissed = select(12, ...)
			end

			if srcName == UnitName("player") or dstName == UnitName("player") then
				msg = "[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] [|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r] [|c"..CombatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r]"
				if amountMissed then
					msg = msg.." ("..amountMissed.." "..missType..")"
				else
					msg = msg.." ("..missType..")"
				end
			end
		elseif string.find(event, "_HEAL") then
			local spellID, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)

			if bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 and bit.band(dstFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 and ( bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 or bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 ) then
				msg = "[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] [|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r] [|c"..CombatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r]"
				if amount and amount > 0 then msg = msg.." "..amount end
				if absorbed and absorbed > 0 then msg = msg.." ("..absorbed.." |cff8080ffAbsorbed|r)" end
				if critical then msg = msg.." (|cff00ff00Critical|r)" end
			end
		elseif string.find(event, "_AURA_APPLIED") then
			local spellID, spellName, spellSchool, auraType = select(12, ...)

			if bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 and bit.band(dstFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 and bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 and srcName ~= dstName then
				if spellName == "Heroism" or spellName == "Time Warp" or spellName == "Bloodlust" or spellName == "Focus Magic" then
					--SendChatMessage("Thank you for the "..spellName.." buff, "..srcName..".", "WHISPER", nil, srcName)
				end
			end
		elseif string.find(event, "_AURA_REMOVED") then

		elseif string.find(event, "_EXTRA_ATTACKS") then

		elseif string.find(event, "_STOLEN") then
			local spellID, spellName, spellSchool, stolenID, stolenName, stolenSchool = select(12, ...)

			if bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
				msg = "[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] stole "..GetSpellLink(stolenID).." from [|c"..CombatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r]"
			elseif bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 and bit.band(dstFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 and bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
				msg = "[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] stole "..GetSpellLink(stolenID).." from [|c"..CombatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r]"
				PlaySound("RaidWarning", "Master")
			end
		elseif string.find(event, "_DISPELL") then

		elseif string.find(event, "_INTERRUPT") then

		elseif string.find(event, "_RESURRECT") then
			if bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 or bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 then
				--CombatLogFrame:AddMessage("[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] [|cffffff00"..spellName.."|r] [|c"..CombatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r] (|cff8080ffRESURRECTION)", 0, 1, 0, 1)
				--DEFAULT_CHAT_FRAME:AddMessage(srcName.." resurrected "..dstName.." with "..select(12, ...)..".", 1, 0.5, 0, 1)
				CombatLogFrame:AddMessage("[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] [|cff8080ffRESURRECTION|r] [|c"..CombatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r]", 0, 1, 0, 1)

				if not CombatLogFrame:IsShown() then
					DEFAULT_CHAT_FRAME:AddMessage(srcName.." resurrected "..dstName..".", 1, 0.5, 0, 1)
				end
			elseif bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
				--CombatLogFrame:AddMessage("[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] [|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r] [|c"..CombatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r] (|cff8080ffRESURRECTION)", 1, 0, 0, 1)
				CombatLogFrame:AddMessage("[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] [|cff8080ffRESURRECTION|r] [|c"..COmbatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r]", 1, 0, 0, 1)
				DEFAULT_CHAT_FRAME:AddMessage("{skull} "..srcName.." resurrected "..dstName..". {skull}", 1, 0, 0, 1)
				PlaySound("RaidWarning", "Master")
			end
		elseif string.find(event, "_CAST_START") then

		elseif string.find(event, "_CAST_SUCCESS") then
--			local spellID, spellName, spellSchool = select(11, ...)
--
--			if bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 and bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
--				if spellID == 355 or spellID == 49576 or spellID == 56222 or spellID == 62124 or spellID == 6795 or spellID == 20736 then
--					-- Single Target Taunt
--					msg = "[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] [|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r] [|c"..CombatLog_Color_ColorStringByUnitType(dstFlags)..dstName.."|r] |cff00ff00SUCCESS!|r (|cffff0000TAUNT|r)"
--				elseif spellID == 1161 or spellID == 31789 or spellID == 5209 or spellID == 59671 then
--					-- AOE Taunt
--					msg = "[|c"..CombatLog_Color_ColorStringByUnitType(srcFlags)..srcName.."|r] [|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r] [AOE] (|cffff0000TAUNT|r)"
--				end
--			end
		elseif string.find(event, "_CAST_FAILED") then

		end

		if msg then CombatLogFrame:AddMessage(msg, 1, 1, 1, 1) end
	end
end

f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

f:SetScript("OnEvent", f.OnEvent)
f:SetScript("OnMouseWheel", function(self, delta)
	if delta > 0 then
		self:ScrollUp()
	else
		self:ScrollDown()
	end
end)
