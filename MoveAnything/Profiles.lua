local A = MoveAnything;
local L, LF, Print, DeepCopy = A.L, A.LF, A.Print, A.DeepCopy;
local ResetEntry, RefreshPositions, TouchedNames = A.ResetEntry, A.RefreshPositions, A.TouchedNames;

-- Layouts: whom the layout in use belongs to, chosen in the window ("Layout for").
--   nil      all heroes share the "Default" layout
--   "class"  every hero of this class shares one ("Class: Warrior")
--   "hero"   this hero alone, told apart by name and class, since one name can be used for
--            every class ("Hero: Kodfod (Warrior)")
-- The choice itself is kept for each hero (name and class). The client's realm name is the zone
-- here, so it plays no part.

local function HeroName() return UnitName("player") or "Unknown"; end

-- The class as a key that doesn't change with the game's language ("Warrior").
local function ClassName()
	local _, token = UnitClass("player");
	token = token or (AZS_ZONE and AZS_ZONE.class) or "unknown";
	return string.upper(string.sub(token, 1, 1)) .. string.lower(string.sub(token, 2));
end

-- The class as the game names it, for the window.
local function ClassLabel()
	return UnitClass("player") or ClassName();
end

local function Identity() return HeroName() .. " (" .. ClassName() .. ")"; end

local function KeyFor(mode)
	if ( mode == "class" ) then return "Class: " .. ClassName(); end
	if ( mode == "hero" ) then return "Hero: " .. Identity(); end
	return "Default";
end

local function ProfileKey() return A.profileKey; end
local function LayoutMode() return A.db and A.db.mode[Identity()]; end

-- Earlier versions kept one layout per hero name ("Hero: Kodfod"): it becomes this hero's.
local function Migrate()
	local old = A.db.perHero;
	if ( not old ) then return; end
	local name = HeroName();
	if ( old[name] and not A.db.mode[Identity()] ) then
		A.db.mode[Identity()] = "hero";
		local from, to = "Hero: " .. name, KeyFor("hero");
		if ( A.db.profiles[from] and not A.db.profiles[to] ) then
			A.db.profiles[to] = A.db.profiles[from];
			A.db.profiles[from] = nil;
		end
	end
	A.db.perHero = nil;
end

local function SelectProfile()
	Migrate();
	A.profileKey = KeyFor(LayoutMode());
	A.db.profiles[A.profileKey] = A.db.profiles[A.profileKey] or {};
	A.profile = A.db.profiles[A.profileKey];
end

-- Hand everything back, switch layouts, then lay the new one out.
local function SwitchTo(apply)
	for _, name in ipairs(TouchedNames()) do ResetEntry(name, true); end
	apply();
	SelectProfile();
	RefreshPositions();
	if ( A.UpdateOptions ) then A.UpdateOptions(); end
end

local function SetLayoutMode(mode)
	if ( mode ~= "class" and mode ~= "hero" ) then mode = nil; end
	if ( mode == LayoutMode() ) then return; end
	SwitchTo(function()
		local key = KeyFor(mode);
		-- A new class or hero layout starts as a copy of the one in use.
		if ( mode and not A.db.profiles[key] ) then A.db.profiles[key] = DeepCopy(A.profile); end
		A.db.mode[Identity()] = mode;
	end);
	Print(LF("The layout \"%s\" is in use now.", A.profileKey));
end

local function CopyProfile(from)
	if ( not A.db.profiles[from] ) then
		Print(LF("There is no layout \"%s\". Type /movelist to see the layouts.", from));
		return;
	end
	if ( from == A.profileKey ) then return; end
	SwitchTo(function() A.db.profiles[A.profileKey] = DeepCopy(A.db.profiles[from]); end);
	Print(LF("The layout \"%s\" is copied into \"%s\".", from, A.profileKey));
end

local function DeleteProfile(key)
	if ( not A.db.profiles[key] ) then
		Print(LF("There is no layout \"%s\". Type /movelist to see the layouts.", key));
	elseif ( key == A.profileKey ) then
		Print(LF("The layout \"%s\" is in use. Push Reset All to clear it.", key));
	else
		A.db.profiles[key] = nil;
		Print(LF("The layout \"%s\" is deleted.", key));
	end
end

local function ListProfiles()
	Print(LF("The saved layouts (in use: %s):", A.profileKey));
	for key, t in pairs(A.db.profiles) do
		local n = 0;
		for _ in pairs(t) do n = n + 1; end
		DEFAULT_CHAT_FRAME:AddMessage("   " .. LF("%s: %d frames", key, n));
	end
end

A.HeroName = HeroName;
A.ClassLabel = ClassLabel;
A.ProfileKey = ProfileKey;
A.LayoutMode = LayoutMode;
A.SelectProfile = SelectProfile;
A.SetLayoutMode = SetLayoutMode;
A.CopyProfile = CopyProfile;
A.DeleteProfile = DeleteProfile;
A.ListProfiles = ListProfiles;
