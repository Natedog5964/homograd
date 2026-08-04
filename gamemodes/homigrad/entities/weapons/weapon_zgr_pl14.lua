SWEP.Base = 'salat_base' -- base

SWEP.PrintName = "PL-14"
SWEP.Instructions = "Ruskie Gun"
SWEP.Category = "HOMO"
SWEP.WepSelectIcon = "entities/weapon_insurgencymakarov.png"
SWEP.IconOverride = "materials/items_icons/pl14icon.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 14
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.RubberBullets = false
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/hndg_mkiii/mkiii_fire_01.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 0.1
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

------------------------------------------

SWEP.Weight	= 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom	= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/pwb2/weapons/w_pl14.mdl"
SWEP.WorldModel	= "models/pwb2/weapons/w_pl14.mdl"

SWEP.vbwPos = Vector(8,0,-6)
SWEP.addPos = Vector(-0.9,-1.5,-0.7)
SWEP.addAng = Angle(0,.25,0)

SWEP.SightPos = Vector(-20,-1.05,-0.68)
