SWEP.PrintName = "Just a normal baguette"
SWEP.Author = "Zgrad"
SWEP.Instructions = "The French won many a battle with this."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/baguetteicon.png"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/zgrad/baguette/baguette.mdl"
SWEP.WorldModel = "models/zgrad/baguette/baguette.mdl"
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

SWEP.Base = "weapon_base"

SWEP.Primary.Sound = Sound("Weapon_Knife.Single")
SWEP.Primary.Damage = 40
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 150

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

function Circle(x, y, radius, seg)
    local cir = {}

    table.insert(cir, {x = x, y = y, u = 0.5, v = 0.5})
    for i = 0, seg do
        local a = math.rad((i / seg) * -360)
        table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})
    end

    local a = math.rad(0) -- This is needed for non absolute segment counts
    table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})

    surface.DrawPoly(cir)
end

function SWEP:DrawHUD()
    if not (GetViewEntity() == LocalPlayer()) then return end
    if LocalPlayer():InVehicle() then return end
    local ply = self:GetOwner()
    local t = {}
    t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
    t.endpos = t.start + ply:GetAngles():Forward() * 60
    t.filter = self:GetOwner()
    local Tr = util.TraceLine(t)

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

if CLIENT then
    local WorldModel = ClientsideModel(SWEP.WorldModel)

    -- Settings...
    WorldModel:SetSkin(1)
    WorldModel:SetNoDraw(true)

    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()
        local scale = 1
        if (IsValid(_Owner)) then
            local offsetVec = Vector(4, -1, -15)
            local offsetAng = Angle(0, 90, 90)

            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if not boneid then return end

            local matrix = _Owner:GetBoneMatrix(boneid)
            if not matrix then return end

            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)
            WorldModel:SetModelScale(scale)
            WorldModel:SetupBones()

        else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
            WorldModel:SetModelScale(scale)
        end

        WorldModel:DrawModel()
    end
end

function SWEP:Initialize()
    self:SetHoldType("melee2")
end

function SWEP:Deploy()
    self:SetNextPrimaryFire(CurTime() + self:GetOwner():GetViewModel():SequenceDuration())
    self:SetHoldType("melee2")
end

function SWEP:Holster()
    return true
end

function SWEP:PrimaryAttack()
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay / ((self:GetOwner().stamina or 100) / 100) - (self:GetOwner():GetNWInt("Adrenaline") / 5))

    if SERVER then
        self:GetOwner():EmitSound("weapons/slam/throw.wav", 60)
        self:GetOwner().stamina = math.max(self:GetOwner().stamina - 8, 0)
    end
    self:GetOwner():LagCompensation(true)
    local ply = self:GetOwner()

    local tra = {}
    tra.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
    tra.endpos = tra.start + ply:GetAngles():Forward() * 50
    tra.filter = self:GetOwner()
    local Tr = util.TraceLine(tra)
    local t = {}
    local pos1, pos2
    local tr
    if not Tr.Hit then
        t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
        t.endpos = t.start + ply:GetAngles():Forward() * 50
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
        if SERVER and tr.HitWorld then
            self:GetOwner():EmitSound("physics/wood/wood_plank_impact_hard" .. math.random(1, 5) .. ".wav", 60)
        end

        if IsValid(tr.Entity) and SERVER then
            local dmginfo = DamageInfo()
            dmginfo:SetDamageType(DMG_CLUB)
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
                self:GetOwner():EmitSound("Flesh.ImpactHard", 60)
            else
                if tr.Entity:GetClass() == "prop_ragdoll" then
                    self:GetOwner():EmitSound("Flesh.ImpactHard", 60)
                else
                    self:GetOwner():EmitSound("physics/wood/wood_plank_impact_hard" .. math.random(1, 5) .. ".wav", 60)
                end
            end
            tr.Entity:TakeDamageInfo(dmginfo)
        end
    end

    self:GetOwner():LagCompensation(false)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
end
