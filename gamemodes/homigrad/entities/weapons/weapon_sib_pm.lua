SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Makarov-NonLethal"
SWEP.Author 				= "Salat"
SWEP.Instructions			= "This PM shoots rubber be careful. Uses .45 Rubber."
SWEP.Category 				= "HOMO"
SWEP.IconOverride = "materials/items_icons/pmicon.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".45 Rubber"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 15
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/homic_box/tec9/fire.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 5
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.1
SWEP.ReloadSounds = {
    [0.1] = {"weapons/homic_box/tec9/clipout.wav"},
    [0.8] = {"weapons/homic_box/tec9/clipin.wav"},
    [1.2] = {"weapons/homic_box/tec9/boltback.wav"},
    [1.4] = {"weapons/homic_box/tec9/boltforward.wav"},
}

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/homicbox_weapons/pm/w_pist_pmt.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/pm/w_pist_pmt.mdl"

SWEP.addPos = Vector(0,0,0) -- Moves Muzzle point Usage: (forward/back,Up/down,Left/right)

SWEP.addAng = Angle(0,-1.1,0) -- Sight Barrel Angle Usage: (Left/right,Up/down,Tilt)

SWEP.SightPos = Vector(-21,1,.05) -- Sight pos, Usage: (forward/back,Up/down,Left/right)