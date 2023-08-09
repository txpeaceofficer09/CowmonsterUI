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
	local pass = 0
	local need = 1
	local greed = 2
	local disenchant = 3

	local poor = 0		-- grey
	local common = 1	-- white
	local uncommon = 2	-- green
	local rare = 3		-- blue
	local epic = 4		-- purple
	local legendary = 5	-- orange
	local artifact = 6	-- beige

	if event == "START_LOOT_ROLL" then
		local lootTableID, lootSlot, rollType, winner = ...
		local _, name, _, quality, bindOnPickUp = GetLootRollItemInfo(lootTableID)
		local itemID = GetLootSlotInfo(lootSlot)
		local isDisenchantable = CanDisenchantItem(itemID)
		
		if select(2, (name):match("(%a+) (%a+)")) == "Orb" then
			RollOnLoot(lootTableID, greed)
		elseif select(2, (name):match("(%a+) of (%a+)")) == "Coins" then
			RollOnLoot(lootTableID, need)
		elseif quality <= uncommon then
			if isDisenchantable then
				RollOnLoot(lootTableID, disenchant) -- Roll disenchant
			else
				RollOnLoot(lootTableID, greed) -- Roll greed
			end
		end
	elseif event == "CONFIRM_LOOT_ROLL" then
		local rollID, rollType, confirmReason = ...
		local _, name, _, quality, bindOnPickUp = GetLootRollItemInfo(rollID)
	
		if select(2, (name):match("(%a+) (%a+)")) == "Orb" then
			ConfirmLootRoll(rollID, rollType)
		end

		if select(2, (name):match("(%a+) of (%a+)")) == "Coins" then
			ConfirmLootRoll(rollID, rollType)
		end

		if quality <= uncommon then
			ConfirmLootRoll(rollID, rollType)
		end
	elseif event == "CONFIRM_DISENCHANT_ROLL" then
		local rollID, rollType, confirmReason = ...
		local _, name, _, quality, bindOnPickUp = GetLootRollItemInfo(rollID)
		
		if quality <= uncommon then
			ConfirmLootRoll(rollID, rollType)
		end
	end
end

f:RegisterEvent("START_LOOT_ROLL")
f:RegisterEvent("CONFIRM_LOOT_ROLL")
f:RegisterEvent("CONFIRM_DISENCHANT_ROLL")

f:SetScript("OnEvent", OnEvent)
