local f = CreateFrame("Frame")

local auras = {
	--48707--[[Anti-Magic Shell]],
	31850--[[Ardent Defender]],
	31884--[[Avenging Wrath]],
	22812--[[Barkskin]],
	--2825--[[Bloodlust]],
	--49222--[[Bone Shield]],
	--47585--[[Dispersion]],
	--64843--[[Divine Hymn]],
	--64844--[[Divine Hymn]],
	54428--[[Divine Plea]],
	498--[[Divine Protection]],
	642--[[Divine Shield]],
	55694--[[Enraged Regeneration]],
	--12051--[[Evocation]],
	--586--[[Fade]],
	22842--[[Frenzied Regeneration]],
	1044--[[Hand of Freedom]],
	1022--[[Hand of Protection]],
	6940--[[Hand of Sacrifice]],
	1038--[[Hand of Salvation]],
	--32182--[[Heroism]],
	--64901--[[Hymn of Hope]],
	--64904--[[Hymn of Hope]],
	45438--[[Ice Block]],
	48792--[[Icebound Fortitude]],
	29166--[[Innervate]],
	--32612--[[Invisibility]],
	--96243--[[Invisibility]],
	--74497--[[Lifeblood]],
	34477--[[Misdirection]],
	871--[[Shield Wall]],
	--130--[[Slow Fall]],
	61336--[[Survival Instincts]],
	--80353--[[Time Warp]],
	57934--[[Tricks of the Trade]],
	55233--[[Vampiric Blood]],
}

local creates = {
	67826--[[Jeeves]],
	88304--[[Mobile Banking]],
	54710--[[MOLL-E]],
	53142--[[Portal: Dalaran]],
	11419--[[Portal: Darnassus]],
	32266--[[Portal: Exodar]],
	11416--[[Portal: Ironforge]],
	11417--[[Portal: Orgrimmar]],
	33691--[[Portal: Shattrath (Alliance)]],
	35717--[[Portal: Shattrath (Horde)]],
	32267--[[Portal: Silvermoon]],
	49361--[[Portal: Stonard]],
	10059--[[Portal: Stormwind]],
	49360--[[Portal: Theramore]],
	11420--[[Portal: Thunder Bluff]],
	88345--[[Portal: Tol Barad (Alliance)]],
	88346--[[Portal: Tol Barad (Horde)]],
	11418--[[Portal: Undercity]],
	92827--[[Ritual of Refreshment]],
	43987--[[Ritual of Refreshment]],
}

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

local resurrects = {
	2008--[[Ancestral Spirit]],
	61999--[[Raise Ally]],
	20484--[[Rebirth]],
	7328--[[Redemption]],
	20608--[[Reincarnation]],
	2006--[[Resurrection]],
	50769--[[Revive]],
}

local crowdcontrols = {
	710--[[Banish]],
	--2094--[[Blind]],
	--1833--[[Cheap Shot]],
	33786--[[Cyclone]],
	6789--[[Death Coil]],
	1098--[[Enslave Demon]],
	339--[[Entangling Roots]],
	5782--[[Fear]],
	51514--[[Hex]],
	2637--[[Hibernate]],
	5484--[[Howl of Terror]],
	13809--[[Ice Trap]],
	82941--[[Ice Trap - Trap Launcher]],
	--408--[[Kidney Shot]],
	118--[[Polymorph]],
	61305--[[Polymorph - Black Cat]],
	28272--[[Polymorph - Pig]],
	61721--[[Polymorph - Rabbit]],
	61780--[[Polymorph - Turkey]],
	28271--[[Polymorph - Turtle]],
	6770--[[Sap]],
	--10236--[[Turn Evil]],
}

local function PrintMsg(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffaaffAnnouncer:|r "..msg)
end

local function IsInGuild(name)
	for i=1, GetNumGuildMembers(), 1 do
		if GetGuildRosterInfo(i) == name then
			return true
		end
	end

	return false
end

function GuildMemberArmorClass(srchName)
	local ac = {
		["DEATHKNIGHT"] = "Plate",
		["DRUID"] = "Leather",
		["HUNTER"] = "Mail",
		["MAGE"] = "Cloth",
		["MONK"] = "Leather",
		["PALADIN"] = "Plate",
		["PRIEST"] = "Cloth",
		["ROGUE"] = "Leather",
		["SHAMAN"] = "Mail",
		["WARLOCK"] = "Cloth",
		["WARRIOR"] = "Plate"
	}

	for i=1, GetNumGuildMembers(), 1 do
		local name, _, _, level, _, _, _, _, _, _, class = GetGuildRosterInfo(i)

		if srchName == name then
			if ac[class] == "Plate" and level < 40 then
				return "Mail"
			elseif ac[class] == "Mail" and level < 40 then
				return "Leather"
			else
				return ac[class]
			end
		end
	end

	return false
end

local function NameIsUnit(name)
	if name == UnitName("player") then
		return "player"
	elseif UnitInRaid("player") then
		for i=1, GetNumGroupMembers(), 1 do
			if UnitName("raid"..i) == name then
				return "raid"..i
			end
		end
	elseif GetNumGroupMembers() > 0 then
		for i=1, GetNumGroupMembers(), 1 do
			if UnitName("party"..i) == name then
				return "party"..i
			end
		end
	end

	return false
end

local function OutputChannel()
	local isInstance, instanceType = IsInInstance()
	local channel = "SAY"

--[[
	if isInstance then
		if instanceType == "arena" then
			channel = "PARTY"
		elseif instanceType == "party" then
			channel = "PARTY"
		elseif instanceType == "raid" then
			channel = "RAID"
		elseif instanceType == "pvp" then
			channel = "BATTLEGROUND"
		else
			channel = "YELL"
		end
	else
		if UnitInRaid("player") then
			channel = "RAID"
		elseif GetNumGroupMembers() > 0 then
			channel = "PARTY"
		end
	end

	if channel == "SAY" then
		if UnitInRaid("player") then
			channel = "RAID"
		elseif GetNumGroupMembers() > 0 then
			channel = "PARTY"
		end
	end
]]
	return channel
end

local function Iconize(flags, str)
	local iconStr = str

	if bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET1) > 0 then
		iconStr = "{rt1} "..str.." {rt1}"
	elseif bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET2) > 0 then
		iconStr = "{rt2} "..str.." {rt2}"
	elseif bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET3) > 0 then
		iconStr = "{rt3} "..str.." {rt3}"
	elseif bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET4) > 0 then
		iconStr = "{rt4} "..str.." {rt4}"
	elseif bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET5) > 0 then
		iconStr = "{rt5} "..str.." {rt5}"
	elseif bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET6) > 0 then
		iconStr = "{rt6} "..str.." {rt6}"
	elseif bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET7) > 0 then
		iconStr = "{rt7} "..str.." {rt7}"
	elseif bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET8) > 0 then
		iconStr = "{rt8} "..str.." {rt8}"
	end

	return iconStr
end

local function OnEvent(self, event, ...)
	--[[
	if UnitInRaid("player") then
		channel = "RAID"
	elseif GetNumGroupMembers() > 0 then
		channel = "PARTY"
	else
		channel = "SAY"
	end
	]]
	channel = OutputChannel()

	if event == "ADDON_LOADED" and ... == "Announcer" then
		AnnouncerConfig:Init()
	elseif event == "CHAT_MSG_LOOT" then
		local msg = select(1, ...)
		local name, link = string.match(msg, "(.+) receive loot: (.+).")
--		local channel = OutputChannel()

		if name == "You" then name = UnitName("player") end

		if link then
			local _, _, quality, ilvl, rlvl, class, subclass = GetItemInfo(link)

			if ( UnitName("player") == name or IsInGuild(name) ) and quality >= 3 and class == "Armor" and GuildMemberArmorClass(name) == subclass then
				if ( Announcer_Config.AnnounceGuildRaidLoots == 1 and channel == "RAID" ) or ( Announcer_Config.AnnounceGuildPartyLoots == 1 and channel == "PARTY" ) then
					SendChatMessage(name.." received "..link..".", "GUILD")
				end
			end
		end
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, event, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = ...
--		local channel = OutputChannel()

--		if channel == "BATTLEGROUND" then return false end

		if string.find(event, "_INTERRUPT") then
			local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSchool = select(12, ...)

			if Announcer_Config.AnnounceMyInterrupts == 1 and srcGUID == UnitGUID("player") then
				SendChatMessage(dstName.."'s "..GetSpellLink(extraSpellID).." interrupted by my "..GetSpellLink(spellID)..".", channel)
			elseif Announcer_Config.AnnounceRaidInterrupts == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
				SendChatMessage(dstName.."'s "..GetSpellLink(extraSpellID).." interrupted by "..srcName.."'s "..GetSpellLink(spellID)..".", channel)
			elseif Announcer_Config.PrintRaidInterrupts == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and ( srcGUID ~= UnitGUID("player") or Announcer_Config.AnnounceMyInterrupts == 0 ) then
				PrintMsg(dstName.."'s "..GetSpellLink(extraSpellID).." interrupted by "..srcName.."'s "..GetSpellLink(spellID)..".")
			end
		elseif string.find(event, "_AURA_APPLIED") then
			local spellID, spellName, spellSchool, auraType = select(12, ...)

			if tContains(auras, spellID) then
				if Announcer_Config.AnnounceMyAuras == 1 and srcGUID == UnitGUID("player") then
					SendChatMessage(GetSpellLink(spellID).." cast on me.", channel)
				elseif Announcer_Config.AnnounceRaidAuras == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					SendChatMessage(srcName.."'s "..GetSpellLink(spellID).." cast on "..dstName..".", channel)
				elseif Announcer_Config.PrintRaidAuras == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					PrintMsg(srcName.."'s "..GetSpellLink(spellID).." cast on "..dstName..".")
				end
			end

			if tContains(crowdcontrols, spellID) then
				if srcName then
					if Announcer_Config.AnnounceMyCCs == 1 and srcGUID == UnitGUID("player") then
						SendChatMessage("My "..GetSpellLink(spellID).." cast on "..Iconize(dstFlags, dstName)..".", channel)
					elseif Announcer_Config.AnnounceRaidCCs == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
						SendChatMessage(srcName.."'s "..GetSpellLink(spellID).." cast on "..Iconize(dstFlags, dstName)..".", channel)
					elseif Announcer_Config.PrintRaidCCs == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and ( srcGUID ~= UnitGUID("player") or Announcer_Config.AnnounceMyCCs == 0 ) then
						PrintMsg(srcName.."'s "..GetSpellLink(spellID).." cast on "..Iconize(dstFlags, dstName)..".")
					end
				end
			end
		elseif string.find(event, "_AURA_REMOVED") then
			local spellID, spellName, spellSchool, auraType = select(12, ...)

			if tContains(auras, spellID) then
				if Announcer_Config.AnnounceMyAuras == 1 and srcGUID == UnitGUID("player") then
					SendChatMessage(GetSpellLink(spellID).." faded from me.", channel)
				elseif Announcer_Config.AnnounceRaidAuras == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					SendChatMessage(srcName.."'s "..GetSpellLink(spellID).." faded from "..dstName..".", channel)
				elseif Announcer_Config.PrintRaidAuras == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					PrintMsg(srcName.."'s "..GetSpellLink(spellID).." faded from "..dstName..".")
				end
			end

			if tContains(crowdcontrols, spellID) then
				if srcName then
					if Announcer_Config.AnnounceMyCCs == 1 and srcGUID == UnitGUID("player") then
						SendChatMessage("My "..GetSpellLink(spellID).." broke on "..Iconize(dstFlags, dstName)..".", channel)
					elseif Announcer_Config.AnnounceRaidCCs == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
						SendChatMessage(srcName.."'s "..GetSpellLink(spellID).." broke on "..Iconize(dstFlags, dstName)..".", channel)
					elseif Announcer_Config.PrintRaidCCs == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and ( srcGUID ~= UnitGUID("player") or Announcer_Config.AnnounceMyCCs == 0 ) then
						PrintMsg(srcName.."'s "..GetSpellLink(spellID).." broke on "..Iconize(dstFlags, dstName)..".")
					end
				end
			end
		elseif string.find(event, "_STOLEN") then
			local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSpellSchool = select(12, ...)

			if Announcer_Config.AnnounceMySteals == 1 and srcGUID == UnitGUID("player") then
				SendChatMessage("I stole "..GetSpellLink(extraSpellID).." from "..dstName.." using "..GetSpellLink(spellID)..".", channel)
			elseif Announcer_Config.AnnounceRaidSteals == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
				SendChatMessage(srcName.." stole "..GetSpellLink(extraSpellID).." from "..dstName.." using "..GetSpellLink(spellID)..".", channel)
			elseif Announcer_Config.PrintRaidSteals == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and ( srcGUID ~= UnitGUID("player") or Announcer_Config.AnnounceMySteals == 0 ) then
				PrintMsg(srcName.." stole "..GetSpellLink(extraSpellID).." from "..dstName.." using "..GetSpellLink(spellID)..".")
			end
		elseif string.find(event, "_DISPELL") then
			local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSpellSchool = select(12, ...)

			if Announcer_Config.AnnounceMyDispells == 1 and srcGUID == UnitGUID("player") then
				SendChatMessage("I dispelled "..GetSpellLink(extraSpellID).." from "..dstName.." using "..GetSpellLink(spellID)..".", channel)
			elseif Announcer_Config.AnnounceRaidDispells == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
				SendChatMessage(srcName.." dispelled "..GetSpellLink(extraSpellID).." from "..dstName.." using "..GetSpellLink(spellID)..".", channel)
			elseif Announcer_Config.PrintRaidDispells == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and ( srcGUID ~= UnitGUID("player") or Announcer_Config.AnnounceMyDispells == 0 ) then
				SendChatMessage(srcName.." dispelled "..GetSpellLink(extraSpellID).." from "..dstName.." using "..GetSpellLink(spellID)..".")
			end
		elseif string.find(event, "_DISPELL_FAILED") then
			local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSpellSchool = select(12, ...)

			if Announcer_Config.AnnounceMyDispells == 1 and srcGUID == UnitGUID("player") then
				SendChatMessage("My "..GetSpellLink(spellID).." failed to dispell "..GetSpellLink(extraSpellID).." from "..dstName..".", channel)
			elseif Announcer_Config.AnnounceRaidDispells == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
				SendChatMessage(srcName.."'s "..GetSpellLink(spellID).." failed to dispell "..GetSpellLink(extraSpellID).." from "..dstName..".", channel)
			elseif Announcer_Config.PrintRaidDispells == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and ( srcGUID ~= UnitGUID("player") or Announcer_Config.AnnounceMyDispells == 0 ) then
				PrintMsg(srcName.."'s "..GetSpellLink(spellID).." failed to dispell "..GetSpellLink(extraSpellID).." from "..dstName..".")
			end
		elseif string.find(event, "_RESURRECT") then
			local spellID, spellName, spellSchool = select(12, ...)

			if Announcer_Config.AnnounceMyResurrects == 1 and srcGUID == UnitGUID("player") then
				SendChatMessage(dstName.." resurrected by my "..GetSpellLink(spellID)..".", channel)
			elseif Announcer_Config.AnnounceRaidResurrects == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
				SendChatMessage(dstName.." resurrected by "..srcName.."'s "..GetSpellLink(spellID)..".", channel)
			elseif Announcer_Config.PrintRaidResurrects == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
				PrintMsg(dstName.." resurrected by "..srcName.."'s "..GetSpellLink(spellID)..".")
			end
		elseif string.find(event, "_DAMAGE") then
			local overkill, amount

			if string.sub(event, 1, 5) == "SWING" then
				amount, overkill = select(12, ...)
			else
				amount, overkill = select(15, ...)
			end

			if bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 then
				if overkill ~= nil and overkill >= 0 then
					if Announcer_Config.AnnounceRaidDeaths == 1 then
						SendChatMessage(dstName.." killed by "..srcName..". "..amount.." ("..overkill.." Overkill)", channel)
					elseif Announcer_Config.PrintRaidDeaths == 1 then
						PrintMsg(dstName.." killed by "..srcName..". "..amount.." ("..overkill.." Overkill)")
					end
				end
			end
		elseif string.find(event, "_CREATE") then
			local spellID, spellName, spellSchool = select(12, ...)

			if tContains(creates, spellID) then
				if srcGUID == UnitGUID("player") and Announcer_Config.AnnounceMyCreates == 1 then
					SendChatMessage(GetSpellLink(spellID).." is up!", channel)
				elseif bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and Announcer_Config.AnnounceRaidCreates == 1 and srcGUID ~= UnitGUID("player") then
					SendChatMessage(srcName.."'s "..GetSpellLink(spellID).." is up!", channel)
				elseif bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and Announcer_Config.PrintRaidCreates == 1 and srcGUID ~= UnitGUID("player") then
					PrintMsg(srcName.."'s "..GetSpellLink(spellID).." is up!")
				end
			else
				--PrintMsg("[DEBUG]: "..spellID.." "..spellName.." "..dstName)
			end
		elseif string.find(event, "_CAST_START") then
			local spellID, spellName, spellSchool = select(12, ...)

			if tContains(resurrects, spellID) then
				if NameIsUnit(srcName) and UnitIsDead(NameIsUnit(srcName).."target") and UnitIsFriend(NameIsUnit(srcName), NameIsUnit(srcName).."target") then
					dstName = UnitName(NameIsUnit(srcName).."target")
				else
					return false
				end

				if Announcer_Config.AnnounceMyResurrects == 1 and srcGUID == UnitGUID("player") then
					SendChatMessage("Casting "..GetSpellLink(spellID).." on "..dstName..".", channel)
				elseif Announcer_Config.AnnounceRaidResurrects == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					SendChatMessage(srcName.." is casting "..GetSpellLink(spellID).." on "..dstName..".", channel)
				elseif Announcer_Config.PrintRaidResurrects == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					PrintMsg(srcName.." is casting "..GetSpellLink(spellID).." on "..dstName..".", channel)
				end
			end

			if tContains(crowdcontrols, spellID) then
				local iconIndex

				if srcGUID == UnitGUID("player") then
					if UnitExists("focus") and UnitCanAttack("player", "focus") then
						dstName = UnitName("focus")
						iconIndex = GetRaidTargetIndex("focus")
					elseif UnitExists("target") and UnitCanAttack("player", "target") then
						dstName = UnitName("target")
						iconIndex = GetRaidTargetIndex("target")
					else
						return false
					end
				elseif NameIsUnit(srcName) and UnitExists(NameIsUnit(srcName).."focus") and UnitCanAttack(NameIsUnit(srcName), NameIsUnit(srcName).."focus") then
					dstName = UnitName(NameIsUnit(srcName).."focus")
					iconIndex = GetRaidTargetIndex(NameIsUnit(srcName).."focus")
				elseif NameIsUnit(srcName) and UnitExists(NameIsUnit(srcName).."target") and UnitCanAttack(NameIsUnit(srcName), NameIsUnit(srcName).."target") then
					dstName = UnitName(NameIsUnit(srcName).."target")
					iconIndex = GetRaidTargetIndex(NameIsUnit(srcName).."target")
				else
					return false
				end

				if not dstName then return false end

				if iconIndex then dstName = "{rt"..iconIndex.."} "..dstName.." {rt"..iconIndex.."}" end

				if Announcer_Config.AnnounceMyCCs == 1 and srcGUID == UnitGUID("player") then
					SendChatMessage("Casting "..GetSpellLink(spellID).." on "..dstName..".", channel)
				elseif Announcer_Config.AnnounceRaidCCs == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					SendChatMessage(srcName.." is casting "..GetSpellLink(spellID).." on "..dstName..".", channel)
				elseif Announcer_Config.PrintRaidCCs == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					PrintMsg(srcName.." is casting "..GetSpellLink(spellID).." on "..dstName..".", channel)
				end
			end
		elseif string.find(event, "_CAST_SUCCESS") then
			local spellID, spellName, spellSchool = select(12, ...)

			if Announcer_Config["AnnounceTaunt"..spellID] == 1 then
				if srcGUID == UnitGUID("player") and Announcer_Config.AnnounceMyTaunts == 1 then
					if bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 then
						SendChatMessage("Taunted off "..dstName.." with my "..GetSpellLink(spellID)..".", channel)
					else
						SendChatMessage("Taunted "..dstName.." with my "..GetSpellLink(spellID)..".", channel)
					end
				elseif Announcer_Config.AnnounceRaidTaunts == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					if bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 then
						SendChatMessage(srcName.." taunted off "..dstName.." with "..GetSpellLink(spellID)..".", channel)
					else
						SendChatMessage(srcName.." taunted "..dstName.." with "..GetSpellLink(spellID)..".", channel)
					end
				elseif Announcer_Config.PrintRaidTaunts == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					if bit.band(dstFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 then
						PrintMsg(srcName.." taunted off "..dstName.." with "..GetSpellLink(spellID)..".")
					else
						PrintMsg(srcName.." taunted "..dstName.." with "..GetSpellLink(spellID)..".")
					end
				end
			end
		elseif string.find(event, "_CAST_FAILED") then
			local spellID, spellName, spellSchool, failedType = select(12, ...)

			--if tContains(taunts, spellID) then
			if Announcer_Config["AnnounceTaunt"..spellID] == 1 then
				if srcGUID == UnitGUID("player") and Announcer_Config.AnnounceMyTaunts == 1 then
					SendChatMessage("My "..GetSpellLink(spellID).." failed on "..dstName..".", channel)
				elseif Announcer_Config.AnnounceRaidTaunts == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					SendChatMessage(srcName.."'s "..GetSpellLink(spellID).." failed on "..dstName..". ("..failedType..")", channel)
				elseif Announcer_Config.PrintRaidTaunts == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and ( srcGUID ~= UnitGUID("player") or Announcer_Config.AnnounceMyTaunts == 0 ) then
					PrintMsg(srcName.."'s "..GetSpellLink(spellID).." failed on "..dstName..". ("..failedType..")")
				end
			end

			if tContains(crowdcontrols, spellID) and failedType == "IMMUNE" then
				if Announcer_Config.AnnounceMyCCs == 1 and srcGUID == UnitGUID("player") then
					SendChatMessage("My "..GetSpellLink(spellID).." failed. ("..failedType..")", channel)
				elseif Announcer_Config.AnnounceRaidCCs == 1 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 and srcGUID ~= UnitGUID("player") then
					SendChatMessage(srcName.."'s "..GetSpellLink(spellID).." failed. ("..failedType..")", channel)
				elseif Announcer_Config.PrintRaidCCs == 1 and bit.band(srcFlags, COMBATLOG_OBJEcT_AFFILIATION_RAID) > 0 and ( srcGUID ~= UnitGUID("player") or Announcer_Config.AnnounceMyCCs == 0 ) then
					PrintMsg(srcName.."'s "..GetSpellLink(spellID).." failed. ("..failedType..")")
				end
			end
		end
	end
end

f:SetScript("OnEvent", OnEvent)
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_LOOT")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local function SlashCmd(...)
	if ... == "off" then
		f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		PrintMsg("off")
	elseif ... == "on" then
		f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		PrintMsg("on")
	else
		AnnouncerConfig:OpenConfig()
	end
end

SLASH_ANNOUNCER1 = "/announcer"
SLASH_ANNOUNCER2 = "/ann"
--SlashCmdList["ANNOUNCER"] = SlashCmd
SlashCmdList["ANNOUNCER"] = function() AnnouncerConfig:OpenConfig() end
