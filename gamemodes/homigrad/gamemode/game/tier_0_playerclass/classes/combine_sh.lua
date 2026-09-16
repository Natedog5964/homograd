local CLASS = player.RegClass("combine")

isCombine = isCombine or nil
if SERVER then util.AddNetworkString("hg_bloodhudoverride") end
net.Receive("hg_bloodhudoverride", function() hg_bloodhudoverride = net.ReadBool() end)

local primary_weapons = {
    "weapon_sar2",
    "weapon_barret",
    "weapon_mp7"
}
local snipers = {
	"weapon_barret",
	"weapon_scout"
}

local combine_subclasses = {
    default = {
        models = Model("models/player/combine_soldier.mdl"),
		mat = {
			["models/combine_soldier/combinesoldiersheet_player"] = "models/combine_soldier/combinesoldiersheet"
		},
        loadout = {
            {
                weapon = "weapon_hl2",
                count = 1
            },
            {
                weapon = "weapon_hk_usp",
                ammo_mult = 3
            },

            {
                weapon_random_pool = primary_weapons,
                ammo_mult = 3
            }
        },
    },

    elite = {
        color = Color(246,13,13),
        models = Model("models/player/combine_super_soldier.mdl"),
		mat = {
			["models/combine_soldier/combine_elite_player"] = "models/combine_soldier/combine_elite",
			["models/combine_soldier/combine_elite_player_head"] = "models/combine_soldier/combine_elite"
		},
        loadout = {
            {
                weapon = "weapon_hg_hl2",
                count = 1
            },
            {
                weapon = "weapon_hk_usp",
                ammo_mult = 3
            },
            {
                weapon = "weapon_sar2",
                ammo_mult = 3,
                extra_balls = 3 
            }
        }
    },

    sniper = {
        color = Color(0,220,220),
        models = Model("models/player/combine_soldier.mdl"),
        loadout = {
            {
                weapon = "weapon_hg_hl2",
                count = 1
            },
            {
                weapon = "weapon_hk_usp",
                ammo_mult = 3
            },
            {
                weapon = "weapon_barret",
                ammo_mult = 3
            }
        }
    },

    shotgunner = {
        color = Color(220,0,0),
        models = Model("models/player/combine_soldier.mdl"),
        skin = 1,
		mat = {
			["models/combine_soldier/combinesoldiersheet_player_shotgun"] = "models/combine_soldier/combinesoldiersheet_shotgun"
		},
        loadout = {
            {
                weapon = "weapon_hg_flashbang",
                count = 1
            },
            {
                weapon = "weapon_hk_usp",
                ammo_mult = 3
            },
            {
                weapon = "weapon_spas12",
                ammo_mult = 3
            }
        }
    }
}

local combine_subclassindex = {"default", "elite", "sniper", "shotgunner"} -- index so we can randomize

function CLASS.Off(self)
	if CLIENT then return end

	self.isCombine = nil
	self.cantUsePepper = nil
	self:SetNWString("PlayerRole", nil)
	
	net.Start("hg_bloodhudoverride")
        net.WriteBool(nil)
    net.Send(self)
end

local function giveSubClassLoadout(ply, subclass)
    local config = combine_subclasses[subclass] or combine_subclasses["default"]
    ply:StripWeapons()
    ply:Give("weapon_hands")
    for _, item in ipairs(config.loadout or {}) do
        if item.weapon_random_pool then
            local randWep = item.weapon_random_pool[math.random(#item.weapon_random_pool)]
            local wep = ply:Give(randWep)
            if wep and item.ammo_mult then
                ply:GiveAmmo(wep:GetMaxClip1() * item.ammo_mult, wep:GetPrimaryAmmoType(), true)
            end
        else
            local wep = ply:Give(item.weapon)
            if IsValid(wep) then
                if item.ammo_mult then
                    ply:GiveAmmo(wep:GetMaxClip1() * item.ammo_mult, wep:GetPrimaryAmmoType(), true)
                end
                if item.count then
                    wep.count = item.count
                end
                if item.extra_balls then
                    wep:SetNWInt("Balls", item.extra_balls)
                end
            end
        end
    end
end

function CLASS.On(self)
	if CLIENT then return end
	
	self:SetWalkSpeed(250)
	self:SetRunSpeed(350)
	self:SetHealth(150)
	self:SetMaxHealth(150)
	
	local sub = combine_subclassindex[math.random(#combine_subclassindex)] or "default"
	local cfg = combine_subclasses[sub] or combine_subclasses["default"]
	local useModel = istable(cfg.models) and cfg.models[math.random(#cfg.models)] or cfg.models
	
	
    self:SetModel(useModel)
	self:SetNWString("PlayerRole", sub)
	if cfg.color then
		self:SetPlayerColor(cfg.color:ToVector())
	end
	if cfg.skin then
        self:SetSkin(cfg.skin)
    end
    if cfg.mat then
		for k, v in pairs(cfg.mat) do
        	self:SetSubMaterial(self:GetSubMaterialIdByName(k), v)
		end
    end
	
	

	--tdm.GiveSwep(self,CLASS.main_weapons,8)
	giveSubClassLoadout(self, sub)
	
	self.subClass = nil
	
	self.isCombine = true
	self.cantUsePepper = true

	self:EmitSound("radio/go.wav")
	
	net.Start("hg_bloodhudoverride")
        net.WriteBool(true)
    net.Send(self)
end

function CLASS.PlayerFootstep(self, pos, foot, name, volume, filter)
	if SERVER then return true end

	sound.Play(Sound("npc/combine_soldier/gear" .. math.random(1, 6) .. ".wav"), pos, 75, 100, 1)
	sound.Play(name, pos, 75, 100, volume)

	return true
end

local function getList(self)
	local list = {}

	for _, ply in RandomPairs(player.GetAll()) do
		if ply == self or not ply.isCombine then continue end

		local pos = ply:EyePos()
		local deathPos = self:GetPos()
		if pos:Distance(deathPos) > 1000 then continue end

		local trace = {
			start = pos
		}

		trace.endpos = deathPos
		trace.filter = ply

		if util.TraceLine(trace).HitPos:Distance(deathPos) <= 512 then
			list[#list + 1] = ply
		end
	end

	return list
end

function CLASS.PlayerDeath(self)
	sound.Play(Sound("npc/overwatch/radiovoice/die" .. math.random(1, 3) .. ".wav"), self:GetPos())

	--self:EmitSound("npc/combine_soldier/die" .. math.random(1,3) .. ".wav")
	for _, ply in RandomPairs(getList(self)) do
		ply:EmitSound(Sound("npc/combine_soldier/vo/ripcordripcord.wav"))

		break
	end

	self:SetPlayerClass()
end

function CLASS.Think(self)
end

function CLASS.PlayerStartVoice(self)
	for _, ply in player.Iterator() do
		if not ply.isCombine then continue end

		ply:EmitSound("npc/combine_soldier/vo/on" .. math.random(1, 3) .. ".wav")
	end
end

function CLASS.PlayerEndVoice(self)
	for _, ply in player.Iterator() do
		if not ply.isCombine then continue end

		ply:EmitSound("npc/combine_soldier/vo/off" .. math.random(1, 3) .. ".wav")
	end
end

function CLASS.CanLisenOutput(output, input, isChat)
	if not output:Alive() then return false end
end

function CLASS.CanLisenInput(input, output, isChat)
	if not output:Alive() then return false end
end

function CLASS.HomigradDamage(self, hitGroup, dmgInfo, rag)
	if (self.delaysoundpain or 0) > CurTime() then
		self.delaysoundpain = CurTime() + math.Rand(0.25, 0.5)

		self:EmitSound("npc/combine_soldier/pain" .. math.random(1, 3) .. ".wav")
	end
end

local entmeta = FindMetaTable("Entity")

function entmeta:GetSubMaterialIdByName(strName)
	local mats = self:GetMaterials()
	local id = false
	for i = 1, #mats do
		if mats[i] == strName then
			id = i - 1
			break
		end
	end
	return id
end

if CLIENT then
    local color_hp = Color(0,255,255,220)
    local color_ar = Color(0,255,255,220)
    local color_glow = Color(15,165,165,0)
    local color_glow_ammo = Color(15,165,165,0)
    local color_pulse = Color(15,165,165,220)

    local color_hp2 = Color(165,15,15)
    local color_ar2 = Color(165,15,15)
    local color_glow2 = Color(165,15,15)
    local color_glow_ammo2 = Color(165,15,15)
	local bg_color = Color(0,0,0,150)
	
    local ammolerp, hp_txt, ammo_txt, old_hp_txt, old_ammo_txt = 0,0,0,0,0
    local pos_sight = Vector(ScrW(),ScrH(),0)
    
    surface.CreateFont("CMBFontDefault",{
        font = "Roboto Light",
        extended = true,
        size = ScreenScale(24),
        weight = 500,
        scanlines = 3,
        antialias = true
    })
    surface.CreateFont("CMBFontSmall",{
        font = "Roboto Light",
        extended = true,
        size = ScreenScale(7.5),
        weight = 1500,
        scanlines = 3,
        antialias = true
    })	
    surface.CreateFont("CMBFontDefaultBG",{
        font = "Roboto Light",
        extended = true,
        size = ScreenScale(24.5),
        weight = 1500,
        blursize = 1,
        scanlines = 3,
        antialias = true
    })

    local function drawGlowingText(txt, font, x, y, col, col_glow, col_glow2, align)
        draw.DrawText(txt, font, x+1, y+1, col_glow, align)
        if col_glow2 then
            draw.DrawText(txt, font, x+2, y+2, col_glow2, align)
        end
        draw.DrawText(txt, font, x, y, col, align)
    end

    local function drawBGPanel(pos_x,pos_y,alpha)
        local size_w, size_h = ScrW()*0.12, ScrH()*0.075
        local pos_w, pos_h = ScrW()*pos_x, ScrH()*pos_y - size_h
        return {pos_w, pos_h}, {size_w, size_h}
    end
    
    function CLASS.HUDPaint(self)
        if not self:Alive() then return end
        local frt = FrameTime() * 5
        local role = self:GetNWString("PlayerRole")
        local is_red = (role == "shotgunner" or role == "elite")

        --;; HP
        do
            local pos, size = drawBGPanel(0.065,0.98)
            surface.SetFont("CMBFontDefault")
            local bloodcount = math.Round(100 * hg_blood/5000 , 0)
            local _,txt_size_y = surface.GetTextSize(bloodcount)
            hp_txt = math.min(hp_txt + 1, bloodcount)
            local col_bg = bg_color
            col_bg.a = 225
			if is_red then
                color_glow2.a = math.Round(Lerp(frt, color_glow2.a, old_hp_txt ~= hp_txt and 255 or 0))
                drawGlowingText(hp_txt, "CMBFontDefault", pos[1]+size[1]*0.08, pos[2]+(size[2]/2) - txt_size_y/2, color_hp2, color_glow2, nil, TEXT_ALIGN_RIGHT)
            else
                color_glow.a = math.Round(Lerp(frt, color_glow.a, old_hp_txt ~= hp_txt and 255 or 0))
                drawGlowingText(hp_txt, "CMBFontDefault", pos[1]+size[1]*0.08, pos[2]+(size[2]/2) - txt_size_y/2, color_hp, color_glow, nil, TEXT_ALIGN_RIGHT)
            end
            old_hp_txt = hp_txt

            draw.DrawText("% | BLOOD","CMBFontSmall",
                pos[1]+size[1]*0.085+1,
                pos[2]+(size[2]/1.8)+1,
                col_bg,
                TEXT_ALIGN_LEFT
            )
            draw.DrawText("% | BLOOD","CMBFontSmall",
                pos[1]+size[1]*0.085,
                pos[2]+(size[2]/1.8),
                is_red and color_hp2 or color_hp,
                TEXT_ALIGN_LEFT
            )
        end
		
        --;; Ammunition
        local wep = self:GetActiveWeapon()
        if IsValid(wep) and wep.Clip1 then
		if wep:GetMaxClip1() < 1 then return end
            ammolerp = Lerp(frt,ammolerp,(wep:Clip1() < 0) and 0 or 1)
            local pos, size = drawBGPanel(0.93,0.98)
            surface.SetFont("CMBFontDefault")
            local _,txt_size_y = surface.GetTextSize(self:Armor())
            local col_bg = bg_color
            col_bg.a = 225*ammolerp
            ammo_txt = math.min(ammo_txt + 1, wep:Clip1())

            draw.DrawText("000","CMBFontDefaultBG",
                pos[1]+size[1]*0.08 + 1,
                pos[2]+(size[2]/2) - txt_size_y/2 + 1,
                col_bg,
                TEXT_ALIGN_RIGHT
            )

            if is_red then
                color_glow_ammo2.a = math.Round(Lerp(frt, color_glow_ammo2.a, old_ammo_txt ~= ammo_txt and 255 or 0))
                drawGlowingText(ammo_txt,"CMBFontDefault",
                    pos[1]+size[1]*0.08,
                    pos[2]+(size[2]/2) - txt_size_y/2,
                    color_ar2, color_glow_ammo2, nil, TEXT_ALIGN_RIGHT
                )
            else
                color_glow_ammo.a = math.Round(Lerp(frt, color_glow_ammo.a, old_ammo_txt ~= ammo_txt and 255 or 0))
                drawGlowingText(ammo_txt,"CMBFontDefault",
                    pos[1]+size[1]*0.08,
                    pos[2]+(size[2]/2) - txt_size_y/2,
                    color_ar, color_glow_ammo, nil, TEXT_ALIGN_RIGHT
                )
            end
				
            old_ammo_txt = ammo_txt
            draw.DrawText("AMMO","CMBFontSmall",
                pos[1]+size[1]*0.085,
                pos[2]+(size[2]/1.8),
                is_red and color_ar2 or color_ar,
                TEXT_ALIGN_LEFT
            )
        end
    end
	
    hook.Add("RenderScreenspaceEffects","Combine_helmet",function()
		local is_red = (role == "shotgunner" or role == "elite")
		local cmb_mat = Material("sprites/mat_jack_helmoverlay_r")
        local lply = LocalPlayer()
        if lply:Alive() and lply.PlayerClassName == "combine" then
		if is_red then
                surface.SetDrawColor(255,25,25,255)
            else
                surface.SetDrawColor(25,190,190,255)
            end
            surface.SetMaterial(cmb_mat)
            surface.DrawTexturedRectRotated(
                (ScrW()/2) - 5,
                (ScrH()/2) - 5,
                ScrW() + 10,
                ScrH() + 450,
                180
            )
            render.PushFilterMag(TEXFILTER.ANISOTROPIC)
            render.PushFilterMin(TEXFILTER.ANISOTROPIC)
            render.PopFilterMag()
            render.PopFilterMin()
        end
    end)
end
return CLASS