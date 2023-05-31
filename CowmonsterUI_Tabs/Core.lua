INFOBAR_OFFSETY = 0 --22

local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")

function GameTooltip_SetDefaultAnchor(tooltip, parent)       
    tooltip:SetOwner(parent, "ANCHOR_NONE")
--    tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -78, 160)
    tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 195)
    tooltip.default = 1
end

function ShortNumber(number)
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

function DecimalToHexColor(r, g, b, a)
	return ("|c%02x%02x%02x%02x"):format(a*255, r*255, g*255, b*255)
end

function TableSum(table)
	local retVal = 0

	for _, n in ipairs(table) do
		retVal = retVal + n
	end

	return retVal
end
