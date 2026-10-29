local A = MoveAnything;
local L = A.L;

-- The frames the window lists before any the player adds.
-- { "FrameName", "Label" }, a { sep = "Heading" } between groups, and { hud = "part" } for the
-- parts of the game's own HUD, which the game draws outside the Lua UI: they can only be shown
-- or hidden (AZS_SetHudShown), never moved.
-- Names that start with MoveAnything are the addon's own stand-ins (tooltip spot, button rows)
-- from Spots.lua. A stock frame that this client does not have is left out of the list, and so
-- are the stock frames the game never uses (mail, tracking, durability, combo points, breath,
-- loot rolls, bags, loot and merchant windows, pet and stance bars, extra action bars, casting bar).
-- Flags: noScale (no resize handles), noHide (no Hide box), wh (handles change width/height),
-- minW / minH (the overlay is drawn at least this big, for frames with no size of their own),
-- widthOf (the frame to take the width of when the frame reports none).
local FRAME_LIST = {
	{ sep = L("Unit frames") },
	{ "PlayerFrame", L("Player") },
	{ "TargetFrame", L("Target") },
	{ "PetFrame", L("Pet") },
	{ "PartyMemberFrame1", L("Party member 1") },
	{ "PartyMemberFrame2", L("Party member 2") },
	{ "PartyMemberFrame3", L("Party member 3") },
	{ "PartyMemberFrame4", L("Party member 4") },

	{ sep = L("Main bar") },
	{ "MainMenuBar", L("Main bar (whole)") },
	{ "MainMenuBarArtFrame", L("Main bar art and buttons") },
	{ "MainMenuExpBar", L("Experience bar") },
	{ "MainMenuBarMaxLevelBar", L("Max level bar") },
	{ "MainMenuBarLeftEndCap", L("Left gryphon"), noScale = true },
	{ "MainMenuBarRightEndCap", L("Right gryphon"), noScale = true },

	{ sep = L("Button rows") },
	{ "MoveAnythingActionBar", L("Spell buttons") },
	{ "MoveAnythingActionBarV", L("Spell buttons (vertical)") },
	{ "MoveAnythingMicroBar", L("Character and talent buttons") },
	{ "MoveAnythingMicroBarV", L("Character and talent buttons (vertical)") },

	{ sep = L("Minimap") },
	{ "MinimapCluster", L("Minimap") },
	{ "MinimapZoneTextButton", L("Minimap zone text") },
	{ "MinimapZoomIn", L("Minimap zoom in") },
	{ "MinimapZoomOut", L("Minimap zoom out") },
	{ "GameTimeFrame", L("Day and night clock") },

	{ sep = L("Screen") },
	{ "BuffFrame", L("Buffs") },
	{ "TemporaryEnchantFrame", L("Weapon buffs") },
	{ "MoveAnythingTooltip", L("Tooltip"), noScale = true, noHide = true },
	{ "FramerateLabel", L("Framerate"), noScale = true },
	{ "UIErrorsFrame", L("Error messages") },
	{ "StaticPopup1", L("Popup dialog") },
	-- Hidden until you press Enter, and sized by its anchors to the chat window: it only
	-- moves, and its overlay is drawn at least this big so there is something to grab.
	{ "ChatFrameEditBox", L("Chat input box"), noScale = true, noHide = true, minW = 256, minH = 32, widthOf = "ChatFrame1" },

	{ sep = L("Windows") },
	{ "CharacterFrame", L("Character") },

	{ sep = L("Game HUD (show or hide only)") },
	{ hud = "clock", L("Run clock and next boss") },
	{ hud = "bosses", L("Boss and guardian bars") },
	{ hud = "tally", L("Kills and gold") },
	{ hud = "build", L("Spell and jewelry rows") },
	{ hud = "banners", L("Messages in the middle of the screen") },
	{ hud = "loot", L("Boss loot notice") },
	{ hud = "meter", L("Damage meter") },
	{ hud = "levels", L("Level Up! button") },
	{ hud = "flag", L("Minimap lair flag") },
};

A.FRAME_LIST = FRAME_LIST;
