for i = 1, NUM_GROUP_LOOT_FRAMES, 1 do
	local frame = _G["GroupLootFrame"..i]

	frame:ClearAllPoints()
	frame:SetParent(UIParent)
	frame:SetFrameLevel(0)
	frame:SetScale(0.8)
--	frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 30, 170+(((frame:GetHeight()*i)-frame:GetHeight())+30))

	if i <= 2 then
		frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", ((UIParent:GetWidth()/2)+frame:GetWidth()-20)+(((frame:GetWidth()*i)-frame:GetWidth())+30), ((UIParent:GetHeight()/2)-frame:GetHeight()-40))
	else
		frame:SetPoint("BOTTOMLEFT", _G["GroupLootFrame"..(i-2)], "TOPLEFT", 0, 30)
	end
end

local f = CreateFrame("Frame", nil, UIParent)

local function OnEvent(self, event, ...)
	local arg1, arg2 = ...
	local _, name, _, quality, bindOnPickUp = GetLootRollItemInfo(arg1)

	if event == "START_LOOT_ROLL" then
		if select(2, (name):match("(%a+) (%a+)")) == "Orb" then
			RollOnLoot(arg1, 2)
		end

		if select(2, (name):match("(%a+) of (%a+)")) == "Coins" then
			RollOnLoot(arg1, 1)
		end

		if quality <= 2 then
			--RollOnLoot(arg1, 3)
			RollOnLoot(arg1, 2)
		end
	elseif event == "CONFIRM_LOOT_ROLL" then
		if select(2, (name):match("(%a+) (%a+)")) == "Orb" then
			ConfirmLootRoll(arg1, arg2)
		end

		if select(2, (name):match("(%a+) of (%a+)")) == "Coins" then
			ConfirmLootRoll(arg1, arg2)
		end

		if quality <= 2 then
			ConfirmLootRoll(arg1, arg2)
		end
	elseif event == "CONFIRM_DISENCHANT_ROLL" then
		if quality <= 2 then
			ConfirmLootRoll(arg1, arg2)
		end
	end
end

f:RegisterEvent("START_LOOT_ROLL")
f:RegisterEvent("CONFIRM_LOOT_ROLL")
f:RegisterEvent("CONFIRM_DISENCHANT_ROLL")

f:SetScript("OnEvent", OnEvent)
