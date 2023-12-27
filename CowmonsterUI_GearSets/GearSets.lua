local f = CreateFrame("Frame", nil, UIParent)

local function CreateEquipmentButtons()
	for i=1,GetNumEquipmentSets() do
		local name, icon, setID = GetEquipmentSetInfo(i)

		local btn = _G["EQ"..i.."Button"] or CreateFrame("Frame", "EQ"..i.."Button", UIParent)

		btn:SetSize(30, 30)
		if i == 1 then
			btn:SetPoint("BOTTOMLEFT", MainMenuBarBackpackButton, "TOPLEFT", 0, 2)
		else
			btn:SetPoint("BOTTOMLEFT", _G["EQ"..(i-1).."Button"], "BOTTOMRIGHT", 2, 0)
		end

		btn.name = name
		local t = btn:CreateTexture(btn:GetName().."Icon", "ARTWORK")
		t:SetAllPoints(btn)
		t:SetTexture(icon)
		t:Show()

		_G["EQ"..i.."ButtonIcon"]:SetTexture(icon)
		btn:SetScript("OnEnter", function(self, motion)
			if motion == true then
				GameTooltip:SetOwner(self)
				GameTooltip:SetEquipmentSet(self.name)
				GameTooltip:Show()
			end
		end)

		btn:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			GameTooltip:ClearLines()
		end)

		btn:SetScript("OnMouseUp", function(self, button)
			local equipped = UseEquipmentSet(self.name)
			
			DEFAULT_CHAT_FRAME:AddMessage(self.name.." equipped.", 0.5, 1, 1, 1)
		end)

		btn:Show()
	end
end

f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "EQUIPMENT_SETS_CHANGED" then
		CreateEquipmentButtons()
	end
end)

f:RegisterEvent("EQUIPMENT_SETS_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
