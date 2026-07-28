SWEP.Base = "salat_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("FAL")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("FAL")
	SWEP.Category = language.GetPhrase("HOMO")
	SWEP.IconOverride = "materials/items_icons/fal_icon.png"
end

SWEP.WepSelectIcon = "pwb/sprites/akm"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 58
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/fal/fal_fire3.wav"
SWEP.Primary.SoundFar = "ak74/ak74_dist.wav"
SWEP.Primary.Force = 240 / 3
SWEP.ReloadTime = 1.5
SWEP.ShootWait = 0.2
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "ar2"

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/weapons/w_fal/w_fal.mdl"
SWEP.WorldModel = "models/weapons/w_fal/w_fal.mdl"

SWEP.vbwPos = Vector(0, 0, 0) -- UNUSED

SWEP.addAng = Angle(3.3, -2, 100) -- Sight Barrel Angle Usage: (Left/right,Up/down,Tilt)

SWEP.addPos = Vector(33, -4.38, -4) -- Moves Muzzle point Usage: (forward/back,Up/down,Left/right)

SWEP.SightPos = Vector(2, -3.6, -0.4) -- Sight pos, Usage: (forward/back,Up/down,Left/right)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:EmitSound(self.Primary.Sound, 100, math.random(95, 105), 1, CHAN_WEAPON)
	
	self.BaseClass.PrimaryAttack(self)
	
	self:SetNextPrimaryFire(CurTime() + (self.ShootWait or 0.2))
end