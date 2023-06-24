function InfoBarMoney_OnEnter(self)
	if UnitAffectingCombat("player") then return end

	InfoBarTooltip:ClearLines()
	InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	InfoBarTooltip:AddLine("Money:")
	InfoBarTooltip:AddLine(" ")

	local Money = 0

	for k, v in pairs(CowmonsterUIDB) do
		InfoBarTooltip:AddLine(k)
		InfoBarTooltip:AddLine("-----------------------")

		for a, b in pairs(v) do
			InfoBarTooltip:AddDoubleLine(a, GetCoinTextureString(b.Money or 0))
			Money = Money + (b.Money or 0)
		end
		InfoBarTooltip:AddLine("-----------------------")
	end
	InfoBarTooltip:AddDoubleLine("Total", GetCoinTextureString(Money))

	InfoBarTooltip:Show()
end

function InfoBarMoney_OnLeave(self)
	InfoBarTooltip:Hide()
	InfoBarTooltip:ClearLines()
end

function InfoBarMoney_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_MONEY" then
		InfoBarSetText("InfoBarMoney", nil, GetCoinTextureString(GetMoney()))

		CowmonsterUIDB[GetRealmName()][UnitName("player")].Money = GetMoney()
	end
end

function InfoBarMoney_OnClick(self, button)
	ToggleAllBags()
end