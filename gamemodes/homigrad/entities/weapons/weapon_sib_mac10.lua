
SWEP.Base = 'salat_base'

SWEP.PrintName = "MAC-10"
SWEP.Author = "Salat"
SWEP.Instructions = "The MAC-10, is a compact, blowback operated machine pistol/submachine gun. Uses 9mm."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/mac10icon.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 15
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/homic_box/mac10/fire01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_sht_far.wav"
SWEP.Primary.Force = 30
SWEP.ReloadTime = 2.2
SWEP.ShootWait = 0.05
SWEP.ReloadSounds = {
    [0.1] = {"weapons/homic_box/mac10/clipout.wav"},
    [0.8] = {"weapons/homic_box/mac10/clipin.wav"},
    [1.2] = {"weapons/homic_box/mac10/boltforward.wav"},
    [1.4] = {"weapons/homic_box/mac10/boltback.wav"},
}
SWEP.TwoHands = true
--SWEP.ShellRotate = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

------------------------------------------

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom	= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/homicbox_weapons/mac10/w_smg_mac10.mdl"
SWEP.WorldModel = "models/homicbox_weapons/mac10/w_smg_mac10.mdl"

SWEP.addPos = Vector(0,0,0) -- Moves Muzzle point Usage: (forward/back,Up/down,Left/right)

SWEP.addAng = Angle(0,-1.4,0) -- Sight Barrel Angle Usage: (Left/right,Up/down,Tilt)

SWEP.SightPos = Vector(-26,2.5,-.05) -- Sight pos, Usage: (forward/back,Up/down,Left/right)
