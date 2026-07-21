file.CreateDir("homigrad/maps")

SpawnPointsPage = SpawnPointsPage or 1

SpawnPointsList = {
	regular = {"normal", Color(255, 240, 200)}, -- Normal / Fallback For Most Spawns
	
	dm = {"dm", Color(155, 155, 255)}, -- ffa spawns 
	
	spawnpointst = {"red", Color(255, 0, 0)}, -- Team DeathMatch Spawns
	
	spawnpointsct = {"blue", Color(0, 0, 255)}, -- Team DeathMatch Spawns / Homicide Police



	spawnpoints_ss_police = {"police", Color(0, 0, 125)}, -- Homicide Police For Some Versions
	
	car_red = {"car_red", Color(125, 125, 125)},
	car_police = {"car_police", Color(125, 125, 125)},
	
	--[[	
	spawnpointsseekers = {"seekers", Color(255, 0, 0)},	-- Hide&Seek/Juggernuat
	spawnpointshiders = {"hiders", Color(0, 255, 0)}, -- Zombie/Hide&Seek/Juggernuat
	spawnpoints_ss_exit = {"exit", Color(0, 125, 0), true}, -- Zombie/Hide&Seek


-- Base Defence Only 
	boxspawn = {"boxspawn", Color(25, 25, 25)},
	basedefencebots = {"basedefencebots", Color(155, 155, 155)},
	basedefencegred = {"basedefencegred", Color(255, 255, 255)},
	basedefenceplayerspawns = {"basedefenceplayerspawns", Color(255, 255, 0)},
	basedefencegred_ammo = {"basedefencegred_ammo", Color(25, 25, 25)},
	gred_simfphys_brdm2 = {"gred_simfphys_brdm2", Color(25, 25, 25)},
	
-- Bahmut Only
	bahmut_vagner = {"vagner", Color(255, 0, 0)},
	bahmut_nato = {"nato", Color(0, 0, 255)},
	wac_hc_ah1z_viper = {"wac_hc_ah1z_viper", Color(25, 25, 25)},
	wac_hc_littlebird_ah6 = {"wac_hc_littlebird_ah6", Color(25, 25, 25)},
	wac_hc_mi28_havoc = {"wac_hc_mi28_havoc", Color(25, 25, 25)},
	wac_hc_blackhawk_uh60 = {"wac_hc_blackhawk_uh60", Color(25, 25, 25)},
	controlpoint = {"control_point", Color(25, 25, 25)},
	car_red = {"car_red", Color(125, 125, 125)},
	car_blue = {"car_blue", Color(125, 125, 125)},
	car_red_btr = {"car_red_btr", Color(125, 125, 125)},
	car_blue_btr = {"car_blue_btr", Color(125, 125, 125)},
	car_red_tank = {"car_red_tank", Color(125, 125, 125)},
	car_blue_tank = {"car_blue_tank", Color(125, 125, 125)},
	gred_emp_dshk = {"gred_emp_dshk", Color(25, 25, 25)},
	gred_ammobox = {"gred_ammobox", Color(25, 25, 25)},
	gred_emp_2a65 = {"gred_emp_2a65", Color(25, 25, 25)},
	gred_emp_pak40 = {"gred_emp_pak40", Color(25, 25, 25)},
	gred_emp_breda35 = {"gred_emp_breda35", Color(25, 25, 25)},
	]]
	
	-- Unsure What This Does?
	center = {"center", Color(255, 255, 255)}, 
}

function GetDataMapName(name)
	return "homigrad/maps/" .. name .. "/" .. game.GetMap() .. (SpawnPointsPage == 1 and "" or SpawnPointsPage) .. ".txt"
end

function GetMaxDataPages(name)
	local i = 0

	while true do
		i = i + 1
		if not file.Exists("homigrad/maps/" .. name .. "/" .. game.GetMap() .. (i == 1 and "" or i) .. ".txt", "DATA") then return i - 1 end
	end
end

function ReadDataMap(name)
	return util.JSONToTable(file.Read(GetDataMapName(name), "DATA") or "") or {}
end

function WriteDataMap(name, data)
	file.CreateDir("homigrad/maps/" .. name)
	file.Write(GetDataMapName(name), util.TableToJSON(data or {}) or "")
end

-- Reading and writing spawnpoints
function SetupSpawnPointsList()
	for name, info in pairs(SpawnPointsList) do
		info[3] = ReadDataMap(name)
	end
end

SetupSpawnPointsList()

util.AddNetworkString("points")

function SendSpawnPoint(ply)
	net.Start("points")
	net.WriteTable(SpawnPointsList)

	if ply then net.Send(ply)
	else net.Broadcast() end
end

COMMANDS.point = {
	function(ply, args)
		local name

		for _name, info in pairs(SpawnPointsList) do
			if info[1] == args[1] then
				name = _name
				break
			end
		end

		if not name then return ply:ChatPrint("No such point!") end

		local tbl = ReadDataMap(name)
		local point = {ply:GetPos() + Vector(0, 0, 5), Angle(0, ply:EyeAngles()[2], 0), tonumber(args[2])}

		table.insert(tbl, point)
		WriteDataMap(name, tbl)

		PrintMessage(3, "Added New Point: " .. args[1])

		SetupSpawnPointsList()
		SendSpawnPoint()
	end
}

COMMANDS.pointreset = {
	function(ply, args)
		if not args[1] then return end

		for name, info in pairs(SpawnPointsList) do
			if info[1] ~= args[1] then continue end

			WriteDataMap(name)

			break
		end

		PrintMessage(3, "Points with name " .. args[1] .. " cleared.")

		SetupSpawnPointsList()
		SendSpawnPoint()
	end
}

COMMANDS.pointsync = {
	function(ply, args)
		SendSpawnPoint()
	end
}

COMMANDS.pointpage = {
	function(ply, args)
		if not args[1] then return end

		SpawnPointsPage = tonumber(args[1])

		SetupSpawnPointsList()
		SendSpawnPoint()
		PrintMessage(3, "Points variation #" .. SpawnPointsPage)
	end
}

COMMANDS.pointpages = {
	function(ply, args)
		if not args[1] then return end

		PrintMessage(3, GetMaxDataPages(args[1]))
	end
}