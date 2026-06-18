SWEP.Base = 'salat_base' -- base

SWEP.PrintName = "PPSh-41"
SWEP.Author = "Zgrad"
SWEP.Instructions = "Soviet submachine gun.\nUses 9mm ammunition."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/cppsh41icon.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 12
SWEP.Primary.Spread = 5
SWEP.Primary.Sound = "zcitysnd/sound/weapons/sterling/sterling_fp.wav"
SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/sterling/sterling_dist.wav"
SWEP.Primary.Force = 320 / 3
SWEP.Primary.Recoil = 10
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
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

SWEP.ViewModel = "models/zgrad/ppsh/w_smg_ppsh.mdl"
SWEP.WorldModel = "models/zgrad/ppsh/w_smg_ppsh.mdl"

SWEP.vbwPos = Vector(4,-3,2)
SWEP.vbwAng = Angle(90,-30,0)

SWEP.addAng = Angle(-0.25,1,6)

SWEP.SightPos = Vector(-30,0.5,-0.05)
