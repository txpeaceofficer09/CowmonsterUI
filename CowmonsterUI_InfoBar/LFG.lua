local function convertMilliseconds(milliseconds)
	local hours = math.floor(milliseconds / 3600000)
	local minutes = math.floor((milliseconds - hours * 3600000) / 60000)
	local seconds = math.floor((milliseconds - hours * 3600000 - minutes * 60000) / 1000)
	return hours, minutes, seconds
end

function InfoBarLFG_OnEnter(self)
	if UnitAffectingCombat("player") or (self.inQueue or false) ~= true then return end

	InfoBarTooltip:ClearLines()
	InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	InfoBarTooltip:AddLine("Looking For Group:")
	InfoBarTooltip:AddLine(" ")
	InfoBarTooltip:AddDoubleLine("Dungeon", self.instanceName)
	InfoBarTooltip:AddDoubleLine("Type", self.instanceType)
	InfoBarTooltip:AddDoubleLine("Sub-Type", self.instanceSubType)

	for i=1, SearchLFGGetNumResults(), 1 do
		for k=1, select(6, SearchLFGGetResults(i)), 1 do
			local name, level, relationship, className, areaName, comment, isLeader, isTank, isHealer, isDamage, bossKills, specID, isGroupLeader, armor, spellDamage, plusHealing, CritMelee, CritRanged, critSpell, mp5, mp5Combat, attackPower, agility, maxHealth, maxMana, gearRating, avgILevel, defenseRating, dodgeRating, BlockRating, ParryRating, HasteRating, expertise = SearchLFGGetPartyResults(i, k)
			local role

			if isLeader then role = role.."L" end
			if isTank then role = role.."T" end
			if isHealer then role = role.."H" end
			if isDamage then role = role.."D" end

			local color = GetClassColor(className)
			local hours, minutes, seconds = convertMilliseconds(GetBattlefieldWaited(i))

			--("%s:%s:%s"):format(hours, minutes, seconds)

			InfoBarTooltip:AddDoubleLine("["..role.."] "..name.." ("..level..")", avgILevel, color.r, color.g, color.b)
		end
	end

	InfoBarTooltip:Show()
end

function InfoBarLFG_OnLeave(self)
	InfoBarTooltip:Hide()
	InfoBarTooltip:ClearLines()
end

--[[
function InfoBarLFG_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		local timeLeft = GetLFGTimeLeft()
		local minutes = math.floor(timeLeft / 60)
		local seconds = timeLeft % 60

		InfoBarSetText("InfoBarLFG", "LFG: [%s:%s]", minutes, seconds)

		self.timer = 0
	end
end
]]

function InfoBarLFG_UpdateText()
	if (InfoBarLFG.inQueue or false) == true then
		local tanks = 0
		local healers = 0
		local dps = 0

		for i=1, GetNumGroupMembers(), 1 do
			local role = GetLFGRole(i)

			if role == "TANK" then
				tanks = tanks + 1
			elseif role == "HEALER" then
				healers = healers + 1
			else
				dps = dps + 1
			end
		end

		InfoBarSetText("InfoBarLFG", "LFG: T %s/%s H %s/%s D %s/%s", tanks, InfoBarLFG.totalTanks, healers, InfoBarLFG.totalHealers, dps, InfoBarLFG.totalDPS)
	else
		InfoBarSetText("InfoBarLFG", "LFG: %s", "No Queue")
	end
end

function InfoBarLFG_OnEvent(self, event, ...)
	if GetLFGQueueStats(LE_LFG_CATEGORY_LFD) then
		self.inQueue, _, _, _, _, _, self.totalTanks, self.totalHealers, self.totalDPS, self.instanceType, self.instanceSubType, self.instanceName, _, _, _, _, _, self.queueTime, self.lfgID = GetLFGQueueStats(LE_LFG_CATEGORY_LFD)
	elseif GetLFGQueueStats(LE_LFG_CATEGORY_RF) then
		self.inQueue, _, _, _, _, _, self.totalTanks, self.totalHealers, self.totalDPS, self.instanceType, self.instanceSubType, self.instanceName, _, _, _, _, _, self.queueTime, self.lfgID = GetLFGQueueStats(LE_LFG_CATEGORY_RF)
	elseif GetLFGQueueStats(LE_LFG_CATEGORY_SCENARIO) then
		self.inQueue, _, _, _, _, _, self.totalTanks, self.totalHealers, self.totalDPS, self.instanceType, self.instanceSubType, self.instanceName, _, _, _, _, _, self.queueTime, self.lfgID = GetLFGQueueStats(LE_LFG_CATEGORY_SCENARIO)
	elseif GetLFGQueueStats(LE_LFG_CATEGORY_LFR) then
		self.inQueue, _, _, _, _, _, self.totalTanks, self.totalHealers, self.totalDPS, self.instanceType, self.instanceSubType, self.instanceName, _, _, _, _, _, self.queueTime, self.lfgID = GetLFGQueueStats(LE_LFG_CATEGORY_LFR)
	else
		self.inQueue = false
	end

	InfoBarLFG_UpdateText()
--[[
	if event == "PLAYER_ENTERING_WORLD" then

	elseif event == "LFG_QUEUE_JOINED" or event == "LFG_UPDATE_GROUP_MEMBERS" then
		local tanks = 0
		local healers = 0
		local dps = 0

		for i=1, GetNumGroupMembers(), 1 do
			local role = GetLFGRole(i)

			if role == "TANK" then
				tanks = tanks + 1
			elseif role == "HEALER" then
				healers = healers + 1
			else
				dps = dps + 1
			end
		end

		InfoBarSetText("InfoBarLFG", "LFG: T %s/1 H %s/1 D %s/3", tanks, healers, dps)
	elseif event == "LFG_QUEUE_LEFT" then
		InfoBarSetText("InfoBarLFG", "LFG: %s", "No Queue")
	end
]]
end