SWEP.Base = "salat_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("Magnum .357")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("A really powerful gun.")
	SWEP.Category = language.GetPhrase("HL3")
	SWEP.IconOverride = "materials/items_icons/357hl3icon.png"
end

SWEP.WepSelectIcon = "pwb2/vgui/weapons/matebahomeprotection"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/357/357_fire2.wav"
SWEP.Primary.SoundFar = "weapons/357/357_reload1.wav"
SWEP.Primary.Force = 150
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.6
SWEP.Tracer = "AR2Tracer"
SWEP.Efect = "AR2Impact"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "revolver"
SWEP.revolver = true

SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/weapons/w_357_magnum/w_357_magnum.mdl"
SWEP.WorldModel = "models/weapons/w_357_magnum/w_357_magnum.mdl"

function SWEP:ApplyEyeSpray()
	self.eyeSpray = self.eyeSpray - Angle(2, math.Rand(-0.5, 0.5), 0)
end

local function rolldrum(ply, wpn)
	local wep = type(wpn) == "string" and ply:GetActiveWeapon() or wpn
	if not IsValid(ply) or not IsValid(wep) or wep:GetClass() ~= "weapon_mateba" then return end

	wep.tries = math.random(math.max(7 - wep:Clip1(), 1))

	if CLIENT then
		net.Start("hg_rolldrum")
			net.WriteEntity(wep)
			net.WriteInt(wep.tries, 4)
		net.SendToServer()
	else
		net.Start("hg_rolldrum")
			net.WriteEntity(wep)
			net.WriteInt(wep.tries, 4)
		net.Send(ply)
	end
end

function SWEP:RollDrum()
	rolldrum(self:GetOwner(), self)
end

concommand.Add("hg_rolldrum", rolldrum)

if SERVER then
	util.AddNetworkString("hg_rolldrum")

	net.Receive("hg_rolldrum", function(len, ply)
		local wep = net.ReadEntity()

		if wep:GetOwner() ~= ply then return end
		if ply:GetActiveWeapon() ~= wep then return end

		wep.tries = net.ReadInt(4)

		ply:EmitSound("weapons/357/357_spin1.wav", 65)
	end)
else
	net.Receive("hg_rolldrum", function(len)
		local wep = net.ReadEntity()

		wep.tries = net.ReadInt(4)
	end)
end

if SERVER then
	util.AddNetworkString("real_bul")

	function SWEP:Deploy()
		self:SetHoldType("normal")

		self:GetOwner():EmitSound("snd_jack_hmcd_pistoldraw.wav", 65, 100, 1, CHAN_AUTO)

		self.NextShot = CurTime() + 0.5

		self:SetHoldType(self.HoldType)

		self.tries = self.tries or math.random(math.max(7 - self:Clip1(), 1))

		net.Start("real_bul")
			net.WriteEntity(self)
			net.WriteInt(self.tries, 4)
		net.Send(self:GetOwner())
	end
else
	function SWEP:Deploy()
		self:SetHoldType("normal")

		self.NextShot = CurTime() + 0.5

		self:SetHoldType(self.HoldType)
	end

	net.Receive("real_bul", function(len) net.ReadEntity().tries = net.ReadInt(4) end)
end

function SWEP:CanFireBullet()
	if not IsFirstTimePredicted() then return end

	self.tries = self.tries or 1 -- math.ceil(util.SharedRandom("hgRevolverTries" .. tostring(CurTime()), 1, math.max(6 - self:Clip1(), 1)))
	self.tries = self.tries - 1

	return self.tries <= 0
end

SWEP.addPos = Vector(0, 0, 0)
SWEP.addAng = Angle(0.95, -0.4, 0)

SWEP.SightPos = Vector(-30, -0.5, -0.25)