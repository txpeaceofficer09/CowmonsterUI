local f = CreateFrame("Frame", "MicroMenuFrame", UIParent)
f.timer = 0

f:SetPoint("BOTTOMLEFT", ChatFrame, "TOPLEFT", 0, 0)
f:SetPoint("BOTTOMRIGHT", ChatFrame, "TOPRIGHT", 0, 0)
f:SetHeight(34)
f:Show()

function f.OnEvent(self, event, ...)
	MainMenuBarBackpackButton:SetParent(MicroMenuFrame)
	MainMenuBarBackpackButton:SetSize(30, 30)
	MainMenuBarBackpackButton:ClearAllPoints()
	--MainMenuBarBackpackButton:SetPoint("BOTTOMLEFT", ChatFrame, "TOPLEFT", 0, 0)
	MainMenuBarBackpackButton:SetPoint("LEFT", MicroMenuFrame, "LEFT", 0, 0)

	for i=0,3,1 do
		local b = _G["CharacterBag"..i.."Slot"]

		b:SetParent(MicroMenuFrame)
		b:ClearAllPoints()
		b:SetPoint("BOTTOMLEFT", MainMenuBarBackpackButton, "BOTTOMRIGHT", 2+((b:GetWidth()+2)*i), 0)
	end

	local MicroButtons = {"Character", "Spellbook", "Talent", "Achievement", "Guild", "QuestLog", "PVP", "LFD", "Companions", "EJ", "Store", "MainMenu"}

	for i,v in ipairs(MicroButtons) do
		local b = _G[v.."MicroButton"]

		b:SetParent(MicroMenuFrame)
		b:SetScale(0.8)
	--	b:SetSize(b:GetWidth()/(b:GetHeight()/30), b:GetHeight()/(b:GetHeight()/30))
		b:ClearAllPoints()
	--	b:SetPoint("BOTTOMLEFT", CharacterBag3Slot, "BOTTOMRIGHT", (((b:GetWidth()+2)*i)-b:GetWidth()), 0)
		b:SetPoint("BOTTOMLEFT", CharacterBag3Slot, "BOTTOMRIGHT", (((32)*i)-32), 0)
		b:Show()
	end
end

f:SetScript("OnEvent", f.OnEvent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
f:RegisterEvent("PLAYER_GAINS_VEHICLE_DATA")
f:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
f:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

--[[
f:SetScript("OnUpdate", function(self, elapsed)
	self.timer = self.timer + elapsed

	if self.timer >= 0.5 then
		f.




































































































































































































































































































































OnEvent(self)

		self.timer = 0
	end
end)
]]