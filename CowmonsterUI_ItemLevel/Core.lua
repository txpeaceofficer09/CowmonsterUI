local f = CreateFrame("Frame", "CowmonsterUIiLvlFrame", UIParent)

local slots = {
    "CharacterHeadSlot",
    "CharacterNeckSlot",
    "CharacterShoulderSlot",
    "CharacterBackSlot",
    "CharacterChestSlot",
    "CharacterShirtSlot",
    "CharacterTabardSlot",
    "CharacterWristSlot",
    "CharacterMainHandSlot",
    "CharacterSecondaryHandSlot",
    "CharacterTrinket0Slot",
    "CharacterTrinket1Slot",
    "CharacterFinger0Slot",
    "CharacterFinger1Slot",
    "CharacterFeetSlot",
    "CharacterLegsSlot",
    "CharacterWaistSlot",
    "CharacterHandsSlot",
}

local invSlots = {
    [1] = "Head",
    [2] = "Neck",
    [3] = "Shoulder",
    [4] = "Tabard",
    [5] = "Chest",
    [6] = "Waist",
    [7] = "Legs",
    [8] = "Feet",
    [9] = "Wrist",
    [10] = "Hands",
    [11] = "Finger0",
    [12] = "Finger1",
    [13] = "Trinket0",
    [14] = "Trinket1",
    [15] = "Back",
    [16] = "MainHand",
    [17] = "SecondaryHand",
}

local leftStrings = {10,6,7,8,11,12,13,14}
local rightStrings = {1,2,3,15,5,9}
local topStrings = {16,17}

local function inArray(tbl, str)
    for k,v in pairs(tbl) do
        if v == str then
            return true
        end
    end

    return false
end

local function UpdateBorderColor()
    for i=1,17,1 do
        local link = GetInventoryItemLink("player", i)
        local name, _, quality, itemLevel = GetItemInfo(link or 0)
        local r, g, b, color = GetItemQualityColor(quality or 1)
        local slot = _G[("Character%sSlot"):format(invSlots[i])]

        if not slot.glowBorder then
            slot.glowBorder = slot:CreateTexture(nil, "OVERLAY")
            slot.glowBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
            slot.glowBorder:SetBlendMode("ADD")
            slot.glowBorder:SetAlpha(0.8)
            slot.glowBorder:SetSize(70, 70)
            slot.glowBorder:SetPoint("CENTER", slot, "CENTER", 0, 0)
        end

        if not slot.simpleilvl then
            slot.simpleilvl = slot:CreateFontString(invSlots[i].."ItemLevel", "ARTWORK", "GameFontHighlightLarge")
            slot.simpleilvl:SetShadowColor(0, 0, 0, 1)
            slot.simpleilvl:SetShadowOffset(-1, -1)
            
            --slot.simpleilvl:SetFrameStrata(CharacterHeadSlot:GetFrameStrata())

            --slot.simpleilvl:SetAllPoints(slot)
            if inArray(leftStrings, i) then
                slot.simpleilvl:SetPoint("RIGHT", slot, "LEFT", -5, 0)
            elseif inArray(rightStrings, i) then
                slot.simpleilvl:SetPoint("LEFT", slot, "RIGHT", 5, 0)
            elseif inArray(topStrings, i) then
                slot.simpleilvl:SetPoint("BOTTOM", slot, "TOP", 0, 5)
            end

            slot.simpleilvl:SetJustifyH("CENTER")
            slot.simpleilvl:SetJustifyV("CENTER")
        end

        if itemLevel ~= nil then
            slot.glowBorder:SetVertexColor(r, g, b)
            slot.glowBorder:Show()
            --slot:SetBackdropBorderColor(r, g, b, 1)
            slot.simpleilvl:SetText(("|c%s%s"):format(color, itemLevel))
            --slot.simpleilvl:SetText(("|c%s%s"):format("ffffffff", itemLevel))
            slot.simpleilvl:Show()
        else
            slot.simpleilvl:Hide()
            slot.glowBorder:Hide()
        end
    end
end

UpdateBorderColor()

f:RegisterEvent("INSPECT_READY")

f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_READY")
f:RegisterEvent("RAID_ROSTER_UPDATE")
f:RegisterEvent("PARTY_MEMBERS_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

f:SetScript("OnEvent", OnEvent)

local function OnEvent(self, event, ...)
    UpdateBorderColor()
end