-- Simulate SavedVariables arriving after TOC scripts, before ADDON_LOADED.
dofile("tests/mock.lua")
MoveAnythingDB=nil
local toc=assert(io.open("MoveAnything/MoveAnything.toc","r"))
for line in toc:lines() do
 local _,_,file=string.find(line,"^([%w_]+%.lua)%s*$")
 if file then assert(loadfile("MoveAnything/"..file))() end
end
toc:close()
MoveAnythingDB={profiles={Default={PlayerFrame={x=100,y=120,scale=1.3,hidden=true}}},
 mode={},custom={UIParent=true},settings={language="ko"}}
fire("ADDON_LOADED","MoveAnything");fire("PLAYER_ENTERING_WORLD")
local A=MoveAnything
assert(A.language=="ko" and A.db.settings.language=="ko")
assert(not A.db.custom.UIParent and UIParent:IsShown())
near(PlayerFrame:GetScale(),1.3);assert(not PlayerFrame:IsShown())
A.ui.frame:Show()
assert(MoveAnythingOptionsDone:GetText()==MoveAnything_Locales.ko.Close)
assert(A.ui.rows[1].label:GetFont()==A.FontPath())
-- A new language must be followed even after the layout settling window is over.
A.SetLanguage("auto");TOOLTIP_LANGUAGE="fr";tick(12)
assert(A.language=="fr")
TOOLTIP_LANGUAGE="ja";tick(6);assert(A.language=="ja")
A.SetLanguage("de");TOOLTIP_LANGUAGE="zh";tick(6);assert(A.language=="de")
A.ResetAll();assert(not next(A.profile));near(PlayerFrame:GetScale(),1);assert(PlayerFrame:IsShown())
print("PASS cold saved-variable startup, saved fonts/layout/visibility, and late automatic language changes")
