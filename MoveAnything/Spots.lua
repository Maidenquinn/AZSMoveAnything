local A = MoveAnything;
local EffScale, Raw, specials = A.EffScale, A.Raw, A.specials;
local Opt, HasLayout, Lock, Restore, Unlock, ShowFrame, Hook = A.Opt, A.HasLayout, A.Lock, A.Restore, A.Unlock, A.ShowFrame, A.Hook;

-- Stand-ins: the tooltip's spot (a frame that only marks a place) and the button rows.

local function Dummy(name, w, h, point, x, y)
	local f = CreateFrame("Frame", name, UIParent);
	f:SetWidth(w);
	f:SetHeight(h);
	f:SetPoint(point, UIParent, point, x, y);
	return f;
end

------------------------------------------------------------------------------------------------
-- The tooltip: where tooltips go that have no place of their own (the stock bottom right).
------------------------------------------------------------------------------------------------

Dummy("MoveAnythingTooltip", 200, 90, "BOTTOMRIGHT", -(CONTAINER_OFFSET_X or 0) - 13, CONTAINER_OFFSET_Y or 70);
specials.MoveAnythingTooltip = { kind = "dummy" };

Hook("GameTooltip_SetDefaultAnchor", nil, function(tooltip)
	if ( not tooltip or not HasLayout(Opt("MoveAnythingTooltip")) ) then return; end
	local d = MoveAnythingTooltip;
	local cx, cy = d:GetCenter();
	if ( not cx ) then return; end
	-- Grow away from the nearest screen edges.
	local v = (cy > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM";
	local h = (cx > UIParent:GetWidth() / 2) and "RIGHT" or "LEFT";
	tooltip:ClearAllPoints();
	tooltip:SetPoint(v .. h, d, v .. h, 0, 0);
end);

------------------------------------------------------------------------------------------------
-- Button rows: the buttons are gathered into a frame of the addon's, in a row or a column, which
-- is then moved and scaled like any frame. Reset hands them back.
------------------------------------------------------------------------------------------------

local function Names(prefix, list)
	local t = {};
	for _, i in ipairs(list) do table.insert(t, prefix .. i); end
	return t;
end

local function Group(name, pair, vertical, def)
	def.kind, def.pair, def.vertical = "group", pair, vertical;
	specials[name] = def;
end

local ACTION_BUTTONS = Names("ActionButton", { 1, 2, 3, 4, 5, 6, 12 });
local MICRO_BUTTONS = { "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton",
	"QuestLogMicroButton", "SocialsMicroButton", "WorldMapMicroButton", "MainMenuMicroButton",
	"HelpMicroButton" };

Group("MoveAnythingActionBar", "MoveAnythingActionBarV", false, { buttons = ACTION_BUTTONS, gap = 6 });
Group("MoveAnythingActionBarV", "MoveAnythingActionBar", true, { buttons = ACTION_BUTTONS, gap = 6 });
-- Only the micro buttons the game shows (character and talents).
Group("MoveAnythingMicroBar", "MoveAnythingMicroBarV", false, { buttons = MICRO_BUTTONS, gap = -3, shownOnly = true });
Group("MoveAnythingMicroBarV", "MoveAnythingMicroBar", true, { buttons = MICRO_BUTTONS, gap = -22, shownOnly = true });

local function BuildGroup(e)
	if ( e.built ) then return e.frame; end
	local list = {};
	for _, n in ipairs(e.buttons) do
		local b = getglobal(n);
		if ( b and (not e.shownOnly or b:IsShown()) ) then table.insert(list, b); end
	end
	if ( table.getn(list) == 0 ) then return; end
	local first = list[1];
	local c = e.frame;
	if ( not c ) then
		c = CreateFrame("Frame", e.name, UIParent);
		e.frame = c;
	end
	local bw, bh = first:GetWidth(), first:GetHeight();
	local n = table.getn(list);
	if ( e.vertical ) then
		c:SetWidth(bw);
		c:SetHeight(n * bh + (n - 1) * e.gap);
	else
		c:SetWidth(n * bw + (n - 1) * e.gap);
		c:SetHeight(bh);
	end
	-- Start where the first button stands, so nothing jumps.
	Raw(c, "ClearAllPoints")(c);
	if ( first:GetLeft() and first:GetTop() ) then
		local k = EffScale(first) / EffScale(c);
		Raw(c, "SetPoint")(c, "TOPLEFT", UIParent, "BOTTOMLEFT", first:GetLeft() * k, first:GetTop() * k);
	else
		Raw(c, "SetPoint")(c, "CENTER", UIParent, "CENTER", 0, 0);
	end
	-- The row stands in the buttons' own layer, just under them, and each button keeps the level
	-- it had in the main bar: a new frame on UIParent starts at the bottom, under the bar's art,
	-- and taking a new parent can reset a button's level to its parent's.
	local strata, low = first:GetFrameStrata(), nil;
	for _, b in ipairs(list) do
		b.MA_groupStrata, b.MA_groupLevel = b:GetFrameStrata(), b:GetFrameLevel();
		if ( not low or b.MA_groupLevel < low ) then low = b.MA_groupLevel; end
	end
	if ( strata ) then c:SetFrameStrata(strata); end
	c:SetFrameLevel(math.max((low or 1) - 1, 0));
	for i, b in ipairs(list) do
		Lock(b);
		b.MA_groupParent = b:GetParent();
		b:SetParent(c);
		if ( b.MA_groupStrata ) then b:SetFrameStrata(b.MA_groupStrata); end
		b:SetFrameLevel(b.MA_groupLevel);
		b.MA_ClearAllPoints(b);
		if ( e.vertical ) then
			b.MA_SetPoint(b, "TOPLEFT", c, "TOPLEFT", 0, -(i - 1) * (bh + e.gap));
		else
			b.MA_SetPoint(b, "TOPLEFT", c, "TOPLEFT", (i - 1) * (bw + e.gap), 0);
		end
	end
	e.members = list;
	e.built = true;
	c:Show();
	return c;
end

local function UnbuildGroup(e)
	if ( not e.built ) then return; end
	for _, b in ipairs(e.members) do
		if ( b.MA_groupParent ) then b:SetParent(b.MA_groupParent); end
		if ( b.MA_groupStrata ) then b:SetFrameStrata(b.MA_groupStrata); end
		if ( b.MA_groupLevel ) then b:SetFrameLevel(b.MA_groupLevel); end
		b.MA_groupParent, b.MA_groupStrata, b.MA_groupLevel = nil, nil, nil;
		Restore(b);
		Unlock(b);
	end
	local c = e.frame;
	ShowFrame(c);
	Unlock(c);
	c:Hide();
	e.members, e.built = nil, nil;
end

A.BuildGroup = BuildGroup;
A.UnbuildGroup = UnbuildGroup;
