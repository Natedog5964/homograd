SWEP.Base = 'salat_base' -- base

SWEP.PrintName = "M30W"
SWEP.Author = "Zgrad"
SWEP.Instructions = "CAT!\nUses 5.7x18 ammunition."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/m30wicon.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "5.7x28 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 60
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/zgrad/cat/meow1.ogg"
SWEP.Primary.SoundFar = "snd_jack_hmcd_snp_far.wav"
SWEP.Primary.Force = 50
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.5
SWEP.ReloadSound = "weapons/zgrad/cat/catgun_reload_shorter.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

------------------------------------------

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/zgrad/catgun/w_catgun.mdl"
SWEP.WorldModel = "models/zgrad/catgun/w_catgun.mdl"

SWEP.vbwPos = Vector(5,-6,-6)

SWEP.addAng = Angle(0,0,90)
SWEP.addPos = Vector(20,0,3)

SWEP.SightPos = Vector(-5,0,6)
