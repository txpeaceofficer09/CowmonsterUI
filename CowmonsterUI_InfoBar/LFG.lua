local function convertMilliseconds(milliseconds)
	local hours = math.floor(milliseconds / 3600000)
	local minutes = math.floor((milliseconds - hours * 3600000) / 60000)
	local seconds = math.floor((milliseconds - hours * 3600000 - minutes * 60000) / 1000)
	return hours, minutes, seconds
end

function InfoBarLFG_OnEnter(self)
	if UnitAffectingCombat("player") then return end

	InfoBarTooltip:ClearLines()
	InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	InfoBarTooltip:AddLine("Looking For Group:")
	InfoBarTooltip:AddLine(" ")

	for i=1, GetNumGroupMembers(), 1 do
		local name = GetUnitName("party"..i)
		local role = GetLFGRole(i)
		local hours, minutes, seconds = convertMilliseconds(GetBattlefieldWaited(i))
		local color = GetClassColor("party"..i)

		if role == "TANK" then
			InfoBarTooltip:AddDoubleLine("[T] "..name, ("%s:%s:%s"):format(hours, minutes, seconds), color.r, color.g, color.b, color.a)
		elseif role == "HEALER" then
			InfoBarTooltip:AddDoubleLine("[H] "..name, ("%s:%s:%s"):format(hours, minutes, seconds), color.r, color.g, color.b, color.a)
		else
			InfoBarTooltip:AddDoubleLine("[D] "..name, ("%s:%s:%s"):format(hours, minutes, seconds), color.r, color.g, color.b, color.a)
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
	local status = GetLFGQueueStatus("")

	if status == "NONE" then
		InfoBarSetText("InfoBarLFG", "LFG: %s", "No Queue")
	elseif status == "IN_QUEUE" then
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
	elseif status == "PENDING_INVITE" then
		InfoBarSetText("InfoBarLFG", "LFG: %s", "Pending")
	elseif status == "IN_PROGRESS" then
		InfoBarSetText("InfoBarLFG", "LFG: %s", "In Progress")
	elseif status == "FINISHED" then
		InfoBarSetText("InfoBarLFG", "LFG: %s", "Finished")
	else
		InfoBarSetText("IntoBarLFG", "LFG: %s", "???")
	end
end

function InfoBarLFG_OnEvent(self, event, ...)
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