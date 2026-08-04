SWEP.Base = 'salat_base' -- base

SWEP.PrintName = "Musket"
SWEP.Author = "Zgrad"
SWEP.Instructions = "Uses 12 gauge somehow."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/musketicon.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 85
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/zgrad/musket/flintlock_longgun.ogg"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 105 / 25
SWEP.ReloadTime = 4
SWEP.ReloadSound = "weapons/zgrad/musket/pour.ogg"
SWEP.ShootWait = 0.12

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

------------------------------------------

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "ar2"
SWEP.TwoHands = true

------------------------------------------

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/weapons/v_jmod_musket.mdl"
SWEP.WorldModel = "models/weapons/w_jmod_musket.mdl"

SWEP.addPos = Vector( -43, 2, 1 )
SWEP.addAng = Angle( .05, 179.9, 87.5 )
SWEP.SightPos = Vector( 5, 1.5, 2.8 )

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle( 40, math.Rand( -1.3, 1.3 ), 0 )
end