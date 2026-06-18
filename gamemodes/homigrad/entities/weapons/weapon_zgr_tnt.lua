SWEP.Base = "weapon_hg_granade_base"

SWEP.PrintName = "TNT"
SWEP.Author = "Zgrad"
SWEP.Instructions = "Gets the job done."
SWEP.Category = "HOMO"
SWEP.IconOverride = "materials/items_icons/tnticon.png"

SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.Spawnable = true
SWEP.DrawWeaponInfoBox = true

SWEP.ViewModel = "models/jmod/explosives/grenades/tnt/w_jnt.mdl"
SWEP.WorldModel = "models/jmod/explosives/grenades/tnt/w_jnt.mdl"

SWEP.Grenade = "ent_hgjack_gmod_eztnt"

if CLIENT then
    local WorldModel = ClientsideModel(SWEP.WorldModel)

    -- Settings...
    WorldModel:SetSkin(1)
    WorldModel:SetNoDraw(true)

    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()

        if (IsValid(_Owner)) then
            -- Specify a good position
            local offsetVec = Vector(3, -8, 0)
            local offsetAng = Angle(-90, 0, 0)

            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if not boneid then return end

            local matrix = _Owner:GetBoneMatrix(boneid)
            if not matrix then return end

            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)
            WorldModel:SetModelScale(1)

            WorldModel:SetupBones()
        else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
        end

        WorldModel:DrawModel()
    end
end