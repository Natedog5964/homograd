SWEP.Base = 'salat_base' -- base

SWEP.PrintName = "Mauser K98"
SWEP.Author = "Zgrad"
SWEP.Instructions = "WWII German bolt-action rifle.\nUses 7.62x39 ammunition."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/ck98icon.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 60
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/rifle_fnfal/fnfal_fire_01.wav"
SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/ak47/ak47_dist.wav"
SWEP.Primary.Force = 240 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 1.5
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

------------------------------------------

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/zgrad/kar98k/w_kar98k.mdl"
SWEP.WorldModel = "models/zgrad/kar98k/w_kar98k.mdl"

SWEP.vbwPos = Vector(5,-6,-6)

SWEP.addAng = Angle(0,-0.2,0)
SWEP.addPos = Vector(0,0,0)

SWEP.SightPos = Vector(-32,1.6,0.04)
