SWEP.Base = "zgrad_common_base"

SWEP.PrintName = "ZGRAD Melee Base"
SWEP.Category = "ZGRAD Melee"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
--SWEP.ViewModel = ""
--SWEP.WorldModel = ""
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Suppressed = false
SWEP.Primary.Damage = 50
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.8
SWEP.Primary.Force = 190
SWEP.Primary.Pushback = 10

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Reach = 50
SWEP.StaminaDrain = 4
SWEP.ModelPosOffset = Vector( 0, 0, 0 )
SWEP.ModelAngOffset = Angle( 0, 0, 0 )
SWEP.ModelScale = 1
SWEP.Effect =  "none"
SWEP.EffectVecOffset = Vector(0, 0, 4)
SWEP.EffectAngOffset = Angle(-90, 0, 0)
SWEP.EffectScale = 2
SWEP.DamageType = DMG_SLASH
SWEP.DamageTypeAlt = "none"
SWEP.DamageRatio = 0.5
SWEP.DrawSound = "snd_jack_hmcd_knifedraw.wav"
SWEP.HitSound = "snd_jack_hmcd_knifehit.wav"
SWEP.FleshHitSound = "snd_jack_hmcd_knifestab.wav"
SWEP.MajorCritMult = 1.5
SWEP.MinorCritMult = 1.5

SWEP.Unblockable = false
SWEP.ForceEnableBlocking = false
SWEP.ForceDisableBlocking = false

SWEP.DoorBuster = false

function Circle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad(i / seg * -360)

		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	local a = math.rad(0)

	table.insert(cir, {
		x = x + math.sin(a) * radius,
		y = y + math.cos(a) * radius,
		u = math.sin(a) / 2 + 0.5,
		v = math.cos(a) / 2 + 0.5
	})

	surface.DrawPoly(cir)
end
local tr = {}

function EyeTrace(ply)
	tr.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
	tr.endpos = tr.start + ply:GetAngles():Forward() * 80
	tr.filter = ply
	return util.TraceLine(tr)
end

function SWEP:DrawHUD()
    local locPly = LocalPlayer()
    if GetViewEntity() ~= locPly then return end
    if locPly:InVehicle() then return end

    local ply = self:GetOwner()
    local t = {}
    local plyEyes = ply:LookupAttachment( "eyes" )
    if not plyEyes then return end

    local eyesAttachment = ply:GetAttachment( plyEyes )
    if not eyesAttachment then return end

    t.start = eyesAttachment.Pos
    t.endpos = t.start + ply:GetAngles():Forward() * self.Reach
    t.filter = self:GetOwner()
    local Tr = util.TraceLine( t )

    if Tr.Hit then
        local Size = math.Clamp(1 - ((Tr.HitPos - self:GetOwner():GetShootPos()):Length() / 90) ^ 2, .1, .3)
        surface.SetDrawColor(200, 200, 200, 200)
        draw.NoTexture()
        Circle(Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y, 55 * Size, 32)

        surface.SetDrawColor(255, 255, 255, 200)
        draw.NoTexture()
        Circle(Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y, 40 * Size, 32)
    end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )

    self.CanBlock = ( ( self.HoldType == "melee2" or self.HoldType == "knife" ) or self.ForceEnableBlocking ) and not self.ForceDisableBlocking
    self.FullBlock = ( self.FullBlock or self.HoldType == "melee2" ) and not self.ForceDisableBlocking
    self.BlockBroken = false
    self.BlockBrokenTime = 0

    if CLIENT and self.Stats == "" then
        self:SetupStatsText()
    end
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay / ((ply.stamina or 100) / 100) - (ply:GetNWInt("Adrenaline") / 5))

	if SERVER then
		self:GetOwner():EmitSound("weapons/slam/throw.wav", 60)
		ply.stamina = math.max(ply.stamina - self.StaminaDrain, 0)
	end

	self:GetOwner():LagCompensation(true)

	local ply = self:GetOwner()

	local tra = {}
	tra.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
	tra.endpos = tra.start + ply:GetAngles():Forward() * 80
	tra.filter = self:GetOwner()
	local Tr = util.TraceLine(tra)

	local t = {}
	local pos1, pos2
	local tr

	if not Tr.Hit then
		t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
		t.endpos = t.start + ply:GetAngles():Forward() * 80
		t.filter = function(ent) return ent ~= self:GetOwner() and (ent:IsPlayer() or ent:IsRagdoll()) end
		t.mins = -Vector(10, 10, 10)
		t.maxs = Vector(10, 10, 10)
		tr = util.TraceHull(t)
	else
		tr = util.TraceLine(tra)
	end

	pos1 = tr.HitPos + tr.HitNormal
	pos2 = tr.HitPos - tr.HitNormal

	if true then
		if SERVER and tr.HitWorld then self:GetOwner():EmitSound(self.HitSound, 60) end

		if IsValid(tr.Entity) and SERVER then
			local dmginfo = DamageInfo()
			dmginfo:SetDamageType(self.DamageType)
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamagePosition(tr.HitPos)
			dmginfo:SetDamageForce(self:GetOwner():GetForward() * self.Primary.Force)

			local angle = self:GetOwner():GetAngles().y - tr.Entity:GetAngles().y

			if angle < -180 then angle = 360 + angle end

			if angle <= 90 and angle >= -90 then
				dmginfo:SetDamage(self.Primary.Damage * 1.5)
			else
				dmginfo:SetDamage(self.Primary.Damage / 1.5)
			end

			if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
				self:GetOwner():EmitSound(self.FleshHitSound, 60)
			else
				if IsValid(tr.Entity:GetPhysicsObject()) then
					local dmginfo = DamageInfo()
					dmginfo:SetDamageType(self.DamageType)
					dmginfo:SetAttacker(self:GetOwner())
					dmginfo:SetInflictor(self)
					dmginfo:SetDamagePosition(tr.HitPos)
					dmginfo:SetDamageForce(self:GetOwner():GetForward() * self.Primary.Force * 7)
					dmginfo:SetDamage(self.Primary.Damage)
					tr.Entity:TakeDamageInfo(dmginfo)

					if tr.Entity:GetClass() == "prop_ragdoll" then
						self:GetOwner():EmitSound(self.FleshHitSound, 60)
					else
						self:GetOwner():EmitSound(self.HitSound, 60)
					end
				end
			end

			tr.Entity:TakeDamageInfo(dmginfo)
		end
		-- self:GetOwner():EmitSound(Sound(self.HitSound), 60)
	end

	if SERVER and Tr.Hit and self.ShouldDecal then
		if IsValid(Tr.Entity) and Tr.Entity:GetClass() == "prop_ragdoll" then
			util.Decal("Impact.Flesh", pos1, pos2)
		else
			util.Decal("ManhackCut", pos1, pos2)
		end
	end

	self:GetOwner():LagCompensation(false)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:SetupStatsText()
    local stats = ""
    local damage = 0
    local damageAlt = 0

    if self.DamageType ~= "none" and self.DamageTypeAlt == "none" then
        damage = self.Primary.Damage
        damageAlt = 0
    elseif self.DamageType ~= "none" and self.DamageTypeAlt ~= "none" then
        damage = self.Primary.Damage * self.DamageRatio
        damageAlt = self.Primary.Damage - damage
    elseif self.DamageType == "none" and self.DamageTypeAlt ~= "none" then
        damage = 0
        damageAlt = self.Primary.Damage
    end

    stats = stats .. "Estimated Damage: <color=255,150,175,255>" .. tostring( damage + damageAlt ) .. "</color>\n"
    stats = stats .. "Stamina Drain: <color=150,175,190,255>" .. tostring( self.StaminaDrain ) .. "%</color>\n"

    if self.Primary.Delay ~= 0 then
        local str = tostring( self.Primary.Delay )
        stats = stats .. "Swing Speed: <color=225,175,175,255>" .. str .. "s</color>\n"
    end

    if self.FullBlock then
        stats = stats .. "<color=175,225,175,255>Can fully block melee attacks.</color>\n"
    elseif self.CanBlock then
        stats = stats .. "<color=255,175,175,255>Can partially block melee attacks.</color>\n"
    end

    if self.Unblockable then
        stats = stats .. "<color=200,150,175,255>Unblockable.</color>\n"
    end

    if self.DoorBuster then
        stats = stats .. "<color=150,175,225,255>Busts doors.</color>\n"
    end

    if self.DamageType == DMG_BURN or self.DamageTypeAlt == DMG_BURN then
        stats = stats .. "<color=255,150,0,255>Ignites enemies.</color>\n"
    end

    self.Stats = stats
end