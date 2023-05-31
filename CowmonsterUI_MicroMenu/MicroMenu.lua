local f = CreateFrame("Frame", nil, UIParent)
f.timer = 0

local function OnEvent(self, event, ...)
	MainMenuBarBackpackButton:SetParent(UIParent)
	MainMenuBarBackpackButton:SetSize(30, 30)
	MainMenuBarBackpackButton:ClearAllPoints()
--	MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 180)
	MainMenuBarBackpackButton:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 150)

	for i=0,3,1 do
		local b = _G["CharacterBag"..i.."Slot"]

		b:SetParent(UIParent)
		b:ClearAllPoints()
		b:SetPoint("BOTTOMLEFT", MainMenuBarBackpackButton, "BOTTOMRIGHT", 2+((b:GetWidth()+2)*i), 0)
	end

	local MicroButtons = {"Character", "Spellbook", "Talent", "Achievement", "Guild", "PVP", "LFD", "Companions", "EJ", "Store", "MainMenu"}

	for i,v in ipairs(MicroButtons) do
		local b = _G[v.."MicroButton"]

		b:SetParent(UIParent)
		b:SetScale(0.8)
	--	b:SetSize(b:GetWidth()/(b:GetHeight()/30), b:GetHeight()/(b:GetHeight()/30))
		b:ClearAllPoints()
	--	b:SetPoint("BOTTOMLEFT", CharacterBag3Slot, "BOTTOMRIGHT", (((b:GetWidth()+2)*i)-b:GetWidth()), 0)
		b:SetPoint("BOTTOMLEFT", CharacterBag3Slot, "BOTTOMRIGHT", (((32)*i)-32), 0)
		b:Show()
	end
end

f:SetScript("OnEvent", OnEvent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
f:RegisterEvent("PLAYER_GAINS_VEHICLE_DATA")
f:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
f:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

f:SetScript("OnUpdate", function(self, elapsed)
	self.timer = self.timer + elapsed

	if self.timer >= 0.5 then
		OnEvent(self)

		self.timer = 0
	end
end)