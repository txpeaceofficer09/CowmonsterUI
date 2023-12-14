function CowmonsterUI.isInCombat()
	if CowmonsterUI.inCombat or 0 == 1 or UnitAffectingCombat("player") then
		return true
	else
		return false
	end
end

function CowmonsterUI.ConvertMilliseconds(milliseconds)
	local seconds = math.floor(milliseconds / 1000)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor(seconds % 3600 / 60)
	seconds = math.floor(seconds - (hours * 3600) - (minutes * 60))

	if hours < 10 then hours = ("0%s"):format(hours) end
	if minutes < 10 then minutes = ("0%s"):format(minutes) end
	if seconds < 10 then seconds = ("0%s"):format(seconds) end

	return hours, minutes, seconds

        --[[
        local hours = math.floor(milliseconds / 3600000)
        local minutes = math.floor((milliseconds - hours * 3600000) / 60000)
        local seconds = math.floor((milliseconds - hours * 3600000 - minutes * 60000) / 1000)
        return hours, minutes, seconds
        ]]
end

function CowmonsterUI.AddComma(num)
        local retVal = num
        local i

        while true do
                retVal, i = string.gsub(retVal, "^(-?%d+)(%d%d%d)", '%1,%2')

                if i == 0 then break end
        end

        return retVal
end

function CowmonsterUI.ShortNumber(number)
	if number >= 1000000000 then
		return ("%.2fB"):format(number/1000000000)
	elseif number >= 1000000 then
		return ("%.2fM"):format(number/1000000)
	elseif number >= 1000 then
		return ("%.2fK"):format(number/1000)
	else
		return number
	end
end

function CowmonsterUI.DecimalToHexColor(r, g, b, a)
	return ("|c%02x%02x%02x%02x"):format(a*255, r*255, g*255, b*255)
end

function CowmonsterUI.TableSum(table)
	local retVal = 0

	for _, n in ipairs(table) do
		retVal = retVal + n
	end

	return retVal
end

function CowmonsterUI.unitIndex(name)
	for k,v in pairs(groupxpTbl) do
		if v["name"] == name then
			return k
		end
	end
	return false
end

function CowmonsterUI.IsInParty(name)
	if strfind((name or "???"), (UnitName("player") or "Unknown"), 1) then
		return true
	end

	if IsInRaid() then
		for i=1,GetNumGroupMembers(),1 do
			if strfind((name or "???"), (UnitName("raid"..i) or "Unknown"), 1) then
				return "raid"..i
			end
		end
	elseif GetNumGroupMembers() > 0 then
		for i=1,GetNumGroupMembers(),1 do
			if strfind((name or "???"), (UnitName("party"..i) or "Unknown"), 1) then
				return "party"..i
			end
		end
	end

	return false
end

function CowmonsterUI.UnitFromName(name)
	if strfind(name, UnitName("player"), 1) then
		return true
	end

	if IsInRaid() then
		for i=1,GetNumGroupMembers(),1 do
			if strfind(name, (UnitName("raid"..i) or "Unknown"), 1) then
				return "raid"..i
			end
		end
	elseif GetNumGroupMembers() > 0 then
		for i=1,GetNumGroupMembers(),1 do
			if strfind(name, (UnitName("party"..i) or "Unknown"), 1) then
				return "party"..i
			end
		end
	end

	return false
end

function CowmonsterUI.IsInGuild(name)
	for i=1,GetNumGuildMembers(),1 do
		if strfind(name, GetGuildRosterInfo(i), 1) or name == select(1, GetGuildRosterInfo(i)) then
			return i
		end
	end

	return -1
end

function CowmonsterUI.GetGuildRosterInfoByName(charName)
	for i=1,GetNumGuildMembers(),1 do
		local name, rank, rankIndex, level, _, _, _, _, _, _, class = GetGuildRosterInfo(i)
		if strfind(charName, name, 1) or charName == name then
			return name, rank, rankIndex, level, class
		end
	end
end
