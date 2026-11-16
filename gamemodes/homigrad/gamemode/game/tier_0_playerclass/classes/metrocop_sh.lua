
local CLASS = player.RegClass("metrocop")

local combine_models = {
    "models/player/police.mdl"
}

local primary_weapons = {
    "weapon_mp7"
}

local combine_subclasses = {
    default = {
        color = Color(24,24,24),
        models = combine_models,
        loadout = {
            {weapon = "medkit"},
            {weapon = "med_band_big"},
            {weapon = "weapon_stunstick"},
            {weapon = "weapon_handcuffs"},
            {weapon = "weapon_radio"},
            {
                weapon = "weapon_hk_usp",
                ammo_mult = 3
            },

            {
                weapon_random_pool = primary_weapons,
                ammo_mult = 3
            }
        },
    }
}

local combines = {
    "npc_combine_s",
    "npc_strider",
    "npc_metropolice",
    "npc_hunter",
    "npc_rollermine",
    "npc_cscanner",
    "npc_combinegunship",
    "npc_combinedropship",
    "npc_clawscanner",
    "npc_manhack",
    "npc_combine_camera",
    "npc_turret_ceiling",
    "npc_turret_floor"
}

local rebels = {
    "npc_alyx",
    "npc_barney",
    "npc_citizen",
    "npc_eli",
    "npc_fisherman",
    "npc_kleiner",
    "npc_magnusson",
    "npc_mossman",
    "npc_odessa",
    "npc_rollermine_hacked",
    "npc_turret_floor_resistance",
    "npc_vortigaunt"
}

function CLASS.Off(self)
    if CLIENT then return end


    for k,v in ipairs(ents.FindByClass("npc_*")) do
        if table.HasValue(combines,v:GetClass()) then
            v:AddEntityRelationship( self, D_HT, 99 )
        elseif table.HasValue(rebels,v:GetClass()) then
            v:AddEntityRelationship( self, D_LI, 0 )
        end
    end
	
	self.cantUsePepper = nil
	self:SetNWString("PlayerRole", nil)
    self.leader = nil
	hook.Remove("OnEntityCreated", "relation_shipdo"..self:EntIndex())
end

function CLASS.On(self, data)
    if CLIENT then return end
	
    local sub = self.subClass or "default"
    local cfg = combine_subclasses[sub] or combine_subclasses["default"]
    local useModel = cfg.models[math.random(#cfg.models)]
    self:SetModel(useModel)
    self:SetSubMaterial()
    self:SetPlayerColor(cfg.color:ToVector())
	giveSubClassLoadout(self, sub, combine_subclasses)
	self.cantUsePepper = true
    self.subClass = nil
    for k,v in ipairs(ents.FindByClass("npc_*")) do
        if table.HasValue(combines,v:GetClass()) then
            v:AddEntityRelationship( self, D_LI, 0 )
            v:ClearEnemyMemory()
        elseif table.HasValue(rebels,v:GetClass()) then
            v:AddEntityRelationship( self, D_HT, 99 )
            v:ClearEnemyMemory()
        end
    end

    local index = self:EntIndex()
    hook.Add( "OnEntityCreated", "relation_shipdo"..index, function( ent )
        if not IsValid(self) then hook.Remove("OnEntityCreated","relation_shipdo"..index) return end
        if ( ent:IsNPC() ) then
            if table.HasValue(combines,ent:GetClass()) then
                ent:AddEntityRelationship( self, D_LI, 0 )
            end

            if table.HasValue(rebels,ent:GetClass()) then
                ent:AddEntityRelationship( self, D_HT, 99 )
            end
        end
    end )
end

function CLASS.PlayerDeath(self)
    for k,v in ipairs(ents.FindByClass("npc_*")) do
        if table.HasValue(combines,v:GetClass()) then
            v:AddEntityRelationship( self, D_HT, 99 )
        elseif table.HasValue(rebels,v:GetClass()) then
            v:AddEntityRelationship( self, D_LI, 0 )
        end
    end
    EmitSound( "npc/metropolice/die" .. math.random(1,4) .. ".wav", self:GetPos() )
    hook.Remove( "OnEntityCreated", "relation_shipdo"..self:EntIndex())
end

if CLIENT then
    local cmb_mat = Material("sprites/combine_overlays/mat_jack_helmoverlay_r")
    hook.Add("PostDrawHUD","Metrocop_helmet",function()
        local lply = LocalPlayer()
        if lply:Alive() and lply.PlayerClassName == "metrocop" then
            local role = lply:GetNWString("PlayerRole")

            surface.SetDrawColor(150,190,190,255)

            surface.SetMaterial(cmb_mat)
            surface.DrawTexturedRectRotated(
                (ScrW()/2) - 5,
                (ScrH()/2) - 5,
                ScrW() + 10,
                ScrH() + 450,
                180
            )
        end
    end)
end

return CLASS
