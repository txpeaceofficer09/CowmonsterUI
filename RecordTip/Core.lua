local addonName, addonTable = ...

addonTable.Funcs = {}

local MyFuncs = addonTable.Funcs

local RT = CreateFrame("MessageFrame", "RecordTipFrame", UIParent)

function MyFuncs.AddComma(num)
	local retVal = num
	local i

	while true do
		retVal, i = string.gsub(retVal, "^(-?%d+)(%d%d%d)", '%1,%2')

		if i == 0 then break end
	end

	return retVal
end

function MyFuncs.OnEvent(self, event, ...)
	if event == "ADDON_LOADED" and select(1, ...) == "RecordTip" then
		if RecordTipDB and ( RecordTipDB["dmg"] or RecordTipDB["heal"] ) then RecordTipDB = nil end -- Remove old format database so we can use the new that has per spec records.

		if RecordTipDB == nil then
			for spec=1,4,1 do
				RecordTipDB[spec] = {["dmg"] = {}, ["heal"] = {}, ["absorb"] = {}}
			end
			--RecordTipDB = {[1] = {["dmg"] = {}, ["heal"] = {}}, [2] = {["dmg"] = {}, ["heal"] = {}}, [3] = {["dmg"] = {}, ["heal"] = {}}, [4] = {["dmg"] = {}, ["heal"] = {}}}
		end

		if not RecordTipDB[4] then RecordTipDB[4] = {["dmg"] = {}, ["heal"] = {}} end
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, amount, critSwing, _, critHeal, _, _, critDmg = ...
		local TalentSpec = GetSpecialization() or 4

		if RecordTipDB[TalentSpec].dmg == nil then RecordTipDB[TalentSpec].dmg = {} end
		if RecordTipDB[TalentSpec].heal == nil then RecordTipDB[TalentSpec].heal = {} end
		if RecordTipDB[TalentSpec].absorb == nil then RecordTipDB[TalentSpec].absorb = {} end

		if sourceName == UnitName("player") then
			if string.find(combatEvent, "SWING") then
				local spell = "Auto Attack"
				local amount = spellName or 0
				local crit = critSwing or 0

				RecordTipDB[TalentSpec].dmg[spell] = RecordTipDB[TalentSpec].dmg[spell] or {["norm"] = 0, ["crit"] = 0}
				if crit == 1 then
					local record = RecordTipDB[TalentSpec].dmg[spell].crit or 0
					
					if record < amount then
						RecordTipDB[TalentSpec].dmg[spell].crit = amount
					end
				else
					local record = RecordTipDB[TalentSpec].dmg[spell].norm or 0

					if record < amount then
						RecordTipDB[TalentSpec].dmg[spell].norm = amount
					end
				end
			elseif string.find(combatEvent, "_DAMAGE") then
				local spell = spellName
				local amount = amount or 0
				local crit = critDmg or 0
	
				if spell and type(spell) == "string" then
					RecordTipDB[TalentSpec].dmg[spell] = RecordTipDB[TalentSpec].dmg[spell] or {["norm"] = 0, ["crit"] = 0}
					if crit == 1 then
						local record = RecordTipDB[TalentSpec].dmg[spell].crit or 0
	
						if record < amount then
							RecordTipDB[TalentSpec].dmg[spell].crit = amount
						end
					else
						local record = RecordTipDB[TalentSpec].dmg[spell].norm or 0
	
						if record < amount then
							RecordTipDB[TalentSpec].dmg[spell].norm = amount
						end
					end
				end
			elseif string.find(combatEvent, "_HEAL") then
				local spell = spellName
				local amount = amount or 0
				local crit = critHeal or 0
	
				if spell and type(spell) == "string" then
					RecordTipDB[TalentSpec].heal[spell] = RecordTipDB[TalentSpec].heal[spell] or {["norm"] = 0, ["crit"] = 0}
	
					if crit == 1 then
						local record = RecordTipDB[TalentSpec].heal[spell].crit or 0
	
						if record < amount then
							RecordTipDB[TalentSpec].heal[spell].crit = amount
						end
					else
						local record = RecordTipDB[TalentSpec].heal[spell].norm or 0
	
						if record < amount then
							RecordTipDB[TalentSpec].heal[spell].norm = amount
						end
					end
				end
			elseif string.find(combatEvent, "_ABSORBED") then
				local spell = spellName
				local amount = amount or 0
				local crit = critHeal or 0
				
				if spell and type(spell) == "string" then
					RecordTipDB[TalentSpec].absorb[spell] = RecordTipDB[TalentSpec].absorb[spell] or {["norm"] = 0, ["crit"] = 0}
					
					if crit == 1 then
						local record = RecordTipDB[TalentSpec].absorb[spell].cirt or 0
						
						if record < amount then
							RecordTipDB[TalentSpec].absorb[spell].crit = amount
						end
					else
						local record = RecordTipDB[TalentSpec].absorb[spell].norm or 0
						
						if record < amount then
							RecordTipDB[TalentSpec].absorb[spell].norm = amount
						end
					end
				end
			end
		end
	end
end

RT:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
RT:RegisterEvent("ADDON_LOADED")
RT:SetScript("OnEvent", MyFuncs.OnEvent)

GameTooltip:HookScript("OnShow", function(self)
	local spell = self:GetSpell();

	for TalentSpec = 1, 4, 1 do
		local spec = select(2, GetSpecializationInfo(TalentSpec)) or "No Spec"

		if RecordTipDB[TalentSpec].dmg == nil then RecordTipDB[TalentSpec].dmg = {} end
		if RecordTipDB[TalentSpec].heal == nil then RecordTipDB[TalentSpec].heal = {} end
		if RecordTipDB[TalentSpec].absorb == nil then RecordTipDB[TalentSpec].absorb = {} end

		if spell and RecordTipDB[TalentSpec].dmg[spell] and (RecordTipDB[TalentSpec].dmg[spell].crit > 0 or RecordTipDB[TalentSpec].dmg[spell].norm > 0) then
			self:AddLine(" ");
			self:AddLine("|cFFFFFF44["..spec.."] |cFFFF4444Damage");
			if RecordTipDB[TalentSpec].dmg[spell.."!"] and ( RecordTipDB[TalentSpec].dmg[spell.."!"].norm or 0 ) > ( RecordTipDB[TalentSpec].dmg[spell].norm or 0 ) then
				self:AddDoubleLine("Normal", MyFuncs.AddComma(RecordTipDB[TalentSpec].dmg[spell.."!"].norm), 1, 1, 1, 0, 1, 0);
			elseif ( RecordTipDB[TalentSpec].dmg[spell].norm or 0 ) > 0 then
				self:AddDoubleLine("Normal", MyFuncs.AddComma(RecordTipDB[TalentSpec].dmg[spell].norm), 1, 1, 1, 0, 1, 0);
			end

			if RecordTipDB[TalentSpec].dmg[spell.."!"] and ( RecordTipDB[TalentSpec].dmg[spell.."!"].crit or 0 ) > ( RecordTipDB[TalentSpec].dmg[spell].crit or 0 ) then
				self:AddDoubleLine("Critical", MyFuncs.AddComma(RecordTipDB[TalentSpec].dmg[spell.."!"].crit), 1, 1, 1, 0, 1, 0);
			elseif ( RecordTipDB[TalentSpec].dmg[spell].crit or 0 ) > 0 then
				self:AddDoubleLine("Critical", MyFuncs.AddComma(RecordTipDB[TalentSpec].dmg[spell].crit), 1, 1, 1, 0, 1, 0);
			end
		end

		if spell and RecordTipDB[TalentSpec].heal[spell] and (RecordTipDB[TalentSpec].heal[spell].crit > 0 or RecordTipDB[TalentSpec].heal[spell].norm > 0) then
			self:AddLine(" ");
			self:AddLine("|cFFFFFF44["..spec.."] |cFF44FF44Heal");
			if RecordTipDB[TalentSpec].heal[spell.."!"] and ( RecordTipDB[TalentSpec].heal[spell.."!"].norm or 0 ) > ( RecordTipDB[TalentSpec].heal[spell].norm or 0 ) then
				self:AddDoubleLine("Normal", MyFuncs.AddComma(RecordTipDB[TalentSpec].heal[spell.."!"].norm), 1, 1, 1, 0, 1, 0);
			elseif ( RecordTipDB[TalentSpec].heal[spell].norm or 0 ) > 0 then
				self:AddDoubleLine("Normal", MyFuncs.AddComma(RecordTipDB[TalentSpec].heal[spell].norm), 1, 1, 1, 0, 1, 0);
			end

			if RecordTipDB[TalentSpec].heal[spell.."!"] and ( RecordTipDB[TalentSpec].heal[spell.."!"].crit or 0 ) > ( RecordTipDB[TalentSpec].heal[spell].crit or 0 ) then
				self:AddDoubleLine("Critical", MyFuncs.AddComma(RecordTipDB[TalentSpec].heal[spell.."!"].crit), 1, 1, 1, 0, 1, 0);
			elseif ( RecordTipDB[TalentSpec].heal[spell].crit or 0 ) > 0 then
				self:AddDoubleLine("Critical", MyFuncs.AddComma(RecordTipDB[TalentSpec].heal[spell].crit), 1, 1, 1, 0, 1, 0);
			end
		end
		
		if spell and RecordTipDB[TalentSpec].absorb[spell] and ( RecordTipDB[TalentSpec].absorb[spell.."!"].norm or 0 ) > ( RecordTipDB[TalentSpec].absorb[spell].norm or 0 ) then
			self:AddLine(" ");
			self:AddLine("|cFFFFFF44["..spec.."] |cFFFFFF44Absorb");
			if RecordTipDB[TalentSpec].absorb[spell.."!"] and ( RecordTipDB[TalentSpec].absorb[spell.."!"].norm or 0 ) > ( RecordTipDB[TalentSpec].absorb[spell].norm or 0 ) then
				self:AddDoubleLine("Normal", MyFuncs.AddComma(RecordTipDB[TalentSpec].absorb[spell.."!"].norm), 1, 1, 1, 0, 1, 0);
			elseif ( RecordTipDB[TalentSpec].absorb[spell].norm or 0 ) > 0 then
				self:AddDoubleLine("Normal", MyFuncs.AddComma(RecordTipDB[TalentSpec].absorb[spell].norm), 1, 1, 1, 0, 1, 0);
			end

			if RecordTipDB[TalentSpec].absorb[spell.."!"] and ( RecordTipDB[TalentSpec].absorb[spell.."!"].crit or 0 ) > ( RecordTipDB[TalentSpec].absorb[spell].crit or 0 ) then
				self:AddDoubleLine("Critical", MyFuncs.AddComma(RecordTipDB[TalentSpec].absorb[spell.."!"].crit), 1, 1, 1, 0, 1, 0);
			elseif ( RecordTipDB[TalentSpec].absorb[spell].crit or 0 ) > 0 then
				self:AddDoubleLine("Critical", MyFuncs.AddComma(RecordTipDB[TalentSpec].absorb[spell].crit), 1, 1, 1, 0, 1, 0);
			end
		end
	end
end);

function MyFuncs.ResetDB()
	RecordTipDB = nil
	RecordTipDB = {[1] = {["dmg"] = {}, ["heal"] = {}}, [2] = {["dmg"] = {}, ["heal"] = {}}, [3] = {["dmg"] = {}, ["heal"] = {}}, [4] = {["dmg"] = {}, ["heal"] = {}}}
	DEFAULT_CHAT_FRAME:AddMessage("|cFF44FF44RecordTip|cFFFFFFFF all records reset.")	
end

function MyFuncs.SlashCmdHandler(...)
	if select(1, ...) and string.lower(select(1, ...)) == "reset" then
		--RecordTipDB = nil
		--RecordTipDB = {[1] = {["dmg"] = {}, ["heal"] = {}}, [2] = {["dmg"] = {}, ["heal"] = {}}, [3] = {["dmg"] = {}, ["heal"] = {}}, [4] = {["dmg"] = {}, ["heal"] = {}}}
		--DEFAULT_CHAT_FRAME:AddMessage("|cFF44FF44RecordTip|cFFFFFFFF all records reset.")
		MyFuncs.ResetDB()
	end
end

SlashCmdList['RECORDTIP_SLASHCMD'] = MyFuncs.SlashCmdHandler
SLASH_RECORDTIP_SLASHCMD1 = '/recordtip'
SLASH_RECORDTIP_SLASHCMD2 = '/rt'
