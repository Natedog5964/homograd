
SWEP.Base = 'salat_base' -- base

SWEP.PrintName = "Flintlock"
SWEP.Author = "Zgrad"
SWEP.Instructions = "Where the HELL did you find this?/nUses 12 gauge somehow."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/flintlockicon.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 11
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 60
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/tfa_ins2/doublebarrel_sawnoff/doublebarrelsawn_fire.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 105 / 40
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12

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

SWEP.ViewModel = "models/zgrad/flintlock/flintlock.mdl"
SWEP.WorldModel = "models/zgrad/flintlock/flintlock.mdl"

SWEP.addPos = Vector(-18,0,0) -- shamanskie to4ki
SWEP.addAng = Angle(0,180,90)

SWEP.dwmModeScale = 0.8
SWEP.dwmForward = 10
SWEP.dwmRight = 2
SWEP.dwmUp = -3

SWEP.dwmAUp = 180
SWEP.dwmARight = 0
SWEP.dwmAForward = 180
SWEP.SightPos = Vector(20,-0.26,1.67)
--SWEP.vbwPos = Vector(7, -10, -6)
function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(20,math.Rand(-1.5,1.5),0)
end
