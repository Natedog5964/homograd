
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Thompson"
SWEP.Author 				= "Salat"
SWEP.Instructions			= "The Thompson REAL. Uses .45 ACP."
SWEP.Category 				= "HOMO"
SWEP.IconOverride = "materials/items_icons/thompsonicon.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".45 acp"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/homic_box/tec9/fire.wav"
SWEP.Primary.FarSound = "weapons/homic_box/tec9/distant.wav"
SWEP.Primary.Force = 25
SWEP.ReloadTime = 1.8
SWEP.ShootWait = 0.05
SWEP.ReloadSounds = {
    [0.1] = {"weapons/homic_box/tec9/boltback.wav"},
    [0.8] = {"weapons/homic_box/tec9/clipout.wav"},
    [1.7] = {"weapons/homic_box/tec9/clipin.wav"},
}
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/homicbox_weapons/thompson/w_thompson.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/thompson/w_thompson.mdl"

SWEP.addPos = Vector(0,-1.7,0) -- Moves Muzzle point Usage: (forward/back,Up/down,Left/right)

SWEP.addAng = Angle(0,-.75,0) -- Sight Barrel Angle Usage: (Left/right,Up/down,Tilt)

SWEP.SightPos = Vector(-27,-.9,-.05) -- Sight pos, Usage: (forward/back,Up/down,Left/right)

--SWEP.Mobility = 1.3 