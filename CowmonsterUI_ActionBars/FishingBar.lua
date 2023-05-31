local f = CreateFrame("Frame", "FishingBar", UIParent, "SecureHandlerStateTemplate")
f:SetSize(30, 30)
f:Show()

local LBF
local updateBar = false

if IsAddOnLoaded("ButtonFacade") then
	LBF = LibStub('LibButtonFacade', true) or nil
	LBF:Group('CowmonsterUI'):Skin('Blizzard')
end

i = 1
--for i=1,12,1 do
	local bf = CreateFrame("Button", "FishingBarButton"..i, FishingBar, "SecureActionButtonTemplate")

	bf:RegisterForClicks("AnyUp")
	bf:SetSize(30, 30)

	bf:SetAttribute("type", "macro")
	bf:SetAttribute("macrotext", "/cast Fishing")
	bf:SetAttribute("showgrid", 1)
	bf:CreateTexture("FishingBarButton1Texture", "ARTWORK")
	FishingBarButton1Texture:SetAllPoints(bf)
	FishingBarButton1Texture:SetTexture("Interface\\Icons\\Trade_Fishing")

	if i == 1 then
		bf:SetPoint("LEFT", FishingBar, "LEFT", 0, 0)
	else
		bf:SetPoint("LEFT", _G["FishingBarButton"..(i-1)], "RIGHT", 2, 0)
	end

	if LBF then
		LBF:Group('CowmonsterUI'):AddButton(bf)
	end

	bf:Show()
--end

local function FishingBar_OnEvent(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button, buttons

		for i = 1, 1, 1 do
			button = _G[self:GetName().."Button"..i]
			self:SetFrameRef(self:GetName().."Button"..i, button)
		end

		self:Execute([[
			buttons = table.new()
			for i = 1, 1, 1 do
				table.insert(buttons, self:GetFrameRef(self:GetName().."Button"..i))
			end
		]])

		self:SetAttribute("_onstate-fish", [[
			for i, button in ipairs(buttons) do
				if newstate == "nofish" then
					button:Hide()
				else
					button:Show()
				end
			end
		]])
		RegisterStateDriver(self, "fish", "[equipped:Fishing Poles,mod] fish; nofish")
	end
end

--f:RegisterEvent("UPDATE_BINDINGS")

f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", FishingBar_OnEvent)
f:SetScript("OnUpdate", function(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

--	if self.timer > 0.5 then
		local x, y = GetCursorPosition()
		FishingBar:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x*UIParent:GetEffectiveScale())*2, (y*UIParent:GetEffectiveScale())*2)

--		self.timer = 0
--	end
end)