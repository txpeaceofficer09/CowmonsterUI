local unitFrame = CreateFrame("Frame", "MouseFocusFrame", UIParent)
unitFrame:SetParent(UIParent)
unitFrame:SetFrameStrata("LOW")
unitFrame:SetWidth(110)
unitFrame:SetHeight(22)
unitFrame:SetPoint("BOTTOMRIGHT", TargetFrame, "TOPRIGHT", -20, 20)
unitFrame:SetBackdrop({
  bgFile = "Interface\\TargetingFrame\\UI-TargetingFrame-Background",
  edgeFile = "Interface\\TargetingFrame\\UI-TargetingFrame-Border",
  edgeSize = 1,
  insets = { left = 1, right = 1, top = 1, bottom = 1 }
})
unitFrame:SetFrameType("unit")
unitFrame.unit = "mousefocus"
unitFrame:SetUnit(unitFrame.unit)
unitFrame.healthBar = CreateFrame("StatusBar", nil, unitFrame)
unitFrame.healthBar:SetPoint("TOPLEFT", 2, -1)
unitFrame.healthBar:SetPoint("BOTTOMRIGHT", -2, 1)
unitFrame.healthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Bar")
unitFrame.healthBar:SetStatusBarColor(0.0, 1.0, 0.0, 1.0)
unitFrame.healthBar.text = unitFrame:CreateFontString(nil, "OVERLAY")
unitFrame.healthBar.text:SetFontObject("GameFontNormal")
unitFrame.healthBar.text:SetPoint("CENTER", unitFrame.healthBar, "CENTER", 0, 0)
unitFrame.healthBar.text:SetText("100%")
unitFrame.powerBar = CreateFrame("StatusBar", nil, unitFrame)
unitFrame.powerBar:SetPoint("TOPLEFT", unitFrame.healthBar:GetRight() + 3, -1)
unitFrame.powerBar:SetPoint("BOTTOMRIGHT", unitFrame, "BOTTOMRIGHT", -2, 1)
unitFrame.powerBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Bar")
unitFrame.powerBar:SetStatusBarColor(0.0, 0.0, 1.0, 1.0)
unitFrame.powerBar.text = unitFrame:CreateFontString(nil, "OVERLAY")
unitFrame.powerBar.text:SetFontObject("GameFontNormal")
unitFrame.powerBar.text:SetPoint("CENTER", unitFrame.powerBar, "CENTER", 0, 0)
unitFrame.powerBar.text:SetText("100%")
unitFrame.nameText = unitFrame:CreateFontString(nil, "OVERLAY")
unitFrame.nameText:SetFontObject("GameFontNormal")
unitFrame.nameText:SetPoint("LEFT", unitFrame, "LEFT", 8, 10)
unitFrame.nameText:SetText(UnitName("mousefocus"))
unitFrame.levelText = unitFrame:CreateFontString(nil, "OVERLAY")
unitFrame.levelText:SetFontObject("GameFontNormal")
unitFrame.levelText:SetPoint("RIGHT", unitFrame, "RIGHT", -8, 10)
unitFrame.levelText:SetText(UnitLevel("mousefocus"))
unitFrame:Show()