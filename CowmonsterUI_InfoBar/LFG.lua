-- Add left click and right click so the left click can toggle the GUI and right click can do the context menu with the leave queue and teleport options so the Minimap button can be hidden.

function convertMilliseconds(milliseconds)
	--[[
	local hours = math.floor(milliseconds / 3600000)
	local minutes = math.floor((milliseconds - hours * 3600000) / 60000)
	local seconds = math.floor((milliseconds - hours * 3600000 - minutes * 60000) / 1000)
	return hours, minutes, seconds
	]]
end

function InfoBarLFG_OnEnter(self)
	if UnitAffectingCombat("player") or (self.inQueue or false) ~= true then return end

	InfoBarTooltip:ClearLines()
	InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	InfoBarTooltip:AddLine("Looking For Group:")
	InfoBarTooltip:AddLine(" ")
--[[
	InfoBarTooltip:AddDoubleLine("Dungeon", self.instanceName)
	InfoBarTooltip:AddDoubleLine("Type", self.instanceType)
	InfoBarTooltip:AddDoubleLine("Sub-Type", self.instanceSubType)
]]



--[[
	for i=1, SearchLFGGetNumResults(), 1 do
		for k=1, select(6, SearchLFGGetResults(i)), 1 do
			local name, level, relationship, className, areaName, comment, isLeader, isTank, isHealer, isDamage, bossKills, specID, isGroupLeader, armor, spellDamage, plusHealing, CritMelee, CritRanged, critSpell, mp5, mp5Combat, attackPower, agility, maxHealth, maxMana, gearRating, avgILevel, defenseRating, dodgeRating, BlockRating, ParryRating, HasteRating, expertise = SearchLFGGetPartyResults(i, k)
			local role

			if isLeader then role = role.."L" end
			if isTank then role = role.."T" end
			if isHealer then role = role.."H" end
			if isDamage then role = role.."D" end

			local color = GetClassColor(className)
			local hours, minutes, seconds = CowmonsterUI.ConvertMilliseconds(GetBattlefieldWaited(i))

			--("%s:%s:%s"):format(hours, minutes, seconds)

			InfoBarTooltip:AddDoubleLine("["..role.."] "..name.." ("..level..")", avgILevel, color.r, color.g, color.b)
		end
	end
]]
	InfoBarTooltip:Show()
end

function InfoBarLFG_OnLeave(self)
	InfoBarTooltip:Hide()
	InfoBarTooltip:ClearLines()
end

function InfoBarLFG_OnClick(self, button)
	if PVEFrame:IsShown() then
		HideUIPanel(PVEFrame)
	else
		ShowUIPanel(PVEFrame)
	end
end

function InfoBarLFG_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		--local timeLeft = GetLFGTimeLeft()
		--local minutes = math.floor(timeLeft / 60)
		--local seconds = timeLeft % 60
		--[[
		local inQueue, leaderNeeds, tankNeeds, healerNeeds, dpsNeeds, totalTanks, totalHealers, totalDPS, instanceType, instanceSubType, instanceName, averageWait, tankWait, healerWait, dpsWait, myWait, queuedTime, activeID = GetLFGQueueStats(LE_LFG_CATEGORY_LFD)

		if inQueue then
			local waitTime = GetTime() - queuedTime
			local minutes = math.floor(waitTime / 60)
			local seconds = waitTime % 60

			InfoBarSetText("InfoBarLFG", "LFG: [%s:%s] T %s/%s H %s/%s D %s/%s", minutes, seconds, totalTanks - tankNeeds, totalTanks, totalHealers - healerNeeds, totalHealers, totalDPS - dpsNeeds, totalDPS)
		else
			InfoBarSetText("InfoBarLFG", "LFG: %s", "No Queue")
		end
		]]
		InfoBarLFG_UpdateText()
		self.timer = 0
	end
end

function InfoBarLFG_UpdateText()
		--local timeLeft = GetLFGTimeLeft()
		--local minutes = math.floor(timeLeft / 60)
		--local seconds = timeLeft % 60
		local inQueue, leaderNeeds, tankNeeds, healerNeeds, dpsNeeds, totalTanks, totalHealers, totalDPS, instanceType, instanceSubType, instanceName, averageWait, tankWait, healerWait, dpsWait, myWait, queuedTime, activeID = GetLFGQueueStats(LE_LFG_CATEGORY_LFD)

		if inQueue then
			local waitTime = GetTime() - queuedTime
			local hours = math.floor(waitTime / 3600)
			local minutes = math.floor((waitTime - (hours * 3600)) / 60)
			local seconds = math.floor(waitTime % 60)

			if hours < 10 then hours = ("0%s"):format(hours) end
			if minutes < 10 then minutes = ("0%s"):format(minutes) end
			if seconds < 10 then seconds = ("0%s"):format(seconds) end

			InfoBarSetText("InfoBarLFG", "LFG: [%s:%s:%s] T %s/%s H %s/%s D %s/%s", hours, minutes, seconds, totalTanks - tankNeeds, totalTanks, totalHealers - healerNeeds, totalHealers, totalDPS - dpsNeeds, totalDPS)
		else
			InfoBarSetText("InfoBarLFG", "LFG: %s", "No Queue")
		end
end

--[[
function InfoBarLFG_UpdateText()
	local inQueue, leaderNeeds, tankNeeds, healerNeeds, dpsNeeds, totalTanks, totalHealers, totalDPS, instanceType, instanceSubType, instanceName, averageWait, tankWait, healerWait, dpsWait, myWait, queuedTime, activeID = GetLFGQueueStats(LE_LFG_CATEGORY_LFD)



	if inQueue then
		InfoBarSetText("LFG: T %s/%s H %s/%s D %s/%s", totalTanks - tankNeeds, totalTanks, totalHealers - healerNeeds, totalHealers, totalDPS - dpsNeeds, totalDPS)
	else
		InfoBarSetText("InfoBarLFG", "LFG: %s", "No Queue")
	end
end

hooksecurefunc("QueueStatusEntry_SetUpLFG", InfoBarLFG_UpdateText)
QueueStatusMinimapButton:HookScript("OnShow", InfoBarLFG_UpdateText)
]]
function InfoBarLFG_OnEvent(self, event, ...)	
	InfoBarLFG_UpdateText()
end

local function HideMinimapButton()
	QueueStatusMinimapButton:Hide()
end

--QueueStatusMinimapButton:HookScript("OnShow", HideMinimapButton)
