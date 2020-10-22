local width = 108
local height = 25
local state = 1
local xpos = 0
local ypos = -133
local covenant = "none" -- (none,nec,ven,kyr,fae)
local border = "classic" -- (classic, shadowlands)

---

if border == "shadowlands" then
	bgPath = "Interface\\Tooltips\\UI-Tooltip-Background-Maw"
	edgePath = "Interface\\Tooltips\\UI-Tooltip-Border-Maw"
	ypos = -130
else
	bgPath = "Interface\\Tooltips\\UI-Tooltip-Background"
	edgePath = "Interface\\Tooltips\\UI-Tooltip-Border"
	ypos = -133
end

if covenant == "nec" then
	bdr,bdg,bdb,bda = 0.7,0.9,0.7,1	--border r,g,b,a
	bkr,bkg,bkb,bka = 0.2,0.4,0.2,1	--background r,g,b,a
elseif covenant == "ven" then
	bdr,bdg,bdb,bda = 1.0,0.5,0.4,1
	bkr,bkg,bkb,bka = 0.2,0.1,0.1,1
elseif covenant == "kyr" then
	bdr,bdg,bdb,bda = 0.7,0.8,1.0,1
	bkr,bkg,bkb,bka = 0.3,0.4,0.9,1
elseif covenant == "fae" then
	bdr,bdg,bdb,bda = 0.6,0.5,0.9,1
	bkr,bkg,bkb,bka = 0.3,0.1,0.3,1
else
	bdr,bdg,bdb,bda = 0.15,0.15,0.15,1
	bkr,bkg,bkb,bka = 0.15,0.15,0.15,1
end

local _,class = UnitClass("player")
local auraName, unit, filter = "Ignore Pain","player","HELPFUL"
local amount, remaining = 0

if class == "WARRIOR" then r,g,b = 1,0.6,0.1 else r,g,b = 0,0,1 end

--local f = CreateFrame("Frame","KabShieldBar",UIParent)
local f = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
--f:SetFrameStrata("LOW")
f:EnableMouse(false)
f:EnableMouseWheel(false)
f:SetSize(width,height)
f:SetPoint("CENTER",xpos,ypos)

f:SetBackdrop({ bgFile=bgPath,
				edgeFile=edgePath,
				tile=false,
				edgeSize=16,
				insets={left=3,right=3,top=3,bottom=3}})

f:SetBackdropColor(bkr,bkg,bkb,bka)
f:SetBackdropBorderColor(bdr,bdg,bdb,bda)


f.bar = f:CreateTexture(nil,"BACKGROUND",nil,1)
f.bar:SetAlpha(0)
f.bar:SetHeight(f:GetHeight()-6)
f.bar:SetPoint("LEFT",3,0)
f.bar:SetTexture("Interface\\TargetingFrame\\BarFill2")
f.bar:SetWidth(120)
f.bar:SetVertexColor(r,g,b)

f.text = f:CreateFontString(nil,"ARTWORK")
f.text:SetPoint("CENTER")
f.text:SetFont("FONTS\\FRIZQT__.TTF", 12, "OUTLINE")

f:SetAlpha(0)
f.elapsed = 0.10

local function clearBar()
	f:SetAlpha(0)
	--f.bar:SetAlpha(0)
	--f.bar:SetWidth(0)
	--f.text:SetText(format("%.0fk",(0)))
end

local function hideFrame()
	f:SetAlpha(0)
	state = 0
end

local function showFrame()
	--f:SetAlpha(1)
	state = 1
end

f:SetScript("OnUpdate", function(self, elapsed)
	if state == 0 then return end
	self.elapsed = self.elapsed - elapsed
	if self.elapsed > 0 then return end
	self.elapsed = 0.10
--print(GetTime())
-- name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll, timeMod, ... = AuraUtil.FindAuraByName(auraName, unit, filter)
	local name, _, _, _, duration, expirationTime, _, _, _, _, _, _, _, _, _,v1 = AuraUtil.FindAuraByName(auraName, unit, filter)

	if name == nil then
		clearBar()
	else
		amount = v1/1000
		remaining = (expirationTime - GetTime())
		f.bar:SetWidth(remaining*(width-6)/duration)
		f.text:SetText(format("%.0fk",(amount)))
		f:SetAlpha(1)
		f.bar:SetAlpha(1)
	end
end)

f:SetScript("OnEvent", function(self, event, name, ...)
	clearBar()
	--print("Dead shieldbar")
end)

PlayerFrame:HookScript('OnHide', hideFrame)
PlayerFrame:HookScript('OnShow', showFrame)
f:RegisterEvent("PLAYER_DEAD")
