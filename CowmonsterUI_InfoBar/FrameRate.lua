function InfoBarFPS_OnUpdate(self, elapsed)
	InfoBarFPS_tmr = (InfoBarFPS_tmr or 0) + elapsed

	if InfoBarFPS_tmr >= 1 then
		if GetFramerate() <= 15 then
			InfoBarSetText("InfoBarFPS", "|cFFFF0000%.0f |cFFFFFFFFFPS ", GetFramerate())
		elseif GetFramerate() <= 25 then
			InfoBarSetText("InfoBarFPS", "|cFFFF8000%.0f |cFFFFFFFFFPS ", GetFramerate())
		elseif GetFramerate() <= 35 then
			InfoBarSetText("InfoBarFPS", "|cFFFFFF00%.0f |cFFFFFFFFFPS ", GetFramerate())
		else
			InfoBarSetText("InfoBarFPS", "|cFF00FF00%.0f |cFFFFFFFFFPS ", GetFramerate())
		end			

		InfoBarFPS_tmr = 0
	end
end