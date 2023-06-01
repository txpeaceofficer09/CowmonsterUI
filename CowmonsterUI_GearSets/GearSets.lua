local f = CreateFrame("Frame", nil, UIParent)

local function CreateEquipmentButtons()
	for i=1,GetNumEquipmentSets() do
		local name, icon, setID = GetEquipmentSetInfo(i)

		local f = CreateFrame("Frame", "EQ"..i.."Button", UIParent)

		f:SetSize(24, 24)
		if i == 1 then
			f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 152)
		else
			f:SetPoint("BOTTOMRIGHT", _G["EQ"..(i-1).."Button"], "BOTTOMLEFT", -2, 0)
		end

		f.name = name
		f:CreateTexture(f:GetName().."Icon", "ARTWORK")
		local t = _G[f:GetName().."Icon"]
		t:SetAllPoints(f)
		t:SetTexture(icon)
		t:Show()

		_G["EQ"..i.."ButtonIcon"]:SetTexture(icon)
		f:SetScript("OnEnter", function(self, motion)
			if motion == true then
				GameTooltip:SetOwner(self)
				GameTooltip:SetEquipmentSet(self.name)
				GameTooltip:Show()
			end
		end)

		f:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			GameTooltip:ClearLines()
		end)

		f:SetScript("OnMouseUp", function(self, button)
			local equipped = UseEquipmentSet(self.name)
			
--			if equipped then
--				DEFAULT_CHAT_FRAME:AddMessage(self.name.." already equipped.", 0, 0.5, 1, 1)
--			else
--				DEFAULT_CHAT_FRAME:AddMessage("Equipping "..self.name..".", 0, 1, 1, 1)
--			end

			DEFAULT_CHAT_FRAME:AddMessage(self.name.." equipped.", 0.5, 1, 1, 1)
		end)

--		f:SetScript("OnEnter", function(self)
--			GameTooltip:ClearLines()
--			GameTooltip:SetText(self.name)
--			GameTooltip:Show()
--		end)

--		f:SetScript("OnLeave", function(self)
--			GameTooltip:Hide()
--			GameTooltip:ClearLines()
--		end)

		f:Show()
	end
end

f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		CreateEquipmentButtons()
	elseif event == "EQUIPMENT_SETS_CHANGED" then
		CreateEquipmentButtons()
	end
end)

f:RegisterEvent("EQUIPMENT_SETS_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")