-----------------------------------------------
--  INITIALIZE SETTINGS / LOAD ACE LIBRARIES --
-----------------------------------------------

local addonName = ...
local VERSION = GetAddOnMetadata(addonName, "Version")
local PREFIX = "EAILT"

local addon = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceConsole-3.0")
local LibQTip = LibStub("LibQTip-1.0")
local AceGUI = LibStub("AceGUI-3.0")

UnitItemLevelDB = {} -- Global table of data so other addons can use our information.
lastInspectRequest = 0 -- Global variable so other addons can use our inspect times to throttle themselves.

local defaults = {
	profile = {
		decimal_places = 1,	-- (0-9) number of decimal places (IE 400.543 or 400.5) to show on item levels.
		show_spec = true,	-- (true/false) toggle showing talent spec on mouseover.
		show_items = true,	-- (true/false) toggle showing list of slots with ilvl on tooltip.
		inspectDelay = 1,	-- Time (in seconds) to delay between calls to NotifyInspect(unit) [The function which sends requests for player information to the server]
	},
}

function addon:OnInitialize()
	addon.settings = LibStub("AceDB-3.0"):New(addonName.."DB", defaults, true)

	addon.slots = {
	    "CharacterHeadSlot",
	    "CharacterNeckSlot",
	    "CharacterShoulderSlot",
	    "CharacterBackSlot",
	    "CharacterChestSlot",
	    "CharacterShirtSlot",
	    "CharacterTabardSlot",
	    "CharacterWristSlot",
	    "CharacterMainHandSlot",
	    "CharacterSecondaryHandSlot",
	    "CharacterTrinket0Slot",
	    "CharacterTrinket1Slot",
	    "CharacterFinger0Slot",
	    "CharacterFinger1Slot",
	    "CharacterFeetSlot",
	    "CharacterLegsSlot",
	    "CharacterWaistSlot",
	    "CharacterHandsSlot",
	}

	addon.invSlots = {
		[1] = "Helm",
		[2] = "Neck",
		[3] = "Shoulders",
		[5] = "Chest",
		[6] = "Belt",
		[7] = "Legs",
		[8] = "Boots",
		[9] = "Bracers",
		[10] = "Gloves",
		[11] = "Ring 1",
		[12] = "Ring 2",
		[13] = "Trinket 1",
		[14] = "Trinket 2",
		[15] = "Cloak",
		[16] = "Main Hand",
		[17] = "Off Hand",
	}

	addon.itemUpgrade = {
		["0"]=0,
		["445"]=0,
		["451"]=0,
		["465"]=0,
		["491"]=0,
		["504"]=12,
		["505"]=16,
	}

	local addon.leftStrings = {10,6,7,8,11,12,13,14}
	local addon.rightStrings = {1,2,3,15,5,9}
	local addon.topStrings = {16,17}

	addon:RegisterComm(PREFIX)
end

local function round(num)
	local tmp = math.floor(num)
	if num - tmp <= 0.5 then tmp = tmp+1 end
	return tmp
end

local function inArray(tbl, str)
	for k,v in pairs(tbl) do
		if v == str then
			return true
		end
	end

	return false
end

-----------------------------------------------
-- SLASH COMMAND FUNCTION(S)                 --
-----------------------------------------------

function addon:SlashCommand(cmd, self)
	addon:ShowGUI()
	
	--[[
	local i, arg, args = 1, nil, {}
	
	while addon:GetArgs(cmd, 1, i) do
		arg, i = addon:GetArgs(cmd, 1, i)
		table.insert(args, arg)
	end
	
	if #args >= 1 then
		if args[1] == "show" then
			if #args < 2 then
				print("/eailt show [spec/items]")
			else
				if args[2] == "spec" then
					if addon.settings.profile.show_spec == true then
						addon.settings.profile.show_spec = false
					else
						addon.settings.profile.show_spec = true
					end
					print("EAILT show specialization: "..addon.settings.profile.show_spec)
				elseif args[2] == "items" then
					if addon.settings.profile.show_items == true then
						addon.settings.profile.show_items = false
					else
						addon.settings.profile.show_items = true
					end
					print("EAILT show item list: "..addon.settings.profile.show_items)
				else
					print("/eailt show [spec/items]")
				end
			end
		elseif args[1] == "decimal" then
			if #args < 2 then
				print("/eailt decimal [0-9]")
			else
				if args[2]:tonumber() > 9 or args[2]:tonumber() < 0 then
					print("/eailt decimal [0-9]")
					print("  current: "..addon.settings.profile.decimal_places)
					print("  default: "..defaults.profile.decimal_places)
				else
					addon.settings.profile.decimal_places = args[2]:tonumber()
				end
			end
		elseif args[1] == "delay" then
			if #args < 2 then
				print("/eailt delay [0-9]")
				print("  current: "..addon.settings.profile.inspectDelay)
				print("  default: "..defaults.profile.inspectDelay)
			else
				if args[2]:tonumber() > 9 or args[2]:tonumber() < 0 then
					print("/eailt delay [0-9]")
				else
					addon.settings.profile.inspectDelay = args[2]:tonumber()
					print("EAILT inspect delay: "..addon.settings.profile.inspectDelay)
				end
			end
		elseif args[1] == "reset" then
			-- reset to default settings
		elseif args[1] == "config" then
			addon:ShowGUI()
		else
			-- print options list
			print("/eailt - Display this help.")
			print("  config - open the GUI interface.")
			print("  show spec - toggle showing specialization in tooltip.")
			print("  show items - toggle showing items list in tooltip.")
			print("  decimal # - set number of decimal places to show in item levels.")
			print("  delay # - set number of seconds between inspect requests.")
			print("  reset - reset all settings back to default.")		
		end
	else
		-- print options list
		print("/eailt - Display this help.")
		print("  config - open the GUI interface.")
		print("  show spec - toggle showing specialization in tooltip.")
		print("  show items - toggle showing items list in tooltip.")
		print("  decimal # - set number of decimal places to show in item levels.")
		print("  delay # - set number of seconds between inspect requests.")
		print("  reset - reset all settings back to default.")
	end
	
	addon:UpdateLDBText()
	]]
end

-----------------------------------------------
-- AceGUI-3.0                                --
-----------------------------------------------

function addon:ShowGUI()
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("Equipped Average Item Level Tooltip")
	frame:SetStatusText("Version "..VERSION.." by Isoloedlk of US-Khaz Modan")
	frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
	frame:SetWidth(500)
	frame:SetHeight(150)
	frame:SetLayout("Flow")

	local check = AceGUI:Create("CheckBox")
	check:SetLabel("Show Specialization")
	check:SetValue(addon.settings.profile.show_spec)
	check:SetCallback("OnValueChanged", function(self, method, value) addon.settings.profile.show_spec = value end)
	--check:SetCallback("OnValueChanged", function(...) print(...) end)
	frame:AddChild(check)

	local check = AceGUI:Create("CheckBox")
	check:SetLabel("Show Item List")
	check:SetValue(addon.settings.profile.show_items)
	check:SetCallback("OnValueChanged", function(self, method, value) addon.settings.profile.show_items = value end)
	--check:SetCallback("OnValueChanged", function(...) print(...) end)
	frame:AddChild(check)

	local slider = AceGUI:Create("Slider")
	slider:SetLabel("Decimal Places")
	slider:SetSliderValues(0, 9, 1)
	slider:SetValue(addon.settings.profile.decimal_places)
	slider:SetCallback("OnValueChanged", function(self, method, value) addon.settings.profile.decimal_places = value end)
	--slider:SetCallback("OnValueChanged", function(...) print(...) end)
	frame:AddChild(slider)

	local slider = AceGUI:Create("Slider")
	slider:SetLabel("Inspect Request Delay")
	slider:SetSliderValues(0, 9, 1)
	slider:SetValue(addon.settings.profile.inspectDelay)
	slider:SetCallback("OnValueChanged", function(self, method, value) addon.settings.profile.inspectDelay = value end)
	--slider:SetCallback("OnValueChanged", function(...) print(...) end)
	frame:AddChild(slider)
end
-----------------------------------------------
-- GENERAL FUNCTIONS                         --
-----------------------------------------------

function addon:print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cffaaffcc[EAILT]:|r "..msg)
end

function addon:IsPvP()
	local retVal = false
	local instanceType = select(2, IsInInstance())
	
	if instanceType == "arena" or instanceType == "pvp" then
		retVal = true
	end
	
	return retVal, instanceType
end

function addon:showSpecFilter()
	local filter = {
		bTooltip = false,
		TipTacTalents = false,
	}

	for k, v in pairs(filter) do
		if k == "TipTacTalents" and TipTac_Config then
			if TipTac_Config.showTalents == true and addon.settings.profile.show_spec == true then
				filter[k] = true
			elseif TipTac_Config.showTalents == false and addon.settings.profile.show_spec == true then
				filter[k] = false
			end
		else
			filter[k] = IsAddOnLoaded(k)
		end
	end
	
	for k, v in pairs(filter) do
		if v == true then return true end
	end
end

-----------------------------------------------
--  MATH FUNCTIONS                           --
-----------------------------------------------

function addon:Round(num)
	return tonumber(string.format("%."..addon.settings.profile.decimal_places.."f", num))
end

-----------------------------------------------
-- TABLE FUNCTIONS                           --
-----------------------------------------------

function addon:insert(val, key)
	local index = addon:search('guid', val.guid)

	if index then
		UnitItemLevelDB[index] = val
	else
		if key then
			table.insert(UnitItemLevelDB, key, val)
		else
			table.insert(UnitItemLevelDB, val)
		end
	end
	
	addon:prune()
end

function addon:remove(key, val)
	if val then
		table.remove(UnitItemLevelDB, addon:search(key, val))
	else
		table.remove(UnitItemLevelDB, key)
	end
end

function addon:search(key, val)
	local retVal, retTbl

	for k, v in pairs(UnitItemLevelDB) do
		if v[key] == val then
			retVal = k
			retTbl = v
			break
		end
	end
	
	return retVal, retTbl
end

function addon:prune()
	local i = 1

	while #(UnitItemLevelDB) > 50 do
		if UnitItemLevelDB[i] then
			local found
			
			for b=1,GetNumGroupMembers(),1 do
				local guid = UnitGUID("raid"..b) or UnitGUID("party"..b)
				
				if guid and guid == UnitItemLevelDB[i].guid then
					found = true
					break
				end
			end
			
			if not found then addon:remove(i) end
		end
		
		i = i + 1
	end
end

-----------------------------------------------
-- LibDataBroker                             --
-----------------------------------------------

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

local function ldbOnEnter(self)
	local tooltip = LibQTip:Acquire(addonName.."Tooltip", 3, "LEFT", "CENTER", "RIGHT")
	self.tooltip = tooltip
	
	local dataset = {}
	local gType, gMembers
	
	for i=1,GetNumGroupMembers(),1 do
		if UnitExists("raid"..i) then
			gType = "raid"
			gMembers = GetNumGroupMembers()
			break
		elseif UnitExists("party"..i) then
			gType = "party"
			gMembers = GetNumGroupMembers()
			break
		end
	end
	
	if not gType then return end
	
	for i=1,gMembers,1 do
		local unitGUID = UnitGUID(gType..i)
		
		if unitGUID and type(unitGUID) == "string" and unitGUID ~= UnitGUID("player") then
			local index, data = addon:search('guid', unitGUID)
			
			if index then
				table.insert(dataset, {data.name or "Unknown", data.spec or "???", addon:Round(tonumber(data.equipped)) or 0})
			else
				local name = select(6, GetPlayerInfoByGUID(unitGUID)) or "Unknown"

				table.insert(dataset, {name, "???", 0})
			end
		end
	end

	table.insert(dataset, {UnitName("player"), addon:GetSpec(false), ("%.1f"):format(select(2, GetAverageItemLevel()))})

	local sortTbl = {}

	for k,v in pairs(dataset) do
		table.insert(sortTbl, k)
	end

	table.sort(sortTbl, function(a, b)
		return tonumber(dataset[a][3]) > tonumber(dataset[b][3])
	end)

	tooltip:AddHeader('Name', 'Specialization', 'Equipped iLvl')

	for k,v in pairs(sortTbl) do
		local i, c = tooltip:AddLine(dataset[v][1], dataset[v][2], dataset[v][3])
		
		if dataset[v][1] == UnitName("player") then
			tooltip:SetLineColor(i, 0, 1, 0, 1)
		elseif dataset[v][3] == 0 then
			tooltip:SetLineColor(i, 1, 0.5, 0, 1)
		else
			tooltip:SetLineColor(i, 1, 1, 0, 1)
		end
	end

	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end

local function ldbOnLeave(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
end


function ldbOnClick(self, button)
	if button == "LeftButton" then
		if GetNumGroupMembers() < 1 then
			addon:print("You are not in a group.")
			return
		end

		if addon:IsPvP() then
			addon:print("You are in PvP.")
			return
		end

		local dataset = {}
		local gMembers, gType
		
		for i=1,GetNumGroupMembers(),1 do
			if UnitExists("raid"..i) then
				gType = "raid"
				gMembers = GetNumGroupMembers()
				break
			elseif UnitExists("party"..i) then
				gType = "party"
				gMembers = GetNumGroupMembers()
				break
			end
		end

		for i=1,gMembers,1 do
			local unitGUID = UnitGUID(gType..i)
		
			if unitGUID and type(unitGUID) == "string" and unitGUID ~= UnitGUID("player") then
				local index, data = addon:search('guid', unitGUID)
			
				if index then
					table.insert(dataset, {data.name or "Unknown", ("%.1f"):format(tonumber(data.equipped)), data.spec or "None"})
				else
					local name = select(6, GetPlayerInfoByGUID(unitGUID)) or "Unknown"

					table.insert(dataset, {name, 0, "None"})
				end
			end
		end
     
		table.insert(dataset, {UnitName("player"), addon:Round(select(2, GetAverageItemLevel())), select(2, GetSpecializationInfo(GetSpecialization()))})

		local sortTbl = {}

		for k,v in pairs(dataset) do
			table.insert(sortTbl, k)
		end

		table.sort(sortTbl, function(a, b)
			return tonumber(dataset[a][2]) > tonumber(dataset[b][2])
		end)

		SendChatMessage("Group Item Levels:", gType)

		for k,v in pairs(sortTbl) do
			SendChatMessage(dataset[v][1].." ["..dataset[v][3].."] "..dataset[v][2], gType)
		end
	end
end

local dataobj = ldb:NewDataObject(addonName, {
	type = "data source",
	text = "ilvl(s): Loading...",
	OnEnter = ldbOnEnter,
	OnLeave = ldbOnLeave,
	OnTooltipShow = ldbOnTooltipShow,
	OnClick = ldbOnClick,
})

function addon:UpdateLDBText()
	local avg, equipped = GetAverageItemLevel()

	dataobj.text = "ilvl(s): "..addon:Round(equipped).." / "..addon:Round(avg)
end

-----------------------------------------------
-- ENABLE/DISABLE ADDON FUNCTIONS            --
-----------------------------------------------

function addon:OnEnable()
	self:RegisterEvent("INSPECT_READY")
	
	--self:RegisterEvent("ADDON_LOADED")
	
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_READY")
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	
	self:Hook("NotifyInspect", true)

	self:SecureHookScript(GameTooltip, "OnTooltipSetUnit", addon['OnTooltipSetUnit'])
	--self:SecureHookScript(GameTooltip, "OnShow", addon['TooltipOnShow'])
	--self:SecureHookScript(GameTooltip, "OnHide", addon['TooltipOnHide'])
	
	--self:SecureHook(GameTooltip, "AddDoubleLine", addon['AddDoubleLine'])

	self:RegisterChatCommand("eailt", "SlashCommand", true)
	
	addon:UpdateLDBText()

	--addon:print(addonName.." version "..VERSION.." enabled.")
end

function addon:OnDisable()
	self:UnregisterEvent("INSPECT_READY")
	
	--self:UnregisterEvent("ADDON_LOADED")
	
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
	self:UnregisterEvent("PLAYER_AVG_ITEM_LEVEL_READY")
	self:UnregisterEvent("RAID_ROSTER_UPDATE")
	self:UnregisterEvent("PARTY_MEMBERS_CHANGED")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	self:UnHook("NotifyInspect")

	self:UnHook(GameTooltip, "OnTooltipSetUnit")
	--self:UnHook(GameTooltip, "OnShow")
	--self:UnHook(GameTooltip, "OnHide")

	self:UnregisterChatCommand("eailt")

	self:CancelAllTimers()

	--addon:print(addonName.." version "..VERSION.." disabled.")
end

-----------------------------------------------
-- EVENTS/HOOKS                              --
-----------------------------------------------

function addon:NotifyInspect(unitID)
--[[
	--if not InspectFrame then
	--	LoadAddOn("Blizzard_InspectUI")
	--end

	if ( InspectFrame and InspectFrame:IsVisible() ) or ( Examiner and Examiner:IsVisible() ) then
		InspectFrame.unit = "target"
	--else
		--InspectFrame.unit = "player"
	elseif InspectFrame then
		InspectFrame.unit = unitID
	end
]]
	addon.guid = UnitGUID(unitID)
	lastInspectRequest = GetTime()
end

function addon:INSPECT_READY(_, unitGUID)
	local ilvl, items = addon:GetUnitItemLevelGUID(unitGUID)
	local index, tbl = addon:search('guid', unitGUID)
	local count = 0
	local spec = "..."
	
	if unitGUID == addon.guid then spec = addon:GetSpec(true) end
	
	if index then
		count = tbl.scanCount
		if (count or 1) < 2 then addon:Inspect(addon:GetUnitByGUID(unitGUID)) end
	end

	if #(items or {}) <= 7 then
		addon:Inspect(addon:GetUnitByGUID(unitGUID))
	end
	
	if ilvl then
		addon:insert({
			['guid'] = unitGUID,
			['name'] = select(6, GetPlayerInfoByGUID(unitGUID)),
			['equipped'] = ilvl,
			['items'] = items,
			['spec'] = spec,
			['scanCount'] = count,
		})

		if not IsInRaid() and GetNumGroupMembers() > 0 then
			for i=1,GetNumGroupMembers(),1 do
				if unitGUID == UnitGUID("party"..i) then
					local txt = _G["PartyMemberFrame"..i.."ilvl"] or _G["PartyMemberFrame"..i]:CreateFontString("PartyMemberFrame"..i.."ilvl", "OVERLAY")
					txt:SetPoint("LEFT", _G["PartyMemberFrame"..i], "LEFT", 6, 0)
					txt:SetSize(48, 48)
					txt:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
					txt:SetText(round(ilvl))
					txt:Show()
				end
			end
		end

		addon:UpdateTooltip()
	end
end

--[[function addon:ADDON_LOADED(_, name)
	if name == "TipTacTalents" or IsAddOnLoaded("TipTacTalents") then
		if TipTac_Config then
			if TipTac_Config.showTalents == true then
				addon.settings.profile.show_spec = false
			end
		else
			addon.settings.profile.show_spec = false
		end
		
		--addon:UnregisterEvent("ADDON_LOADED")
	elseif name == "bTooltip" or IsAddOnLoaded("bTooltip") then
		addon.settings.profile.show_spec = false
	end
end]]

function addon:PLAYER_AVG_ITEM_LEVEL_READY(...)
	addon:UpdateLDBText()

	local _, ilvl = GetAverageItemLevel()

	local txt = _G["PlayerFrameilvl"] or _G["PlayerFrame"]:CreateFontString("PlayerFrameilvl", "OVERLAY")
	txt:SetPoint("LEFT", PlayerFrame, "LEFT", 50, 0)
	txt:SetSize(48, 48)
	txt:SetFont("Fonts\\ARIALN.ttf", 18, "OUTLINE")
	txt:SetText(round(ilvl))
	txt:Show()
end

function addon:UNIT_INVENTORY_CHANGED(_, unitID)
	local gType
	
	if UnitGUID(unitID) ~= UnitGUID("player") then
		addon:remove('guid', UnitGUID(unitID))

		addon:Inspect(unitID)
	else
		for i=1,GetNumGroupMembers(),1 do
			if UnitExists("raid"..i) then
				gType = "raid"
				break
			elseif UnitExists("party"..i) then
				gType = "party"
				break
			end
		end
	
		if gType and addon:IsPvP() == false then
			addon:SendItemInfo(gType:upper())
		end

		local _, ilvl = GetAverageItemLevel()

		local txt = _G["PlayerFrameilvl"] or _G["PlayerFrame"]:CreateFontString("PlayerFrameilvl", "OVERLAY")
		txt:SetPoint("LEFT", PlayerFrame, "LEFT", 6, 0)
		txt:SetSize(48, 48)
		txt:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
		txt:SetText(round(ilvl))
		txt:Show()
		
		addon:UpdateLDBText()
	end
end

-----------------------------------------------
-- ADDON COMMS                               --
-----------------------------------------------

function addon:GroupType()
	if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena" then
		return false, "none"
	end

	for i=1,GetNumGroupMembers(),1 do
		if UnitExists("raid"..i) then
			return true, "raid"
		end
	end

	for i=1,GetNumGroupMembers(),1 do
		if UnitExists("party"..i) then
			return true, "party"
		end
	end
end

function addon:PLAYER_ENTERING_WORLD()
	local isGroup, groupType = addon:GroupType()

	if isGroup then
		addon:SendCommMessage(PREFIX, addon:Serialize({type = "REQUEST_INFO"}), groupType:upper(), nil, "NORMAL")	
	end	
end

function addon:RAID_ROSTER_UPDATE()
	local isGroup, groupType = addon:GroupType()
	
	if isGroup and groupType == "raid" then
		addon:SendVersion("RAID")
		addon:SendItemInfo("RAID")	
	end
end

function addon:PARTY_MEMBERS_CHANGED()
	local isGroup, groupType = addon:GroupType()
	
	if isGroup and groupType == "party" then
		addon:SendVersion("PARTY")
		addon:SendItemInfo("PARTY")
	end
end

function addon:SendVersion(gType)
	addon:SendCommMessage(PREFIX, addon:Serialize({type = "VERSION", msg = VERSION}), gType, nil, "NORMAL")
end

function addon:SendItemInfo(gType)
	local ilvl, items = addon:GetUnitItemLevel("player")

	addon:SendCommMessage(PREFIX, addon:Serialize({type = "ITEM_INFO", msg = {
			['guid'] = UnitGUID("player"),
			['name'] = UnitName("player"),
			['equipped'] = ilvl,
			['items'] = items,
		}}), gType, nil, "NORMAL")
end

function addon:OnCommReceived(pre, msg, chan, sender)
	if pre == PREFIX and sender ~= UnitName("player") then
		local _, data = addon:Deserialize(msg)

		if data.type == "VERSION" and data.msg > VERSION and ( addon.versionWarning or 0 ) == 0 then
			addon:print("A newer version is available.  Visit http://www.wowinterface.com to download the latest version.")
			addon.versionWarning = 1
		elseif data.type == "ITEM_INFO" then
			--addon:print("Received item info from "..sender)
			addon:insert(data.msg)
		elseif data.type == "REQUEST_INFO" then
			addon:SendItemInfo(chan)
		end
	end
end

-----------------------------------------------
-- TOOLTIP FUNCTIONS                         --
-----------------------------------------------

function addon:searchTT(val)
	local retVal
	
	for i=2, GameTooltip:NumLines()+1 do
		local txt = _G["GameTooltipTextLeft"..i]:GetText() or ""
		
		if txt:find(val) then
			retVal = i
			break
		end
	end
	
	return retVal
end

function addon:OnTooltipSetUnit()
	local _, unit = self:GetUnit()

	addon:Inspect(unit)
	
	if unit and UnitGUID(unit) == UnitGUID("player") then
		local ilvl, items = addon:GetUnitItemLevel("player")
	
		addon:insert({
			['guid'] = UnitGUID("player"),
			['name'] = UnitName("player"),
			['equipped'] = ilvl,
			['items'] = items,
			['spec'] = addon:GetSpec(false),
			['scanCount'] = 2,
		})

		if addon.settings.profile.show_spec and not addon:showSpecFilter() and UnitLevel("player") >= 10 then
			self:AddLine("Spec: |cffffffff"..select(2, GetSpecializationInfo(GetSpecialization())))
			if not self.fadeOut then self:Show() end
		end
		
		self:AddLine("iLvl: |cffff8000"..addon:Round(ilvl))
		if not self.fadeOut then self:Show() end
		
		if addon.settings.profile.show_items then
			for i=1,17,1 do
				if i ~= 4 and items[i] then
					self:AddDoubleLine(addon.invSlots[i], "|c"..items[i].color..items[i].name.." |cffffffff("..(items[i].itemLevel or "???")..")")
					if not self.fadeOut then self:Show() end
				elseif i ~= 4 then
					self:AddDoubleLine(addon.invSlots[i], "|cffaaaaaaNone/Not Scanned |cffffffff(???)")
					if not self.fadeOut then self:Show() end
				end
			end
		end
	elseif unit and UnitIsPlayer(unit) then
		if addon.settings.profile.show_spec and not addon:showSpecFilter() and UnitLevel(unit) >= 10 then
			self:AddLine("Spec: |cffffffff...")
			self:Show()
		end
		
		self:AddLine("iLvl: |cffff8000...", 1, 1, 1)
		if not self.fadeOut then self:Show() end
		
		if addon.settings.profile.show_items then
			for i=1,17,1 do
				if i ~= 4 then
					self:AddDoubleLine(addon.invSlots[i], "|cffaaaaaaNone/Not Scanned |cffffffff(???)")
					if not self.fadeOut then self:Show() end
				end
				--GameTooltip:Show()
			end
		end
	end
	
	addon:UpdateTooltip()
end

function addon:TooltipOnShow()
	--if GameTooltip:GetUnit() then print("It's a unit!") end
	addon.tooltiptimer = addon:ScheduleRepeatingTimer("UpdateTooltip", 0.2)
end

function addon:TooltipOnHide()
	--GameTooltip:SetMinResize(0, 0)
	addon:CancelTimer(addon.tooltiptimer)
end

function addon:UpdateTooltip()
	if GameTooltip:GetUnit() then
		local name, unit = GameTooltip:GetUnit()

		if not unit or not UnitIsPlayer(unit) then return end
		
		local index, data = addon:search('guid', UnitGUID(unit))
		
		if index then
			local found

			if addon.settings.profile.show_spec and data.spec and not addon:showSpecFilter() then
				found = addon:searchTT("Spec:")
				
				if found then
					_G["GameTooltipTextLeft"..found]:SetFormattedText("Spec: |cffffffff%s", data.spec)
				else
					GameTooltip:AddLine("Spec: |cffffffff"..data.spec)
					GameTooltip:Show()
				end
			end
			
			found = addon:searchTT("iLvl:")
			
			if found then
				_G["GameTooltipTextLeft"..found]:SetFormattedText("iLvl: |cffff8000%s", data.equipped)
			else
				GameTooltip:AddLine("iLvl: |cffff8800"..data.equipped)
				if not GameTooltip.fadeOut then GameTooltip:Show() end
			end
	
			if addon.settings.profile.show_items then
					
				for i=1, 17,1 do
					if i ~= 4 then
						found = addon:searchTT(addon.invSlots[i])
					
						if found then
							if data.items[i] then
								_G["GameTooltipTextRight"..found]:SetFormattedText("|c%s%s |cffffffff(%s)", data.items[i].color, data.items[i].name, data.items[i].itemLevel)
							else
								_G["GameTooltipTextRight"..found]:SetFormattedText("|c%s%s |cffffffff(%s)", "ffaaaaaa", "None/Not Scanned", "???")
							end
							if not GameTooltip.fadeOut then GameTooltip:Show() end
						else
							if data.items[i] then
								GameTooltip:AddDoubleLine(addon.invSlots[i], "|c"..data.items[i].color..data.items[i].name.." |cffffffff("..(data.items[i].itemLevel or "???")..")")
							else
								GameTooltip:AddDoubleLine(addon.invSlots[i], "|cffaaaaaaNone/Not Scanned |cffffffff(???)")
							end
							if not GameTooltip.fadeOut then GameTooltip:Show() end
						end
					end
				end
			end
		end
	end
end

--[[function addon:AddDoubleLine(...)
	if not GameTooltip.fadeOut then
		GameTooltip:Show()
	end
end]]

--[[function addon:RefreshGameTooltip()
	local lwidth, rwidth, width, index
	
	index = addon:searchTT(addon.invSlots[1])
	
	for i=index,GameTooltip:NumLines(),1 do
		local l, r = _G["GameTooltipTextLeft"..i], _G["GameTooltipTextRight"..i]
		
		if l:GetWidth() >= ( lwidth or 0 ) then
			lwidth = l:GetWidth()
		end
		
		if r:GetWidth() >= ( rwidth or 0 ) then
			rwidth = r:GetWidth()
		end
		
		width = lwidth + rwidth + 50
	end
	
	for i=index,GameTooltip:NumLines(),1 do
		local l, r = _G["GameTooltipTextLeft"..i], _G["GameTooltipTextRight"..i]
		
		r:SetPoint("RIGHT", l, "LEFT", width - 22, 0)
	end
	
	GameTooltip:SetWidth(width)
	GameTooltip:Show()
end]]

-----------------------------------------------
-- INSPECT FUNCTION(S)                       --
-----------------------------------------------

function addon:Inspect(unit)
	addon:CancelTimer(addon.inspectTimer, true)
	
	if unit and UnitExists(unit) and not UnitIsUnit(unit, "player") then
		if CanInspect(unit, false) and CheckInteractDistance(unit, 1) and ( GetTime() - lastInspectRequest ) >= addon.settings.profile.inspectDelay and not ( ( InspectFrame and InspectFrame:IsVisible() ) or ( Examiner and Examiner:IsVisible() ) ) then
			NotifyInspect(unit)
		else
			addon.inspectTimer = addon:ScheduleTimer("Inspect", addon.settings.profile.inspectDelay, unit)
		end
	end
end

-----------------------------------------------
-- ITEMLEVEL FUNCTIONS                       --
-----------------------------------------------

function addon:GetUnitByGUID(unitGUID)
	local unitID

	for i = 1, 4, 1 do
		if UnitGUID("party"..i) == unitGUID then unitID = "party"..i end
	end

	for i = 1, 40, 1 do
		if UnitGUID("raid"..i) == unitGUID then unitID = "raid"..i end
	end

	if UnitGUID("player") == unitGUID then
		unitID = "player"
	elseif UnitGUID("mouseover") == unitGUID then
		unitID = "mouseover"
	elseif UnitGUID("target") == unitGUID then
		unitID = "target"
	elseif UnitGUID("focus") == unitGUID then
		unitID = "focus"
	end

	return unitID
end

function addon:GetUnitItemLevel(unit)
	local items = {}
	local sum, count

	if unit and UnitIsPlayer(unit) and CheckInteractDistance(unit, 1) then
		for i=1, 17, 1 do
			local link = GetInventoryItemLink(unit, i)
			local name, _, quality, itemLevel = GetItemInfo(link or 0)
			local color = select(4, GetItemQualityColor(quality or 1))

			if itemLevel and itemLevel > 0 and i ~= 4 then
				local upgrade = string.match(link, ":(%d+)\124h%[")
				if upgrade then
					local upgradeAmt = (addon.itemUpgrade[upgrade] or 0)
					itemLevel = itemLevel + upgradeAmt
					if (addon.itemUpgrade[upgrade] or -1) == -1 then
						print(link.." Item Upgrade: "..upgrade.." Item Level: "..itemLevel)
					end
				end

				table.insert(items, i, {
					['name'] = name,
					['itemLevel'] = itemLevel,
					['color'] = color,
					['slotName'] = addon.invSlots[i],
				})
				sum = (sum or 0) + itemLevel 
				count = (count or 0) + 1
			end
		end
		
		if (sum or 0) >= (count or 0) and (count or 0) > 0 then
			return addon:Round(sum/count), items
		else
			return nil, nil
		end
	end
end

function addon:GetUnitItemLevelGUID(unitGUID)
	return addon:GetUnitItemLevel(addon:GetUnitByGUID(unitGUID))
end

function addon:GetGUIDByName(name)
	local index, data = addon:search('name', name)

	return data.guid or nil
end

-----------------------------------------------
-- TALENT FUNCTIONS                          --
-----------------------------------------------

function addon:GetSpec(useGlobal)
	local name
	
	if useGlobal then
		local unit = addon:GetUnitByGUID(addon.guid)

		if unit and UnitLevel(unit) >= 10 then
			name = select(2, GetSpecializationInfoByID(GetInspectSpecialization(unit)))
		end
	else
		if UnitLevel("player") >= 10 then
			name = select(2, GetSpecializationInfo(GetSpecialization()))
		end
	end

	return name or "None"
end
