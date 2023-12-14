playerName = UnitName("player")
playerRealm = GetRealmName()

CowmonsterUIDB = {
	[playerRealm] = {
		[playerName] = {
		},
	},
}

local f = CreateFrame("Frame", "CowmonsterUI", UIParent)

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		UIParent:SetScale(0.712)
	elseif event == "VARIABLES_LOADED" then
		if type(CowmonsterUIDB) == "table" then
			if type(CowmonsterUIDB[playerRealm]) ~= "table" then
				CowmonsterUIDB[playerRealm] = { [playerName] = { ["Settings"] = {} } }
			else
				if type(CowmonsterUIDB[playerRealm][playerName]) ~= "table" then
					CowmonsterUIDB[playerRealm][playerName] = { ["Settings"] = {} }
				end
			end
		else
			CowmonsterUIDB = { [playerRealm] = { [playerName] = { ["Settings"] = {} } } }
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		self.inCombat = 0
	elseif event == "PLAYER_REGEN_DISABLED" then
		self.inCombat = 1
	end
end

f:SetScript("OnEvent", OnEvent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
