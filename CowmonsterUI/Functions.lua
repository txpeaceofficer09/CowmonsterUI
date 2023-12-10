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
