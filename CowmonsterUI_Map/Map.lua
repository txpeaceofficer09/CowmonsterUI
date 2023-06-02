local f = CreateFrame("ScrollFrame", "MapFrame", UIParent)
CreateFrame("Frame", "MMBF", UIParent)
MMBF:SetSize(50, 50)
MMBF:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
MMBF:Show()

f:EnableKeyboard(false)
f:EnableMouse(true)
f:EnableMouseWheel(true)

--f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 20)
--f:SetPoint("BOTTOMLEFT", ActionBar2, "BOTTOMRIGHT", 4, -2)
--f:SetHeight(150)
f:SetAllPoints(TabParent)
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

CreateTab(MapFrame)

local sc = CreateFrame("Frame", "MapFrameSC", MapFrame)

for i = 1, 12, 1 do
	local t = sc:CreateTexture("MapFrameTexture"..i, "ARTWORK")

	t:SetSize(256, 256)

	if i == 1 then
		t:SetPoint("TOPLEFT", MapFrameSC, "TOPLEFT", 0, 0)
	elseif i == 5 then
		t:SetPoint("TOPLEFT", MapFrameTexture1, "BOTTOMLEFT", 0, 0)
	elseif i == 9 then
		t:SetPoint("TOPLEFT", MapFrameTexture5, "BOTTOMLEFT", 0, 0)
	else
		t:SetPoint("LEFT", _G["MapFrameTexture"..(i-1)], "RIGHT", 0, 0)
	end

	t:Show()
end

sc:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )
sc:Show()

f:Hide()

--CreateFrame("Frame", "MapFlag1", MapFrameSC, "WorldMapFlagTemplate", 1)
--CreateFrame("Frame", "MapFlag2", MapFrameSC, "WorldMapFlagTemplate", 2)
--CreateFrame("Frame", "MapCorpse", MapFrameSC, "WorldMapCorpseTemplate")
--CreateFrame("Frame", "MapDeathRelease", MapFrameSC, "WorldMapCorpseTemplate")

--local mMap = CreateFrame("Minimap", "mMap", MapFrame)
--mMap:SetSize(150, 150)
--mMap:SetPoint("CENTER", MapFrame, "CENTER", 0, 0)
--mMap:Show()

--CreateFrame("Button", "LFGFrame", MapFrame, "EyeTemplate")
--LFGFrame:SetPoint("TOPRIGHT", MapFrame, "TOPRIGHT", -5, -5)
--LFGFrame:SetAlpha(0.7)
--LFGFrame:SetSize(32, 32)
--LFGFrame:RegisterForClicks("AnyUp")
--LFGFrame:SetScript("OnEnter", MiniMapLFGFrame_OnEnter)
--LFGFrame:SetScript("OnClick", MiniMapLFGFrame_OnClick)
--LFGFrame:SetScript("OnLeave", MiniMapLFGFrame_OnLeave)

--function MiniMapLFG_UpdateIsShown()
--	local mode, submode = GetLFGMode();
--	if ( mode ) then
--		LFGFrame:Show();
--		if ( mode == "queued" or mode == "listed" or mode == "rolecheck" ) then
--			EyeTemplate_StartAnimating(LFGFrame);
--		else
--			EyeTemplate_StopAnimating(LFGFrame);
--		end
--	else
--		LFGFrame:Hide();
--	end
--end

--function MiniMapLFGFrame_OnClick(self, button)
--	local mode, submode = GetLFGMode();
--	if ( button == "RightButton" or mode == "lfgparty" or mode == "abandonedInDungeon") then
--		--Display dropdown
--		PlaySound("igMainMenuOpen");
--		--Weird hack so that the popup isn't under the queued status window (bug 184001)
--		local yOffset;
--		if ( mode == "queued" ) then
--			MiniMapLFGFrameDropDown.point = "BOTTOMRIGHT";
--			MiniMapLFGFrameDropDown.relativePoint = "TOPLEFT";
--			yOffset = 0;
--		else
--			MiniMapLFGFrameDropDown.point = nil;
--			MiniMapLFGFrameDropDown.relativePoint = nil;
--			yOffset = -5;
--		end
--		ToggleDropDownMenu(1, nil, MiniMapLFGFrameDropDown, "LFGFrame", 0, yOffset);
--	elseif ( mode == "proposal" ) then
--		if ( not LFDDungeonReadyPopup:IsShown() ) then
--			PlaySound("igCharacterInfoTab");
--			StaticPopupSpecial_Show(LFDDungeonReadyPopup);
--		end
--	elseif ( mode == "queued" or mode == "rolecheck" ) then
--		ToggleLFDParentFrame();
--	elseif ( mode == "listed" ) then
--		ToggleLFRParentFrame();
--	end
--end

--function MiniMapLFGFrame_OnEnter(self)
--	local mode, submode = GetLFGMode();
--	if ( mode == "queued" ) then
--		LFDSearchStatus:SetParent(UIParent)
--		LFDSearchStatus:ClearAllPoints()
--		LFDSearchStatus:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -25, 200)
--		LFDSearchStatus:Show();
--	elseif ( mode == "proposal" ) then
--		GameTooltip:SetOwner(self);
--		GameTooltip:SetText(LOOKING_FOR_DUNGEON);
--		GameTooltip:AddLine(DUNGEON_GROUP_FOUND_TOOLTIP, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
--		GameTooltip:AddLine(" ");
--		GameTooltip:AddLine(CLICK_HERE_FOR_MORE_INFO, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
--		GameTooltip:Show();
--	elseif ( mode == "rolecheck" ) then
--		GameTooltip:SetOwner(self);
--		GameTooltip:SetText(LOOKING_FOR_DUNGEON);
--		GameTooltip:AddLine(ROLE_CHECK_IN_PROGRESS_TOOLTIP, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
--		GameTooltip:Show();
--	elseif ( mode == "listed" ) then
--		GameTooltip:SetOwner(self);
--		GameTooltip:SetText(LOOKING_FOR_RAID);
--		GameTooltip:AddLine(YOU_ARE_LISTED_IN_LFR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
--		GameTooltip:Show();
--	elseif ( mode == "lfgparty" ) then
--		GameTooltip:SetOwner(self);
--		GameTooltip:SetText(LOOKING_FOR_DUNGEON);
--		GameTooltip:AddLine(YOU_ARE_IN_DUNGEON_GROUP, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
--		GameTooltip:Show();
--	end
--end

function MoveMinimapButtons()
	local frames = {}
	local kids = {Minimap:GetChildren()}

	local hideThese = {"MinimapBackdrop", "TimeManagerClockButton", "MinimapZoomOut", "MinimapZoomIn", "MiniMapWorldMapButton", "MinimapZoneTextButton"}

	for k, v in pairs(hideThese) do
		if _G[v] then _G[v]:Hide() end
	end

	for k, v in pairs(kids) do
		if v:GetName() == "GuildInstanceDifficulty" or v:GetName() == "MiniMapInstanceDifficulty" then
			v:SetParent(MapFrame)
			v:SetFrameLevel(MapFrameSC:GetFrameLevel()+2)
			v:SetPoint("TOPLEFT", MapFrame, "TOPLEFT", 0, 0)
		elseif tContains(hideThese, v:GetName()) then
			v:Hide()
		elseif v:GetName() ~= "MiniMapTracking" then
			tinsert(frames, v:GetName())			
		end
	end

	kids = {MinimapCluster:GetChildren()}

	for k, v in pairs(kids) do
		if v:GetName() == "GuildInstanceDifficulty" or v:GetName() == "MiniMapInstanceDifficulty" then
			v:SetParent(MapFrame)
			v:SetFrameLevel(MapFrameSC:GetFrameLevel()+2)
			v:SetPoint("TOPLEFT", MapFrame, "TOPLEFT", 0, 0)
		elseif tContains(hideThese, v:GetName()) then
			v:Hide()
		else
			tinsert(frames, v:GetName())
		end
	end

	kids = {MinimapBackdrop:GetChildren()}

	for k, v in pairs(kids) do
		if v:GetName() == "GuildInstanceDifficulty" or v:GetName() == "MiniMapInstanceDifficulty" then
			v:SetParent(MapFrame)
			v:SetFrameLevel(MapFrameSC:GetFrameLevel()+2)
			v:SetPoint("TOPLEFT", MapFrame, "TOPLEFT", 0, 0)
		elseif tContains(hideThese, v:GetName()) then
			v:Hide()
		else
			tinsert(frames, v:GetName())
		end
	end

	local sortTbl = {"GameTimeFrame", "MiniMapTrackingButton"}

	for k, v in pairs(frames) do
		if tContains(sortTbl, v) then
			-- Do nothing the frame is already there.
		elseif _G[v]:IsVisible() then
			tinsert(sortTbl, 3, v)
		else
			tinsert(sortTbl, v)
		end
	end

	for k, v in pairs(sortTbl) do
		local frame = _G[v]

		frame:SetParent(MMBF)
		frame:ClearAllPoints()

		if k == 1 then
			frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
		else
			frame:SetPoint("TOP", _G[sortTbl[(k-1)]], "BOTTOM", 0, 0)
		end
	end

	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetParent(UIParent)
	MiniMapTracking:SetAllPoints(MiniMapTrackingButton)

	WatchFrame:SetParent(UIParent)
	WatchFrame:ClearAllPoints()
	WatchFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -50, -200)
end

function MapFrame_UpdateTextures()
	local mapFileName, textureHeight, textureWidth = GetMapInfo()
	local dungeonLevel = GetCurrentMapDungeonLevel()

	if DungeonUsesTerrainMap() then dungeonLevel = dungeonLevel - 1 end

	if not mapFileName then
		if GetCurrentMapContinent() == WORLDMAP_COSMIC_ID then
			mapFileName = "Cosmic"
		else
			mapFileName = "World"
		end
	end

	for i=1, GetNumberOfDetailTiles(), 1 do
		if dungeonLevel > 0 then
			_G["MapFrameTexture"..i]:SetTexture("Interface\\WorldMap\\"..mapFileName.."\\"..mapFileName..dungeonLevel.."_"..i)
		else
			_G["MapFrameTexture"..i]:SetTexture("Interface\\WorldMap\\"..mapFileName.."\\"..mapFileName..i)
		end
	end

	if IsInCity() or IsInInstance() then
	-- if IsResting() or IsInInstance() then
		Minimap:SetZoom(3)
	else
		Minimap:SetZoom(1)
	end
end

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		Minimap:SetParent("MapFrame")
		Minimap:SetPoint("CENTER", MapFrame, "CENTER", 0, 0)
		Minimap:SetFrameLevel(MapFrameSC:GetFrameLevel()+2)
		Minimap:SetSize(150, 150)
		TimeManagerClockButton:Hide()
		MinimapCluster:ClearAllPoints()
		MinimapCluster:SetPoint("TOPLEFT", UIParent, "TOPRIGHT", 0, 0)
		MinimapCluster:Hide()
		MapFrameSC:SetSize(1002, 668)
		self:SetScrollChild(MapFrameSC)
		MapFrameTab:Click()
		MoveMinimapButtons()
		Minimap:SetMaskTexture("Interface\\AddOns\\CowmonsterUI_Map\\Mask.blp")
	elseif event == "WORLD_MAP_UPDATE" or event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "WORLD_MAP_NAME_UPDATE" then
		MapFrame_UpdateTextures()
	elseif event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED" then
		WorldMapFrame_UpdateUnits("MapRaid", "MapParty");
	end	
end

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("VARIABLES_LOADED")

f:RegisterEvent("WORLD_MAP_UPDATE");
f:RegisterEvent("ZONE_CHANGED")
f:RegisterEvent("ZONE_CHANGED_INDOORS")

f:RegisterEvent("CLOSE_WORLD_MAP");
f:RegisterEvent("WORLD_MAP_NAME_UPDATE");
f:RegisterEvent("PARTY_MEMBERS_CHANGED");
f:RegisterEvent("RAID_ROSTER_UPDATE");
--f:RegisterEvent("DISPLAY_SIZE_CHANGED");
--f:RegisterEvent("QUEST_LOG_UPDATE");
--f:RegisterEvent("QUEST_POI_UPDATE");
--f:RegisterEvent("SKILL_LINES_CHANGED");
--f:RegisterEvent("REQUEST_CEMETERY_LIST_RESPONSE");

--local function MapUnitFrame_Update(self, elapsed)
--	self.timer = (self.timer or 0) + elapsed
--
--	if self.timer >= 2 then
--		local unit = strsub(self:GetName(), 4)
--
--		if strsub(unit, 1, 4) == "raid" then
--			if UnitName(unit) then
--				local unitX, unitY = GetPlayerMapPosition(unit)
--
--				if unitX > 0 and unitY > 0 then
--					self:SetPosition("CENTER", MapFrameSC, "TOPLEFT", unitX*(1002*0.5), unitY*(668*0.5))
--					self:Show()
--				end
--			else
--				self:Hide()
--			end
--		else
--			if UnitName(unit) then
--				local unitX, unitY = GetPlayerMapPosition(unit)
--
--				if unitX > 0 and unitY > 0 then
--					self:SetPosition("CENTER", MapFrameSC, "TOPLEFT", unitX*(1002*0.5), unitY*(668*0.5))
--				end
--			else
--				self:Hide()
--			end
--		end
--
--		self.timer = 0
--	end
--end

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", function(self, elapsed)
	local unitX, unitY = GetPlayerMapPosition("player")

	if unitX == 0 and unitY == 0 and IsInInstance() then
		MapFrame_UpdateTextures()
	end

	if unitX == 0 and unitY == 0 and Minimap:IsVisible() then
			Minimap:Hide()
	elseif unitX > 0 and unitY > 0 and not Minimap:IsVisible() then
		Minimap:Show()
	end

	self:SetHorizontalScroll(((unitX*(MapFrameSC:GetWidth()*MapFrameSC:GetScale()))-(MapFrame:GetWidth()/2))/MapFrameSC:GetScale())
	self:SetVerticalScroll(((unitY*(MapFrameSC:GetHeight()*MapFrameSC:GetScale()))-(MapFrame:GetHeight()/2))/MapFrameSC:GetScale())
end)

f:SetScript("OnMouseWheel", function(self, delta)
	if delta > 0 and MapFrameSC:GetScale() < 1 then
		MapFrameSC:SetScale(MapFrameSC:GetScale()+0.01)
	elseif MapFrameSC:GetScale() > 0.5 then
		MapFrameSC:SetScale(MapFrameSC:GetScale()-0.01)
	end
	Minimap:SetScale(MapFrameSC:GetScale())
end)

f:Hide()

MMBF:SetScript("OnUpdate", function(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		local kids = {self:GetChildren()}
		local frames = {"GameTimeFrame", "MiniMapTrackingButton"}

		for k, v in pairs(kids) do
			if not tContains(frames, v:GetName()) and v:IsVisible() then
				tinsert(frames, 3, v:GetName())
			elseif not tContains(frames, v:GetName()) and not v:IsVisible() then
				tinsert(frames, v:GetName())
			end
		end

		for k, v in pairs(frames) do
			local frame = _G[v]

			if k == 1 then
				frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
			else
				frame:SetPoint("TOP", _G[frames[(k-1)]], "BOTTOM", 0, 0)
			end
		end

		WatchFrame:SetParent(UIParent)
		WatchFrame:ClearAllPoints()
		WatchFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -50, -200)

		self.timer = 0
	end
end)
