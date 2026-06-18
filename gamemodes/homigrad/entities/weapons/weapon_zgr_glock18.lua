SWEP.Base = 'salat_base' -- base

SWEP.PrintName = "Glock 18"
SWEP.Author = "Zgrad"
SWEP.Instructions = "FULL AUTO BABY!\nUses 9mm ammunition."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/glock18icon.png"
SWEP.WepSelectIcon = "pwb/sprites/glock17"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 17
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/hndg_glock17/glock_fire_01.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 90 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.05

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

------------------------------------------

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "pistol"

------------------------------------------

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/pwb/weapons/w_glock17.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_glock17.mdl"

SWEP.dwsPos = Vector(13, 13, 5)
SWEP.dwsItemPos = Vector(10, -1, -2)

SWEP.addAng = Angle(0.4, 0, 0)
SWEP.addPos = Vector(0, 0, -1)
SWEP.SightPos = Vector(-23,0.1,-1.02)
--SWEP.vbwPos = Vector(7, -10, -6)

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(0.5,math.Rand(-0.25,0.25),0)
end

