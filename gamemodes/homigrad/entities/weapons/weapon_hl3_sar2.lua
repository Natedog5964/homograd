if SERVER then
    util.AddNetworkString("TertiaryFire_Net")
    net.Receive("TertiaryFire_Net", function(len, ply)
        local swep = ply:GetActiveWeapon()
        if IsValid(swep) and swep.TertiaryAttack then
            swep:TertiaryAttack()
        end
    end)
end

SWEP.Base = "salat_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("AR2")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("Combine's automatic rifle.\nUses Pulse ammo.")
	SWEP.Category = language.GetPhrase("HL3")
	SWEP.IconOverride = "materials/items_icons/ar3hl3icon.png"
end

SWEP.WepSelectIcon = "pwb/sprites/akm"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 8
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/arccw/fire1.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_snp_far.wav"
SWEP.Primary.Force = 270 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.1
SWEP.ReloadSound = "weapons/arccw/npc_ar2_reload.wav"
SWEP.TwoHands = true
SWEP.Effect = "AR2Impact"
SWEP.Tracer = "AR2Tracer"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "ar2"

SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/weapons/arccw/w_irifle.mdl"
SWEP.WorldModel = "models/weapons/arccw/w_irifle.mdl"

SWEP.vbwPos = Vector(2, -4.2, 1)
SWEP.vbwAng = Angle(5, -30, 0)

SWEP.addAng = Angle(0, 0.8, 90)

SWEP.dwmModeScale = 1
SWEP.dwmForward = 0
SWEP.dwmRight = 0
SWEP.dwmUp = 0

SWEP.dwmAUp = 0
SWEP.dwmARight = 0
SWEP.dwmAForward = 0

SWEP.SightPos = Vector(-30, 2, 3.18)

function SWEP:Think()
    if self.BaseClass and self.BaseClass.Think then self.BaseClass.Think(self) end
	
local ply = self:GetOwner()
self.babymode = ply:GetInfoNum("ar3_babymode", 0) 

    if CLIENT and input.IsMouseDown(MOUSE_MIDDLE) then
        if (self.NextTertiary or 0) < CurTime() then
            self.NextTertiary = CurTime() + 0.6

            net.Start("TertiaryFire_Net")
            net.SendToServer()
            
            self:TertiaryAttack()
        end
    end
end

function SWEP:TertiaryAttack()

local ply = self:GetOwner()

if ply:GetAmmoCount("AR2AltFire") <= 0 then 
        self:EmitSound("Weapon_AR2.Empty")
        return 
    end
	
	ply:RemoveAmmo(1, "AR2AltFire")
	
        self:FireBall()

end

function SWEP:FireBall()
    local ply = self:GetOwner()
    if not IsValid(ply) then return end
	
    if self.babymode == 1 then
	self:EmitSound("ambient/creatures/teddy.wav", 75, 130, 1, CHAN_AUTO, 0, 10)
	else
    self:EmitSound("Weapon_AR2.Special2")
	end
    if CLIENT then return end 

    local ball = ents.Create("prop_physics")
    if not IsValid(ball) then return end 

    local aimvec = ply:GetAimVector()
    local spawnPos = ply:GetShootPos() + (aimvec * 50)

	if self.babymode == 1 then
	ball:SetModel("models/props_c17/doll01.mdl")
    ball:SetPos(spawnPos)
    ball:SetOwner(ply)
    ball:Spawn()
	else
	ball:SetModel("models/Items/AR2_Grenade.mdl")
	ball:SetPos(spawnPos)
    ball:SetOwner(ply)
    ball:Spawn()
	ball:SetNoDraw(true) 
    local visual = ents.Create("prop_dynamic")
    visual:SetModel("models/effects/combineball.mdl")
    visual:SetPos(ball:GetPos())
    visual:SetParent(ball)
    visual:SetModelScale(1.5, 0)
    visual:Spawn()
	end
	
    local phys = ball:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetMass(1)
        phys:EnableGravity(false)
        phys:SetVelocity(aimvec * 10000)
        phys:SetMaterial("metal_bouncy") 
        phys:SetDamping(0, 0)
        phys:Wake()
    end


    ball:AddCallback("PhysicsCollide", function(ent, data)
	if self.babymode == 1 then
	ent:EmitSound("ambient/voices/playground_memory.wav")
	else
    ent:EmitSound("NPC_CombineBall.Impact")
    end
        local target = data.HitEntity
        if IsValid(target) and target:IsNPC() then
            local dmg = DamageInfo()
            dmg:SetDamage(500) 
            dmg:SetAttacker(ply)
            dmg:SetInflictor(self)
            dmg:SetDamageType(DMG_DISSOLVE)
            target:TakeDamageInfo(dmg)
        end
		if IsValid(target) and target:IsPlayer() then
            local dmg = DamageInfo()
            dmg:SetDamage(500) 
            dmg:SetAttacker(ply)
            dmg:SetInflictor(self)
            dmg:SetDamageType(DMG_BLAST)
            target:TakeDamageInfo(dmg)
        end
        

        timer.Simple(0, function()
            if IsValid(ent) and IsValid(ent:GetPhysicsObject()) then
                local p = ent:GetPhysicsObject()
                local newVel = data.OurOldVelocity - 2 * data.OurOldVelocity:Dot(data.HitNormal) * data.HitNormal
                p:SetVelocity(newVel)
            end
        end)
    end)


    timer.Simple(4, function()
        if IsValid(ball) then 
            ball:EmitSound("NPC_CombineBall.Explosion")
            ball:Remove() 
        end
    end)
    
    ball:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
end