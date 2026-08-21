hl2.ragdolls = {}

local function GetTeamSpawns(ply)
	local spawnsT = tdm.SpawnsTwoCommand()

	if ply:Team() == 1 then return spawnsT
	else return false end
end

function hl2.StartRoundSV()
	local players = PlayersInGame()
	local spawnsT, _ = tdm.SpawnsTwoCommand()

	--tdm.RemoveItems()

	roundTimeStart = CurTime()
	roundTimeRespawn = CurTime() + 4
	roundTime = 7 * 24 * 60 * 60 -- Seven days in seconds.

	tdm.SpawnCommand(team.GetPlayers(1), spawnsT)

	for _, ply in pairs(players) do
		ply:SetTeam(1)
	end

	return {roundTimeStart, roundTime}
end

function hl2.Think()
	hl2.LastWave = hl2.LastWave or CurTime() + 15

	if CurTime() >= hl2.LastWave then
		SetGlobalInt("hl2_respawntime", CurTime())

		for _, v in player.Iterator() do
			local players = {}

			if not v:Alive() and v:Team() ~= 1002 then
				v:Spawn()

				local teamspawn = GetTeamSpawns(v)
				local key = math.random(#teamspawn)
				local point = ReadPoint(teamspawn[key])

				if point then
					v:SetPos(point[1])

					table.remove(teamspawn, key)
				end

				players[v:Team()] = players[v:Team()] or {}
				players[v:Team()][v] = true
			end
		end

		for ent in pairs(hl2.ragdolls) do
			if IsValid(ent) then ent:Remove() end
			hl2.ragdolls[ent] = nil
		end

		hl2.LastWave = CurTime() + 10
	end
end

function hl2.PlayerSpawn2(ply, teamID)
	-- Set the player's model to the custom model if available, otherwise use a random team model
	local customModel = GetPlayerModelBySteamID(ply:SteamID()) or false

	if customModel then
		ply:SetModel(customModel)
	else
		--ply:SetModel(tdm.models[math.random(#tdm.models)]) 
		EasyAppearance.SetAppearance(ply)
	end
	ply:SetPlayerColor(Vector(0, 0, 0.6))
	
	ply:Give("weapon_hands")
	
	-- FIXME: This doesn't seem to work.
	if ply.allowGrab then ply.allowGrab = false end
end

function hl2.PlayerInitialSpawn(ply)
	ply:SetTeam(1)
end

function hl2.PlayerCanJoinTeam(ply, teamID)
	if teamID == 2 or teamID == 3 then return false end
	return true
end

function hl2.GuiltLogic()
	return false
end

function hl2.ShouldSpawnLoot()
	return false
end

util.AddNetworkString("hl2_die")

function hl2.PlayerDeath()
	net.Start("hl2_die")
	net.Broadcast()
end

changeClass = {
	--["prop_vehicle_jeep"] = "vehicle_van",
	--["prop_vehcle_jeep_old"] = "vehicle_van",
	--["prop_vehicle_airboat"] = "vehicle_van",
	["weapon_crowbar"] = "weapon_hl3_crowbar",
	--["weapon_stunstick"] = "weapon_police_bat",
	--["weapon_pistol"] = "weapon_hl3_usp",
	--["weapon_357"] = "weapon_357_magnum",
	--["weapon_shotgun"] = "weapon_hl3_spas12",
	["weapon_crossbow"] = "weapon_hl3_crossbow",
	--["weapon_ar2"] = "weapon_hl3_sar2",
	--["weapon_smg1"] = "weapon_hl3_mp7",
	--["weapon_frag"] = "weapon_hl3_nade",
	["weapon_slam"] = "weapon_hg_molotov",
	--["weapon_rpg"] = "ent_ammo_46x30mm",
	--["item_ammo_ar2_altfire"] = "ent_ammo_762x39mm",
	--["item_ammo_357"] = "ent_ammo_.44magnum",
	--["item_ammo_357_large"] = "ent_ammo_.44magnum",
	--["item_ammo_pistol"] = "ent_ammo_9x19mm",
	--["item_ammo_pistol_large"] = "ent_ammo_9x19mm",
	-- ["item_ammo_ar2"] = "ent_ammo_556x45mm",
	-- ["item_ammo_ar2_large"] = "ent_ammo_556x45mm",
	--["item_ammo_ar2_smg1"] = "ent_ammo_545x39mm",
	--["item_ammo_ar2_large"] = "ent_ammo_556x45mm",
	--["item_ammo_smg1"] = "ent_ammo_545x39mm",
	--["item_ammo_smg1_large"] = "ent_ammo_762x39mm",
--	["item_box_buckshot"] = "ent_ammo_12/70gauge",
	--["item_box_buckshot_large"] = "ent_ammo_12/70gauge",
	--["item_rpg_round"] = "ent_ammo_57x28mm",
	--["item_ammo_crate"] = "ent_ammo_9x39mm",
	["item_healthvial"] = "med_band_small",
	["item_healthkit"] = "med_band_big",
	["item_healthcharger"] = "medkit",
	["item_suitcharger"] = "painkiller",
	["item_battery"] = "blood_bag",
	--["weapon_alyxgun"] = {"food_fishcan", "food_lays", "food_monster", "food_spongebob_home"}
}
hook.Add( "PlayerCanPickupWeapon", "ReplacePistolWithhl3pistol", function( ply, weapon )
    if ( weapon:GetClass() == "weapon_pistol" ) then
        if ply:HasWeapon("weapon_hl3_usp") then
            ply:GiveAmmo(18, "pistol", false)
        else
            ply:Give("weapon_hl3_usp")
        end
        weapon:Remove()
        return false
    end
end )
hook.Add( "PlayerCanPickupWeapon", "ReplacesmgWithhl3smg", function( ply, weapon )
    if ( weapon:GetClass() == "weapon_smg1" ) then
        if ply:HasWeapon("weapon_smg1") then
            ply:GiveAmmo(45, "smg1", false)
        else
            ply:Give("weapon_hl3_mp7")
        end
        weapon:Remove()
        return false
    end
end )
hook.Add( "PlayerCanPickupWeapon", "ReplacesCROSSBOWWithhl3crossbow", function( ply, weapon )
    if ( weapon:GetClass() == "weapon_crossbow" ) then
        if ply:HasWeapon("weapon_crossbow") then
            ply:GiveAmmo(18, "XBowBolt", false)
        else
            ply:Give("weapon_hl3_crossbow")
        end
        weapon:Remove()
        return false
    end
end )
hook.Add( "PlayerCanPickupWeapon", "Replace357Withhl3357", function( ply, weapon )
    if ( weapon:GetClass() == "weapon_357" ) then
        if ply:HasWeapon("weapon_357") then
            ply:GiveAmmo(6, "357", false)
        else
            ply:Give("weapon_357_magnum")
        end
        weapon:Remove()
        return false
    end
end )
hook.Add( "PlayerCanPickupWeapon", "ReplaceshotieWithhl3shotie", function( ply, weapon )
    if ( weapon:GetClass() == "weapon_shotgun" ) then
        if ply:HasWeapon("weapon_shotgun") then
            ply:GiveAmmo(8, "buckshot", false)
        else
            ply:Give("weapon_hl3_spas12")
        end
        weapon:Remove()
        return false
    end
end )
hook.Add( "PlayerCanPickupWeapon", "Replacear2Withhl3", function( ply, weapon )
    if ( weapon:GetClass() == "weapon_ar2" ) then
        if ply:HasWeapon("weapon_ar2") then
            ply:GiveAmmo(30, "ar2", false)
        else
            ply:Give("weapon_hl3_sar2")
        end
        weapon:Remove()
        return false
    end
end )
hook.Add( "PlayerCanPickupWeapon", "ReplacesFRAGWithhl3BALLER", function( ply, weapon )
    if ( weapon:GetClass() == "weapon_frag" ) then
        if ply:HasWeapon("weapon_frag") then
            ply:GiveAmmo(1, "grenade", false)
        else
            ply:Give("weapon_hl3_nade")
        end
		
        weapon:Remove()
        return false
    end
end )