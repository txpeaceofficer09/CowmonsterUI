local f = CreateFrame("Frame", "EnemyFrames", UIParent)
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
f:Show()
f:SetSize(120, 400)
local guids = {}

function UnitTokenFromGUID(guid)
  local i = 1

  if UnitGUID("player") == guid then return "player" end
  if UnitGUID("target") == guid then return "target" end
  if UnitGUID("focus") == guid then return "focus" end
  if UnitGUID("pet") == guid then return "pet" end

  while UnitGUID("nameplate"..i) ~= nil do
    if UnitGUID("nameplate"..i) == guid then
      return "nameplate"..i
    end
    i = i + 1
  end

  for i=1, GetNumGroupMembers(), 1 do
    if IsInRaid() then
      if UnitGUID("raid"..i) == guid then
        return "raid"..i
      elseif UnitGUID("raidpet"..i) == guid then
        return "raidpet"..i
      elseif UnitGUID("raid"..i.."target") == guid then
        return "raid"..i.."target"
      elseif UnitGUID("raidpet"..i.."target") == guid then
        return "raidpet"..i.."target"
      end
    else
      if UnitGUID("party"..i) == guid then
        return "party"..i
      elseif UnitGUID("partypet"..i) == guid then
        return "partypet"..i
      elseif UnitGUID("party"..i.."target") == guid then
        return "party"..i.."target"
      elseif UnitGUID("partypet"..i.."target") == guid then
        return "partypet"..i.."target"
      end
    end
  end

  return nil
end

function f.AddGUID(guid)
  if not EnemyFrames.ExistsGUID(guid) then
    table.insert(guids, guid)
  end
end

function f.RemoveGUID(guid)
  for i, v in ipairs(guids) do
    if v == guid then
      table.remove(guids, i)
      break
    end
  end
end

function f.ExistsGUID(guid)
  for i, v in ipairs(guids) do
    if v == guid then
      return true
    end
  end

  return false
end

local function CreateUnitFrame(index, unitGUID)
  if UnitTokenFromGUID(unitGUID) == nil then return end

  if not _G["Enemy"..index] then
    local frame = CreateFrame("Frame", "Enemy"..index, UIParent)

    if index == 1 then
      frame:SetPoint("TOPLEFT", EnemyFrames, "TOPLEFT", 0, 0)
    else
      frame:SetPoint("TOPLEFT", _G["Enemy"..(index-1)], "BOTTOMLEFT", 0, 0)
    end

    frame.Name = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    frame.Name:SetPoint("TOPLEFT", 10, -10)

    frame.Health = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    frame.Health:SetPoint("TOPRIGHT", -10, -10)

    frame.Power = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    frame.Power:SetPoint("BOTTOMRIGHT", -10, 10)

    frame:SetScript("OnShow", function(self)
      local unit = self.unit
      local name, realm = UnitName(unit)
      local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
      local power, maxPower = UnitPower(unit), UnitPowerMax(unit)

      self.Name:SetText(name)
      self.Health:SetText(health .. "/" .. maxHealth)
      self.Power:SetText(power .. "/" .. maxPower)
    end)

    frame:SetScript("OnUpdate", function(self, elapsed)
      self.timer = (self.timer or 0) + elapsed

      if self.timer >= 0.2 then
        local unit = self.unit
        local name, realm = UnitName(unit)
        local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
        local power, maxPower = UnitPower(unit), UnitPowerMax(unit)

        self.Name:SetText(name)
        self.Health:SetText(health .. "/" .. maxHealth)
        self.Power:SetText(power .. "/" .. maxPower)

        self.timer = 0
      end
    end)
  else
    local frame = _G["Enemy"..index]
  end

  if frame then
    frame:SetFrameType("unit")
    frame:SetUnit(UnitTokenFromGUID(unitGUID))
    frame.unit = UnitTokenFromGUID(unitGUID)

    frame:Show()
  end
end 

function f.OnEvent(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    EnemyFrames:Show()
    for i=1,25,1 do
      CreateUnitFrame(i, nil)
    end
  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
    local timestamp, event, hideCaster, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _ = ...

    --[[
    if srcFlags == COMBAT_LOG_OBJECT_REACTION_HOSTILE and srcFlags == COMBAT_LOG_OBJECT_TYPE_PLAYER then
      ChatFrame1:AddMessage(srcName.." enemy player detected.")
    end

    if dstFlags == COMBAT_LOG_OBJECT_REACTION_HOSTILE and dstFlags == COMBAT_LOG_OBJECT_TYPE_PLAYER then
      ChatFrame1:AddMessage(srcName.." enemy player detected.")        
    end
    ]]

    if bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_NPC) > 0 and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
      if event == "UNIT_DIED" then
        if self.ExistsGUID(srcGUID) then
          ChatFrame1:AddMessage(srcName.." has died.")
          self.RemoveGUID(srcGUID)
        end
      else
        if not self.ExistsGUID(srcGUID) then
          ChatFrame1:AddMessage(srcName.." enemy detected.")
          self.AddGUID(srcGUID)
        end
      end
    end

    if bit.band(dstFlags, COMBATLOG_OBJECT_TYPE_NPC) > 0 and bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
      if event == "UNIT_DIED" then
        if self.ExistsGUID(dstGUID) then
          ChatFrame1:AddMessage(dstName.." has died.")
          self.RemoveGUID(dstGUID)
        end
      else
        if not self.ExistsGUID(dstGUID) then
          ChatFrame1:AddMessage(dstName.." enemy detected.")
          self.AddGUID(dstGUID)
        end
      end
    end

    for i=1,table.getn(guids),1 do
      CreateUnitFrame(i, guids[i])
    end
  end
end

f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", f.OnEvent)