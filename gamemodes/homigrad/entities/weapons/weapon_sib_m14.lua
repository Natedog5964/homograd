SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "M-14"
SWEP.Author 				= "Salat"
SWEP.Instructions			= "The M14 rifle is an American selective-fire battle rifle chambered for the 7.62×51mm NATO (.308 Winchester) cartridge."
SWEP.Category 				= "HOMO"
SWEP.IconOverride = "materials/items_icons/m14icon.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".308 Winchester"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/homic_box/scar20/fire01.wav"
SWEP.Primary.FarSound = "weapons/homic_box/scar20/distant01.wav"
SWEP.Primary.Force = 25
SWEP.ReloadTime = 2.5
SWEP.ShootWait = 0.15
SWEP.ReloadSounds = {
    [0.1] = {"weapons/homic_box/ssg08/clipout.wav"},
    [1] = {"weapons/homic_box/ssg08/clipin.wav"},
    [2] = {"weapons/homic_box/ssg08/boltforward.wav"},
    [2.4] = {"weapons/homic_box/ssg08/boltback.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_338Mag"
SWEP.ShellRotate = false 

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

SWEP.ViewModel				= "models/homicbox_weapons/m14/w_rif_m14.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/m14/w_rif_m14.mdl"

SWEP.addPos = Vector(0,0,0) -- Moves Muzzle point Usage: (forward/back,Up/down,Left/right)

SWEP.addAng = Angle(0,0,0) -- Sight Barrel Angle Usage: (Left/right,Up/down,Tilt)

SWEP.SightPos = Vector(-40,3,-.17) -- Sight pos, Usage: (forward/back,Up/down,Left/right)
