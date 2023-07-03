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

local function UpdateInspectionItemLevel()
    local unit = InspectFrame.Unit
    --if unit == nil or unit == false then return false end
    if unit == nil or unit == false then unit = "target" end

    for i=1,17,1 do
        local link = GetInventoryItemLink(unit, i)
        local name, _, quality, itemLevel = GetItemInfo(link or 0)
        local r, g, b, color = GetItemQualityColor(quality or 1)
        local slot = _G[("Inspect%sSlot"):format(invSlots[i])]

        if not slot.glowBorder then
            slot.glowBorder = slot:CreateTexture(nil, "OVERLAY")
            slot.glowBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
            slot.glowBorder:SetBlendMode("ADD")
            slot.glowBorder:SetAlpha(0.8)
            slot.glowBorder:SetSize(70, 70)
            slot.glowBorder:SetPoint("CENTER", slot, "CENTER", 0, 0)
        end

        if not slot.ilvl then
            slot.ilvl = slot:CreateFontString(invSlots[i].."ItemLevel", "ARTWORK", "GameFontHighlightLarge")
            slot.ilvl:SetShadowColor(0, 0, 0, 1)
            slot.ilvl:SetShadowOffset(-1, -1)
            
            if inArray(leftStrings, i) then
                slot.ilvl:SetPoint("RIGHT", slot, "LEFT", -5, 0)
                slot.ilvl:SetJustifyH("RIGHT")
            elseif inArray(rightStrings, i) then
                slot.ilvl:SetPoint("LEFT", slot, "RIGHT", 5, 0)
                slot.ilvl:SetJustifyH("LEFT")
            elseif inArray(topStrings, i) then
                slot.ilvl:SetPoint("BOTTOM", slot, "TOP", 0, 5)
                slot.ilvl:SetJustifyH("CENTER")
            end

            slot.ilvl:SetJustifyV("CENTER")
        end

        if itemLevel ~= nil then
            slot.glowBorder:SetVertexColor(r, g, b)
            slot.glowBorder:Show()
            --slot:SetBackdropBorderColor(r, g, b, 1)
            slot.ilvl:SetText(("|c%s%s"):format(color, itemLevel))
            --slot.ilvl:SetText(("|c%s%s"):format("ffffffff", itemLevel))
            slot.ilvl:Show()
        else
            slot.ilvl:Hide()
            slot.glowBorder:Hide()
        end
    end
end

local function UpdatePlayerItemLevel()
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

        if not slot.ilvl then
            slot.ilvl = slot:CreateFontString(invSlots[i].."ItemLevel", "ARTWORK", "GameFontHighlightLarge")
            slot.ilvl:SetShadowColor(0, 0, 0, 1)
            slot.ilvl:SetShadowOffset(-1, -1)
            
            --slot.ilvl:SetFrameStrata(CharacterHeadSlot:GetFrameStrata())

            --slot.ilvl:SetAllPoints(slot)
            if inArray(leftStrings, i) then
                slot.ilvl:SetPoint("RIGHT", slot, "LEFT", -5, 0)
            elseif inArray(rightStrings, i) then
                slot.ilvl:SetPoint("LEFT", slot, "RIGHT", 5, 0)
            elseif inArray(topStrings, i) then
                slot.ilvl:SetPoint("BOTTOM", slot, "TOP", 0, 5)
            end

            slot.ilvl:SetJustifyH("CENTER")
            slot.ilvl:SetJustifyV("CENTER")
        end

        if itemLevel ~= nil then
            slot.glowBorder:SetVertexColor(r, g, b)
            slot.glowBorder:Show()
            --slot:SetBackdropBorderColor(r, g, b, 1)
            slot.ilvl:SetText(("|c%s%s"):format(color, itemLevel))
            --slot.ilvl:SetText(("|c%s%s"):format("ffffffff", itemLevel))
            slot.ilvl:Show()
        else
            slot.ilvl:Hide()
            slot.glowBorder:Hide()
        end
    end
end

--UpdatePlayerItemLevel()

f:RegisterEvent("INSPECT_READY")

f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_READY")
--f:RegisterEvent("RAID_ROSTER_UPDATE")
--f:RegisterEvent("PARTY_MEMBERS_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

local function GetUnitByGUID(guid)
    local units = {"player", "target", "focus", "targettarget", "focustarget"}

    for k,v in pairs(units) do
        if UnitGUID(v) == guid then return v end
    end

    if GetNumGroupMembers() > 0 then
        for i=1,GetNumGroupMembers(),1 do
            if UnitExists("raid"..i) and UnitGUID("raid"..i) == guid then
                return "raid"..i
            elseif UnitExists("party"..i) and UnitGUID("party"..i) == guid then
                return "party"..i
            end
        end
    end
    return false
end

local function OnEvent(self, event, ...)
    if event == "INSPECT_READY" then
        local guid = ...
        local unit = GetUnitByGUID(guid)
        if unit ~= false then
            InspectFrame.Unit = GetUnitByGUID(guid)
        end
        UpdateInspectionItemLevel()
    end
    UpdatePlayerItemLevel()
end

LoadAddOn("Blizzard_InspectUI")
InspectFrame:HookScript("OnShow", function(self)
    UpdateInspectionItemLevel()
end)

CharacterFrame:HookScript("OnShow", function(self)
    UpdatePlayerItemLevel()
end)

f:SetScript("OnEvent", OnEvent)
