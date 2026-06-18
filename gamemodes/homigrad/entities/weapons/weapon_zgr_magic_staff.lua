SWEP.Base = "zgrad_melee_base"

SWEP.PrintName = "Magic Staff"
SWEP.Instructions = "LMB: Calls down a lightning bolt"
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/magicicon.png"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.CrosshairRange = 1000

SWEP.ViewModel = "models/zgrad/staff/s_staff.mdl"
SWEP.WorldModel = "models/zgrad/staff/s_staff.mdl"
SWEP.ModelScale = 1
SWEP.ModelPosOffset = Vector(3, -1.5, 0)
SWEP.ModelAngOffset = Angle(180, 0, 0)
SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.HoldType = "knife"

SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "MagicBalls"

SWEP.ShootWait = 0.5
SWEP.Reach = 10000
SWEP.LastShot = CurTime()
SWEP.LastSpark = CurTime()
SWEP.WindingUp = false
SWEP.WindUpIntensity = 1
SWEP.LastFired = false
SWEP.AnticipationFired = false
SWEP.Target	= nil
SWEP.DrawWeaponInfoBox = true

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	if not IsValid(DrawModel) then
		DrawModel = ClientsideModel(self.WorldModel, RENDER_GROUP_OPAQUE_ENTITY)
		DrawModel:SetNoDraw(true)
	else
		DrawModel:SetModel(self.WorldModel)

		local vec = Vector(100, 100, 120)
		local ang = Vector(-48, -48, -48):Angle()

		cam.Start3D(vec, ang, 20, x, y + 35, wide, tall, 5, 4096)
			cam.IgnoreZ(true)
			render.SuppressEngineLighting(true)
			render.SetLightingOrigin(self:GetPos())
			render.ResetModelLighting(50 / 255, 50 / 255, 50 / 255)
			render.SetColorModulation(1, .5, .5)
			render.SetBlend(255)
			render.SetModelLighting(4, 1, 1, 1)

			DrawModel:SetRenderAngles(Angle(0, RealTime() * 30 % 360, 0))
			DrawModel:DrawModel()
			DrawModel:SetRenderAngles()

			render.SetColorModulation(1, 1, 1)
			render.SetBlend(1)
			render.SuppressEngineLighting(false)
			cam.IgnoreZ(false)
		cam.End3D()
	end
end

function SWEP:Initialize()
    self.NextShot = 0
    sound.Add({
        name = "callerThunder",
        sound = "weapons/zgrad/staff/wizardry_thunder.wav",
        level = 500
    })
    sound.Add({
        name = "callerZoomp",
        sound = "weapons/zgrad/staff/wizardry_thunderimpact.wav",
        level = 500
    })
end

function SWEP:PlayerSwitchWeapon(ply, oldWeapon, newWeapon)
    if wep.WindingUp then
        return true
    else
        return false
    end
end

function SWEP:Holster(wep)
    if wep.WindingUp then
        return false
    else
        return true
    end
end

function SWEP:PrimaryAttack()
    if self.NextShot > CurTime() then return end
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    if ( self:GetOwner():IsPlayer() ) then
        self:GetOwner():LagCompensation( true )
    end
    local pos = self.Owner:GetEyeTrace().HitPos
    local entfound = self.Owner:GetEyeTrace().Entity
    if entfound and entfound:IsValid() then
        pos = entfound:GetPos()
        self.Target = entfound
    end
    if ( self:GetOwner():IsPlayer() ) then
        self:GetOwner():LagCompensation( false )
    end

    local strikeDelay = 0.40

    if SERVER then
        timer.Simple(strikeDelay - 0.52,function()
            if self:IsValid() then
                self:EmitSound("callerThunder", 500)
            end
        end)

        timer.Simple(strikeDelay - 0.12,function()
            if self:IsValid() then
                self:EmitSound("callerZoomp", 500)
            end
        end)

    end
    --local and server calls
    self.WindingUp = true
    self.NextShot = CurTime() + self.ShootWait

    timer.Simple(strikeDelay - 0.15,function()
        self.AnticipationFired = true
    end)

    timer.Simple(strikeDelay,function()
        if self:IsValid() then
            self:EmitSound("ambient/explosions/exp2.wav", 500)
            self.WindingUp = false
            self.WindUpIntensity = 1
            self.LastSpark = CurTime()
            self.LastFired = true
        end
    end)

    timer.Simple(strikeDelay + 0.5,function()
        if self:IsValid() then
            self:SetClip1( self:Clip1() - 1 )
			if SERVER then
				if self:Clip1() <= 0 then
					--self:Remove()
					--self:GetOwner():SelectWeapon("weapon_hands")
					return
				end
            end
        end
    end)
end

function SWEP:Think()
    local pos = self.Owner:GetEyeTrace().HitPos
    local entfound = self.Owner:GetEyeTrace().Entity

    --override pos with target origin
    if entfound and entfound:IsValid() then
        pos = entfound:GetPos()
    end

    --if we clicked on a target first, override pos and entfound
    if self.Target and self.Target:IsValid() then
        entfound = self.Target
        pos = self.Target:GetPos()
    end

    --this makes us and the target spark & plays the sound
    if util.SharedRandom("sparkServerClientA", 0, 1) > 0.95 and self.LastSpark < CurTime() and self.LastShot < CurTime() and self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() ) > 1 then
        local function passive_spark(tgt)
            if CLIENT then
                local dlight = DynamicLight(self.EntIndex())
                if ( dlight ) then
                    dlight.pos = tgt:GetPos() + Vector(0, 0, 50)
                    dlight.r = 207
                    dlight.g = 255
                    dlight.b = 250
                    dlight.brightness = 2
                    dlight.decay = 1000
                    dlight.size = 150
                    dlight.dietime = CurTime() + 1
                end
            end
            tgt:EmitSound(Sound"ambient/energy/spark"..tostring(math.random(1,6))..".wav", 100, 100, 0.25)
            local effectdata = EffectData()
            effectdata:SetEntity(tgt)
            effectdata:SetMagnitude(6)
            util.Effect( "TeslaHitboxes", effectdata )
            if tgt:IsRagdoll() then
                for i=0, tgt:GetPhysicsObjectCount() - 1 do
                    --twitch
                    local phys = tgt:GetPhysicsObjectNum(i)
                    phys:ApplyForceCenter(Vector(math.random(-250, 250),math.random(-250, 250),math.random(-250, 250)))
                end
            end
        end

        passive_spark(self.Owner)

        if entfound and entfound:IsValid() then
            passive_spark(entfound)
        end
        self.LastSpark = CurTime() + 1.6
    end

    if self.WindingUp then
        --windup zaps
        if math.random() > 0.6 - (self.WindUpIntensity*5) then
            local function windup_lights(tgt)
                local dlight = DynamicLight(self.EntIndex())
                if ( dlight ) then
                    dlight.pos = tgt
                    dlight.r = 130
                    dlight.g = 160
                    dlight.b = 255
                    dlight.brightness = 1
                    dlight.decay = 1000
                    dlight.size = 50 * self.WindUpIntensity
                    dlight.dietime = CurTime() + 1
                end
            end
            local function windup_tesla(tgt)
                effectdata = EffectData()
                effectdata:SetEntity(tgt)
                effectdata:SetMagnitude(self.WindUpIntensity/2)
                util.Effect("TeslaHitboxes", effectdata)
                if tgt:IsRagdoll() then
                    for i=0, tgt:GetPhysicsObjectCount() - 1 do
                        local phys = tgt:GetPhysicsObjectNum(i)
                        phys:ApplyForceCenter(Vector(math.random(-250, 250),math.random(-250, 250),math.random(-250, 250)))
                    end
                end
            end

            if CLIENT then
                if entfound and entfound:IsValid() then
                    windup_lights(entfound:GetPos())
                else
                    windup_lights(pos)
                end
                windup_lights(self.Owner:GetPos())
            end
            windup_tesla(self.Owner)
            if entfound and entfound:IsValid() then
                windup_tesla(entfound)
            end

            self.WindUpIntensity = self.WindUpIntensity + 0.25

        end
        --tracer sparks
        if self.Target == nil and !entfound:IsValid()  then
            if math.random() > 0.8 then
                local effectdata = EffectData()
                effectdata:SetOrigin(pos)
                util.Effect("StunstickImpact", effectdata)
            end
        end
    end

    --anticipation
    if self.AnticipationFired then
        if SERVER then
            local ES = ents.Create("env_sprite")
            ES:SetKeyValue("model", "sprites/blueflare1.spr")
            ES:SetKeyValue("scale", "0")
            ES:SetKeyValue("rendermode", "9")
            ES:SetPos(pos)
            ES:Spawn()
            ES:Fire("Alpha","170",0)
            ES:Fire("Color","60 90 255",0)
            ES:Fire("Kill","",0.15)
            for i = 0.15,0.01,-0.01
            do
                ES:Fire("SetScale",tostring(0+(i*300)), i)
                ES:SetPos(pos)
            end
            self.AnticipationFired = false
        end
        if CLIENT then
            self.AnticipationFired = false
        end
    end

    --cast follows mouse
    if self.LastFired then
        if SERVER then
            local xplo = ents.Create("env_explosion")
            xplo:SetPos(pos)
            xplo:SetKeyValue("iMagnitude","0")
            xplo:SetKeyValue("iRadiusOverride","0")
            xplo:SetKeyValue("spawnflags", 64 + 512)
            xplo:Spawn()
            xplo:Fire("Explode",0,0)
            --boom fx at caster
            local xplo = ents.Create("env_explosion")
            xplo:SetPos(self.Owner:GetPos())
            xplo:SetKeyValue("iMagnitude","0")
            xplo:SetKeyValue("iRadiusOverride","0")
            xplo:SetKeyValue("spawnflags", 1 + 4 + 64 + 512)
            xplo:Spawn()
            xplo:Fire("Explode",0,0)

            --apply lots of decals
            util.Decal("Scorch", pos, pos + Vector(0, 0, -10), player.GetAll())
            for i = 1, 5 do
                util.Decal("Scorch", pos + Vector(math.Rand(-2, 2) * 25, math.Rand(-2, 2) * 25 , 50), pos + Vector(math.Rand(-2, 2) * 25, math.Rand(-2, 2) * 25 , -50), player.GetAll())
            end

            local effectdata = EffectData()
            effectdata:SetOrigin(pos)
            effectdata:SetScale(1)
            effectdata:SetMagnitude(8)
            effectdata:SetNormal(Vector(0, 0, 1))
            effectdata:SetRadius(100)
            util.Effect( "Sparks", effectdata )

            local zapdamage = DamageInfo()
            zapdamage:SetAttacker(self.Owner)
            zapdamage:SetInflictor(self)
            zapdamage:SetDamage(2048)
            zapdamage:SetMaxDamage(8192)
            zapdamage:SetDamageType(DMG_SHOCK)

            --main hit damage
            util.BlastDamageInfo(zapdamage, pos + Vector(0, 0, 100), 120)
            util.BlastDamageInfo(zapdamage, pos + Vector(0, 0, 50), 120)
            util.BlastDamageInfo(zapdamage, pos , 120)

            --bolt damage
            zapdamage:SetDamage(1024)
            for i = -50, 250 do
                util.BlastDamageInfo(zapdamage, pos + Vector(0, 0, i * 200), 120)
            end

            --gib combine constructs
            for i = 1, 10 do
                util.BlastDamage(self, self.Owner, pos, 1, 1024)
            end


            --screenshake
            local function ShakeScreen()
                local screenshake = ents.Create("env_shake")
                screenshake:SetKeyValue("amplitude", 1000)
                screenshake:SetKeyValue("duration", 2)
                screenshake:SetKeyValue("radius", 3000)
                screenshake:SetKeyValue("frequency", 255)
                screenshake:Spawn()
                screenshake:SetPos(pos)
                screenshake:Activate()
                screenshake:Fire("StartShake", "", 0)
                screenshake:Fire("Kill","",0)
            end
            local function ShakeGlobal()
                local screenshake = ents.Create("env_shake")
                screenshake:SetKeyValue("amplitude", 1000)
                screenshake:SetKeyValue("duration", 2)
                screenshake:SetKeyValue("radius", 16000)
                screenshake:SetKeyValue("spawnflags", "4, 8, 16")
                screenshake:SetKeyValue("frequency", 255)
                screenshake:Spawn()
                screenshake:SetPos(pos)
                screenshake:Activate()
                screenshake:Fire("StartShake", "", 0)
                screenshake:Fire("Kill","",0)
            end
            for i = 1, 65 do
                ShakeScreen()
            end
            for i = 1, 2 do
                ShakeGlobal()
            end

            --steam at bolt
            local ES = ents.Create("env_steam")
            ES:SetKeyValue("initialstate", "1")
            ES:SetKeyValue("angles", "270 0 0 ")
            ES:SetKeyValue("type", "1")
            ES:SetKeyValue("spreadspeed", "5")
            ES:SetKeyValue("speed", "40")
            ES:SetKeyValue("startsize", "30")
            ES:SetKeyValue("endsize", "1")
            ES:SetKeyValue("rate", "20")
            ES:SetKeyValue("jetlength", "90")
            ES:SetKeyValue("rollspeed", "50")
            ES:SetKeyValue("renderamt", "200")
            ES:SetPos(pos)
            ES:Spawn()
            ES:Fire("TurnOn","",0)
            ES:Fire("TurnOff","",3)
            ES:Fire("Kill","",5)
            for i = 2,0.5,-0.5
            do
                ES:Fire("speed",tostring(40-(i*30)), i)
            end

            --steam at caster
            local ES = ents.Create("env_steam")
            ES:SetKeyValue("initialstate", "1")
            ES:SetKeyValue("angles", "270 0 0 ")
            ES:SetKeyValue("type", "1")
            ES:SetKeyValue("spreadspeed", "5")
            ES:SetKeyValue("speed", "40")
            ES:SetKeyValue("startsize", "30")
            ES:SetKeyValue("endsize", "1")
            ES:SetKeyValue("rate", "20")
            ES:SetKeyValue("jetlength", "90")
            ES:SetKeyValue("rollspeed", "50")
            ES:SetKeyValue("renderamt", "200")
            ES:SetPos(self.Owner:GetPos())
            ES:Spawn()
            ES:Fire("TurnOn","",0)
            ES:Fire("TurnOff","",3)
            ES:Fire("Kill","",5)
            for i = 2,0.5,-0.5
            do
                ES:Fire("speed",tostring(40-(i*30)), i)
            end

            --bolt proper
            local function bolt(offset)
                local ES = ents.Create("env_sprite")
                ES:SetKeyValue("model", "sprites/bluelight1.spr")
                ES:SetKeyValue("scale", "75")
                ES:SetKeyValue("rendermode", "5")
                ES:SetKeyValue("disablereceiveshadows", "true")
                ES:SetPos(pos + Vector(0, 0, offset))
                ES:Spawn()
                ES:Fire("Kill","",0.50)
                for i = 0.50,0.01,-0.01
                do
                    ES:SetPos(pos + Vector(0, 0, i*18000) + Vector(0, 0, offset))
                    ES:Fire("SetScale",tostring(75-(i*250)), i)
                end
            end
            for i = -5, 5, 1 do
                bolt(i*1000)
            end

            --glow around bolt
            local ES = ents.Create("env_sprite")
            ES:SetKeyValue("model", "sprites/blueflare1.spr")
            ES:SetKeyValue("scale", "180")
            ES:SetKeyValue("rendermode", "9")
            ES:SetPos(pos)
            ES:Spawn()
            ES:Fire("Alpha","200",0)
            ES:Fire("Color","150 200 255",0)
            ES:Fire("Kill","",0.20)
            for i = 0.20,0.01,-0.01
            do
                ES:Fire("SetScale",tostring(180-(i*800)), i)
            end

            --glow around the caster
            local ES = ents.Create("env_sprite")
            ES:SetKeyValue("model", "sprites/blueflare1.spr")
            ES:SetKeyValue("scale", "40")
            ES:SetKeyValue("rendermode", "9")
            ES:SetPos(self.Owner:GetPos() + Vector(0, 0, 75))
            ES:Spawn()
            ES:Fire("Alpha","170",0)
            ES:Fire("Color","50 70 255",0)
            ES:Fire("Kill","",0.20)
            for i = 0.20,0.01,-0.01
            do
                ES:Fire("SetScale",tostring(40-(i*500)), i)
            end

        end
        self.Target = nil
        self.LastFired = false
    end
end

function SWEP:SecondaryAttack()
end

if CLIENT then 

local WorldModel = ClientsideModel(SWEP.WorldModel)
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()

		if IsValid(owner) then
			local offsetVec = Vector(8, -1, 0)
			local offsetAng = Angle(150, 0, 0)

			local boneid = owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if not boneid then return end

			local matrix = owner:GetBoneMatrix(boneid)
			if not matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
			WorldModel:SetModelScale(1.3)
			WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
	
	function SWEP:PrimaryAttack()
		local ply = self:GetOwner()
		ply:SetAnimation( PLAYER_ATTACK1 )
		self.AmmoChek = 2
	end

	function SWEP:Reload()
		self.AmmoChek = 5
	end

	function SWEP:DrawHUD()
		if GetViewEntity() ~= LocalPlayer() then return end
		if LocalPlayer():InVehicle() then return end
	local ply = self:GetOwner()
    local t = {}
		t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
		t.endpos = t.start + ply:GetAimVector() * self.CrosshairRange
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
		show = math.Clamp(self.AmmoChek or 0,0,1)
		self.AmmoChek = Lerp(2*FrameTime(),self.AmmoChek or 0,0)
		color_gray = Color(225,215,125,190*show)
		color_gray1 = Color(225,215,125,255*show)
		if show > 0 then
			local ammobag = self:Clip1()
			local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
			if not hand then return end
			local textpos = (hand.Pos+hand.Ang:Forward()*7+hand.Ang:Up()*30+hand.Ang:Right()*-1):ToScreen()
			draw.DrawText( "Remaining Spells | "..math.Round(ammobag), "HomigradFontBig", textpos.x+5, textpos.y+25, color_gray, TEXT_ALIGN_RIGHT )
		end
	end
end