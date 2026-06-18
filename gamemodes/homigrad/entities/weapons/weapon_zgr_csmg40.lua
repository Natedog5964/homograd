SWEP.Base = 'salat_base' -- base

SWEP.PrintName = "MP40"
SWEP.Author = "Zgrad"
SWEP.Instructions = "WWII German submachine gun.\nUses 9mm ammunition."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/csmg40icon.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 20
SWEP.Primary.Spread = 5
SWEP.Primary.Sound = "zcitysnd/sound/weapons/mp40/mp40_fp.wav"
SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/mp40/mp40_dist.wav"
SWEP.Primary.Force = 85 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.1
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

SWEP.ViewModel = "models/zgrad/mp40/w_grub_mp40.mdl"
SWEP.WorldModel = "models/zgrad/mp40/w_grub_mp40.mdl"

SWEP.vbwPos = Vector(-4,-3.7,2)
SWEP.vbwAng = Angle(2,-30,0)

SWEP.addAng = Angle(0,1.5,5)

SWEP.SightPos = Vector(-37,0.3,0)
