include( "shared.lua" )

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

net.Receive( "zg_melee_dust_impact", function()
    local hitPos = net.ReadVector()
    local fx = EffectData()
    fx:SetOrigin( hitPos )
    fx:SetScale( 2 )
    util.Effect( "eff_zg_kick_hit", fx )
end )

net.Receive( "zg_melee_spark_impact", function()
    local hitPos = net.ReadVector()
    local normal = net.ReadVector()
    local fx = EffectData()
    fx:SetOrigin( hitPos )
    fx:SetNormal( normal )
    util.Effect( "MetalSpark", fx )
end )
