# MoveAnything! for Azeroth Survivors

MoveAnything! is an addon for Azeroth Survivors. It moves, scales and hides the frames of the interface: the player and target frames, the main bar, the spell buttons, the minimap, the buffs, the tooltip and more. You can also move any frame of another addon.

This addon is based on MoveAnything! by Skrag and Jason for World of Warcraft 1.12. It is rebuilt for the Azeroth Survivors client.

## Install

1. Download the `MoveAnything` zip file from the Releases page.
2. Extract the zip file.
3. Put the `MoveAnything` folder in this folder: `benilla-config/AddOns/`.
4. Start the game. Make sure that the addon is on in the AddOns options.
5. Start a run. The addon loads at the start of the next run.

## Use

Push Escape to open the game menu, then push Edit Mode. Or type `/move`.

The window lists the frames that you can move. Each frame has 3 controls:

- Move: puts a green overlay on the frame.
- Hide: keeps the frame hidden. The game cannot show it again.
- Reset: puts the frame back where the game puts it.

A frame that you changed shows in green.

When the overlay is on a frame:

- Drag the overlay to move the frame.
- Drag a gold handle on an edge or a corner to scale the frame.
- Hold Alt while you drag a handle to change the width or the height instead.
- Push the arrow keys while the cursor is on the overlay to move the frame by 1. Hold Shift to move it by 10.
- Right-click the overlay when you are done. Escape also stops.
- Shift-right-click the overlay to hide its color, so that you can see the frame.

### Button rows

- Spell buttons: the 6 spell buttons and the racial button, in a row or a column.
- Character and talent buttons: in a row or a column.

Use the vertical entry to put the buttons in a column. Reset puts the buttons back on the main bar.

### Move a frame that is not in the list

- Push Pick Frame. Move the cursor on the frame. Left-click to move it. The mouse wheel picks the frame under it. Right-click or Escape stops.
- Or type `/move FrameName`. Frame names are case-sensitive. The bottom of the window shows the name of the frame under the cursor.

The frame then shows in the list under "Your frames".

### The game HUD

The game draws some parts of the screen itself: the run clock, the boss bars, the kills and gold, the spell and jewelry rows, the messages in the middle of the screen, the boss loot notice, the damage meter, the Level Up! button and the minimap lair flag. You can hide these parts, but you cannot move them. This is the same setting as Options > Interface.

## Layouts

"Layout for" at the bottom of the window sets which heroes use the layout:

- All heroes: all heroes and classes use one layout.
- This class: all the heroes of this class use one layout.
- This hero: only this hero uses the layout. A hero is its name and its class, so the same name in another class has its own layout.

A new class or hero layout starts as a copy of the layout in use.

## Commands

| Command | Result |
| --- | --- |
| `/move` | Opens or closes the window. |
| `/move FrameName` | Moves the frame with that name. |
| `/move pick` | Picks a frame on the screen. |
| `/move hide FrameName` | Hides or shows the frame with that name. |
| `/move done` | Stops moving all frames. |
| `/move key <key>` | Sets a key that opens or closes the window. Example: `/move key F7`. |
| `/move key none` | Removes the key. |
| `/move help` | Shows the commands. |
| `/unmove FrameName` | Puts the frame back where the game puts it. |
| `/movelist` | Shows the saved layouts. |
| `/movecopy Name` | Copies a saved layout into the layout in use. |
| `/movedelete Name` | Deletes a saved layout. |

The command `/moveanything` does the same thing as `/move`.

## Change the words of the window

You can change the words that the addon writes. You do not change the game files.

The file `Strings.lua` in the addon folder lists all the words of the addon. The file `Custom.lua` is the file for your changes.

1. Open `Strings.lua`. Find the line with the words that you want to change. Example: `["Reset All"] = "Reset All",`
2. Copy the line into `Custom.lua`, between the two braces.
3. Change the words on the right side of the equals sign. Example: `["Reset All"] = "Reset everything",`
4. Save the file. Start the game again. The addon reads the file when it loads.

Do not change the words on the left side. Keep the codes `%s`, `%d` and `%.2f` in the same order. When you update the addon, keep your `Custom.lua` file.

## Limits

- The game loads addons only in a run. You cannot use the addon from the main menu.
- The Key Bindings page of the game does not show addon key bindings. Use `/move key` to set a key for the window.
- The parts of the HUD that the game draws itself can be hidden, but not moved.

## Saved data

The addon keeps its layouts in this file: `benilla-config/saved/MoveAnything.lua`. Push Reset All two times to put all the frames of the layout in use back where the game puts them.
