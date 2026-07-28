SWEP.Base = 'salat_base' -- base

SWEP.PrintName = "Desert Eagle .44 Magnum"
SWEP.Instructions = "Congrats it's a DEAGLE"
SWEP.Category = "HOMO"
SWEP.WepSelectIcon = "pwb2/vgui/weapons/deserteagle"
SWEP.IconOverride = "materials/items_icons/deagleicon.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false

------------------------------------------

SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ".44 Magnum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/fnfal/fnfal_fp.wav"
SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/fnfal/fnfal_dist.wav"
SWEP.Primary.Force = 105 / 40
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.3
SWEP.ReloadSound = "pwb2/weapons/deserteagle/reload.wav"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

------------------------------------------

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/pwb2/weapons/w_deserteagle.mdl"
SWEP.WorldModel = "models/pwb2/weapons/w_deserteagle.mdl"

SWEP.vbwPos = Vector(5,0,-2)

SWEP.addPos = Vector(0,-1,-0.7)
SWEP.addAng = Angle(0,0,0)

SWEP.SightPos = Vector(-25,-0.25,-0.78)

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(3.5,math.Rand(-0.5,2),0)
end
