
SWEP.Base = "salat_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("USP")
	SWEP.Author = "Homograd"
	SWEP.Instructions = language.GetPhrase("Civil protection unit's primary weapon.")
	SWEP.Category = language.GetPhrase("HL3")
	SWEP.IconOverride = "materials/items_icons/hl3uspicon.png"
end

SWEP.WepSelectIcon = "pwb/sprites/glock17"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 5
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/pistol/pistol_fire3.wav"
SWEP.Primary.SoundFar = "weapons/pistol/pistol_reload1.wav"
SWEP.Primary.Force = 20
SWEP.ReloadTime = 1
SWEP.ShootWait = 0

SWEP.RecoilIntensity = 40
SWEP.RecoilUpperIntensity = 15

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "pistol"

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.ViewModel = "models/weapons/w_hl2_usp/w_hl2_usp.mdl"
SWEP.WorldModel = "models/weapons/w_hl2_usp/w_hl2_usp.mdl"

SWEP.addAng = Angle(.4, 1, 0)
SWEP.addPos = Vector(0, -2, -0.8)

SWEP.SightPos = Vector(-22, .6, -0.8)


--if FOR NORMAL HOMIGRAD 
--SWEP.Primary.Ammo = "9x19 mm Parabellum"
--SWEP.Primary.Damage = 30
--SWEP.Category = language.GetPhrase("hg.category.weapons")
