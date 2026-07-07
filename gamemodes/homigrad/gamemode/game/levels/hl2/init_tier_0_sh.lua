-- if SERVER and GetConVar("hg_ConstructOnly"):GetBool() then table.insert(LevelList, "construct") end -- Disabled in normal gameplay

table.insert(LevelList, "hl2")


hl2 = {}
hl2.Name = "hl2"
hl2.LoadScreenTime = 2.5
hl2.NoSelectRandom = true

local red = Color(155, 155, 255)

function hl2.GetTeamName(ply)
	local teamID = ply:Team()

	if teamID == 1 then return "Freemans", red end
end

function hl2.StartRound(data)
	team.SetColor(1, red)
	-- team.SetColor(2, blue)
	-- team.SetColor(1, green)

	game.CleanUpMap(false)

	if CLIENT then
		roundTimeStart = data[1]
		roundTime = data[2]

		hl2.StartRoundCL()

		return
	end

	return hl2.StartRoundSV()
end

if SERVER then return end

local playsound = false

function hl2.StartRoundCL()
	playsound = true
end

function hl2.HUDPaint_RoundLeft(white)
	local lply = LocalPlayer()
	local startRound = roundTimeStart + 5 - CurTime()

	if startRound > 0 and lply:Alive() then
		if playsound then playsound = false end

		lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 220), 0.5, 4)

		return
	end
end

-- For construct, this is probably fine because I assume that it will just force respawn the player.
net.Receive("hl2_die", function() timeStartAnyDeath = CurTime() end)

--[[
function construct.CanUseSpectateHUD()
	return false
end	
]]

hl2.RoundRandomDefalut = 3