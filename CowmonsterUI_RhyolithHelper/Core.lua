CowmonsterUI_RhyolithHelperDB = {
	["pos_x"] = -200,
	["pos_y"] = 200,
	["showFrame"] = false,
}

local f = CreateFrame("Frame", "RhyolithFrame", UIParent)

f:SetSize(300, 220)
f:SetClampedToScreen(true)
f:SetMovable(true)	
f:SetUserPlaced(true)
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 32, edgeSize = 14, insets = { left = 3, right = 3, top = 3, bottom = 3 } } )
f.timer = 0
f.driver = ""
f.driverTarget = ""

f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("ADDON_LOADED")

local t = f:CreateFontString(f:GetName().."TitleLeft", "OVERLAY")

t:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")

t:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -5)

t:SetSize(f:GetWidth()/2, t:GetStringHeight())

t:SetText("LEFT LEG")



local t = f:CreateFontString(f:GetName().."TitleRight", "OVERLAY")

t:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
t:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)
t:SetSize(f:GetWidth()/2, t:GetStringHeight())
t:SetText("RIGHT LEG")

for i=1,10,1 do
	local t = f:CreateFontString(f:GetName().."Left"..i, "OVERLAY")

	t:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
--	t:SetText("Test "..i)
	t:SetSize(f:GetWidth()/2, t:GetStringHeight())
	t:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -25-((t:GetHeight()+2)*i)+t:GetHeight())

	local t = f:CreateFontString(f:GetName().."Right"..i, "OVERLAY")
	t:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
--	t:SetText("Test "..i)
	t:SetSize(f:GetWidth()/2, t:GetStringHeight())
	t:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -25-((t:GetHeight()+2)*i)+t:GetHeight())
end

local t = f:CreateFontString("RhyolithFrameDriver", "OVERLAY")
t:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
t:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 5, 5)
t:SetSize((f:GetWidth()/3)*2, t:GetStringHeight())
t:SetJustifyH("LEFT")
t:SetText("|cffffff00Driver: ")

local b = CreateFrame("Button", "RhyolithDriverButton", RhyolithFrame)
b:SetScript("OnClick", function(self, button)
	if UnitExists("target") and UnitIsFriend("player", "target") then
		RhyolithFrame.driver = UnitName("target")
		RhyolithFrameDriver:SetText("|cffffff00Driver: |cff00ff00"..RhyolithFrame.driver)
	else
		DEFAULT_CHAT_FRAME:AddMessage("You do not have a target that can drive.  Please target a raid member then press the [Set Driver] button again.", 1, 0, 0, 1)
	end
end)

b:SetSize((f:GetWidth()/3)-15, t:GetStringHeight())
b:SetPoint("LEFT", t, "RIGHT", 5, 0)
local t = b:CreateFontString(b:GetName().."Label", "OVERLAY")
t:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")

t:SetAllPoints(b)
t:SetText("SET DRIVER")
t:SetTextColor(1, 0.75, 0.25, 1)

f:SetScript("OnMouseDown", function(self, button)
	self:StartMoving()
end)

f:SetScript("OnMouseUp", function(self, button)
	CowmonsterUI_RhyolithHelperDB.pos_x, CowmonsterUI_RhyolithHelperDB.pos_y = select(4, self:GetPoint())

	self:StopMovingOrSizing()
end)

local function OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...

		if addon == "CowmonsterUI_RhyolithHelper" then
			DEFAULT_CHAT_FRAME:AddMessage("Rhyolith Helper loaded. /rhyo to toggle showing the addon.")

			self:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "VARIABLES_LOADED" then
		self:SetPoint("CENTER", UIParent, "CENTER", CowmonsterUI_RhyolithHelperDB.pos_x, CowmonsterUI_RhyolithHelperDB.pos_y)

		if CowmonsterUI_RhyolithHelperDB.showFrame == true then
			self:Show()
		else
			self:Hide()
		end
	end
end

local function OnUpdate(self, elapsed)
	self.timer = self.timer + elapsed

	if self.timer >= 1 then
		local leftLeg, rightLeg = {}, {}

		for i=1,10,1 do
			_G["RhyolithFrameLeft"..i]:SetText("")
			_G["RhyolithFrameRight"..i]:SetText("")
		end

		if GetNumRaidMembers() > 0 then
			for i=1,GetNumRaidMembers(),1 do
				local tgt = UnitName("raid"..i.."target")

				if tgt == "Left Leg" then
					(leftLeg):insert(UnitName("raid"..i))
				elseif tgt == "Right Leg" then
					(rightLeg):insert(UnitName("raid"..i))
				end
			end

			for k,v in ipairs(leftLeg) do
				_G["RhyolithFrameLeft"..k]:SetText(v)

				if self.driver == v then
					if self.driverTarget ~= "Left Leg" then
						self.driverTarget = "Left Leg"
						SendChatMessage("Target: Left Leg", nil, "RAID_WARNING")
					end
				end
			end

			for k,v in ipairs(rightLeg) do
				_G["RhyolithFrameRight"..k]:SetText(v)

				if self.driver == v then
					if self.driverTarget ~= "Right Leg" then
						self.driverTarget = "Right Leg"
						SendChatMessage("Target: Right Leg", nil, "RAID_WARNING")
					end
				end
			end
		end

		self.timer = 0
	end
end

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)

function SlashCmdHandler(...)
	if RhyolithFrame:IsShown() then
		RhyolithFrame:Hide()
	else
		RhyolithFrame:Show()
	end

	CowmonsterUI_RhyolithHelperDB.showFrame = RhyolithFrame:IsShown()
end

SlashCmdList['RHYOLITH_SLASHCMD'] = SlashCmdHandler
SLASH_RHYOLITH_SLASHCMD1 = '/lrh'
SLASH_RHYOLITH_SLASHCMD2 = '/rhyo'
