local f = CreateFrame("Frame", "TabParent", UIParent)

f:SetHeight(150)

if IsAddOnLoaded("CowmonsterUI_InfoBar") then
	f:SetPoint("BOTTOMRIGHT", InfoBarFrame, "TOPRIGHT", 0, 0)
else
	f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
end

if IsAddOnLoaded("CowmonsterUI_ActionBars") then
	f:SetPoint("BOTTOMLEFT", ActionBar2, "BOTTOMRIGHT", 2, -2)
else
	f:SetWidth(500)
end

f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )
--local bg = f:CreateTexture("TabParentBG", "ARTWORK")
--bg:SetAllPoints(f)
--bg:SetTexture("Interface\\AddOns\\CowmonsterUI\\Textures\\computergeek2b.tga")
--bg:SetAlpha(0.3)

Tabs = {}

function TabExists(name)
	for k, v in pairs(Tabs) do
		if v == name then return k end
	end

	return false
end

function FCF_StartAlertFlash(chatFrame)
	if not chatFrame:IsVisible() then
		local chatTab = _G[chatFrame:GetName().."Tab"];
		chatTab.alerting = 1
	end
end

function FCF_StopAlertFlash(chatFrame)
	local chatTab = _G[chatFrame:GetName().."Tab"];
	chatTab.alerting = 0
end

function Tab_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 0.1 then
		if self.alerting == 1 then
			if self.colorIndex == 1 then
				_G[self:GetName().."Text"]:SetTextColor(0, 1, 0, 1)
				self.colorIndex = 2
			elseif self.colorIndex == 2 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.9, 0, 1)
				self.colorIndex = 3
			elseif self.colorIndex == 3 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.8, 0, 1)
				self.colorIndex = 4
			elseif self.colorIndex == 4 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.7, 0, 1)
				self.colorIndex = 5
			elseif self.colorIndex == 5 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.6, 0, 1)
				self.colorIndex = 6
			elseif self.colorIndex == 6 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.5, 0, 1)
				self.colorIndex = 7
			elseif self.colorIndex == 7 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.4, 0, 1)
				self.colorIndex = 8
			elseif self.colorIndex == 8 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.3, 0, 1)
				self.colorIndex = 9
			elseif self.colorIndex == 9 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.2, 0, 1)
				self.colorIndex = 10
			elseif self.colorIndex == 10 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.1, 0, 1)
				self.colorIndex = 11
			elseif self.colorIndex == 11 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.0, 0, 1)
				self.colorIndex = 12
			elseif self.colorIndex == 12 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.1, 0, 1)
				self.colorIndex = 13
			elseif self.colorIndex == 13 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.2, 0, 1)
				self.colorIndex = 14
			elseif self.colorIndex == 14 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.3, 0, 1)
				self.colorIndex = 15
			elseif self.colorIndex == 15 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.4, 0, 1)
				self.colorIndex = 16
			elseif self.colorIndex == 16 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.5, 0, 1)
				self.colorIndex = 17
			elseif self.colorIndex == 17 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.6, 0, 1)
				self.colorIndex = 18
			elseif self.colorIndex == 18 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.7, 0, 1)
				self.colorIndex = 19
			elseif self.colorIndex == 19 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.8, 0, 1)
				self.colorIndex = 20
			elseif self.colorIndex == 20 then
				_G[self:GetName().."Text"]:SetTextColor(0, 0.9, 0, 1)
				self.colorIndex = 1
			else
				_G[self:GetName().."Text"]:SetTextColor(0, 1, 0, 1)
				self.colorIndex = 1
			end
		end

		self.timer = 0
	end
end

function SwitchTab(parent)
	if not TabExists(parent:GetName()) then return end

	for k,v in pairs(Tabs) do
		if v == parent:GetName() then
			_G[v.."Tab"]:SetAlpha(1)
			_G[v.."TabText"]:SetTextColor(1, 1, 1, 1)
			_G[v.."Tab"].alerting = 0
			_G[v]:Show()
		else
			_G[v.."Tab"]:SetAlpha(0.5)
			_G[v.."TabText"]:SetTextColor(0.5, 0.5, 0.5, 1)
			_G[v]:Hide()
		end
	end
end

function CreateTab(parent)
	local t = CreateFrame("Button", parent:GetName().."Tab", UIParent)
	local i = TabExists(parent:GetName())

	if not i then
		tinsert(Tabs, parent:GetName())
		i = #(Tabs)
	end

	if i == 1 then
		t:SetPoint("BOTTOMLEFT", TabParent, "TOPLEFT", 2, 0)
		t:SetAlpha(0.5)
	else
		t:SetPoint("LEFT", _G[Tabs[(i-1)].."Tab"], "RIGHT", 2, 0)
		t:SetAlpha(0.5)
	end
	t:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

	local tl = t:CreateFontString(t:GetName().."Text", "OVERLAY")
	tl:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
	tl:SetAllPoints(t)
	tl:SetJustifyH("CENTER")
	tl:SetText(strsub(parent:GetName(), 1, -6))
	t:SetSize(tl:GetStringWidth()+30, 18)
	tl:SetTextColor(0.5, 0.5, 0.5, 1)
	tl:Show()
	t:Show()
	t:SetScript("OnClick", function(self, button)
--		for k,v in pairs(Tabs) do
--			if strsub(self:GetName(), 1, -4) == v then
--				self:SetAlpha(1)
--				_G[self:GetName().."Text"]:SetTextColor(1, 1, 1, 1)
--				self.alerting = 0
--				_G[v]:Show()
--			else
--				_G[v.."Tab"]:SetAlpha(0.75)
--				_G[v]:Hide()
--			end
--		end

		SwitchTab(_G[(self:GetName()):sub(1, -4)])
	end)
	t.timer = 0
	t.colorIndex = 1
	t.alerting = 0
	t:SetScript("OnUpdate", Tab_OnUpdate)
end