SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "M-1911"
SWEP.Author 				= "Israel LOLZ"
SWEP.Instructions			= "The M1911 is a single-action, recoil-operated, semi-automatic pistol chambered for the .45 ACP cartridge."
SWEP.Category 				= "HOMO"
SWEP.IconOverride = "materials/items_icons/m1911icon.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip	= 7
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".45 acp"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/homic_box/cz75/fire01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_sht_far.wav"
SWEP.Primary.Force = 15
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.1
SWEP.ReloadSounds = {
    [0.1] = {"weapons/homic_box/tec9/clipout.wav"},
    [0.8] = {"weapons/homic_box/tec9/clipin.wav"},
    [1.2] = {"weapons/homic_box/tec9/boltforward.wav"},
    [1.4] = {"weapons/homic_box/tec9/boltback.wav"},
}

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot					= 1
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/homicbox_weapons/m1911/w_pist_m1911.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/m1911/w_pist_m1911.mdl"

SWEP.addPos = Vector(0,-4,-.5) -- Moves Muzzle point Usage: (forward/back,Up/down,Left/right)

SWEP.addAng = Angle(0,0,0) -- Sight Barrel Angle Usage: (Left/right,Up/down,Tilt)

SWEP.SightPos = Vector(-27,-2.2,-.6) -- Sight pos, Usage: (forward/back,Up/down,Left/right)