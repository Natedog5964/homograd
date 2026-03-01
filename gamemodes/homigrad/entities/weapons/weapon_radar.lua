SWEP.Base = "weapon_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("hg.radar.name")
	SWEP.Author = "Secret Society" -- Thanks Harrison!
	SWEP.Instructions = language.GetPhrase("hg.radar.inst")
	SWEP.Category = language.GetPhrase("hg.category.traitors")
	SWEP.IconOverride = "materials/items_icons/radaricon.png"
end

SWEP.Spawnable = true
SWEP.AdminOnly = false

-- SWEP primary properties
SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.Slot = 3
SWEP.SlotPos = 5

-- Model for the SWEP
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/w_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

-- Range and other properties
SWEP.Range = 5000
SWEP.LastUpdate = 0
SWEP.UpdateInterval = 30 -- Time in seconds between updates
SWEP.PlayerLocations = {}

-- Cooldown properties
SWEP.LastPrimaryAttack = 0
SWEP.PrimaryAttackCooldown = 25 -- Cooldown time in seconds

-- Initialize the SWEP
function SWEP:Initialize()
	self:SetHoldType("slam")
	local swep = self 
end

function SWEP:SecondaryAttack()
end

function SWEP:PrimaryAttack()
	local curTime = CurTime()

	-- Check for cooldown
	if curTime < self.LastPrimaryAttack + self.PrimaryAttackCooldown then return end

	-- Check if there's enough ammo (charges) left
	if self.Primary.ClipSize > 0 then
		self:UpdatePlayerLocations() -- Perform the update

		-- Decrease the clip size
		self.Primary.ClipSize = self.Primary.ClipSize - 1

		-- Set the last attack time
		self.LastPrimaryAttack = curTime

		-- Play sound for the action
		self:GetOwner():EmitSound("ambient/energy/zap" .. math.random(1, 3) .. ".wav", 75, 100, 0.25)
	else
		-- Optionally notify the player that there are no charges left
		if not IsFirstTimePredicted() then self:GetOwner():ChatPrint("#hg.radar.nocharges") end

		self:GetOwner():EmitSound("common/wpn_denyselect.wav")
	end

	return
end

-- Helper function to update player positions
function SWEP:UpdatePlayerLocations()
	-- Clear existing locations
	self.PlayerLocations = {}

	-- Iterate through all players in the game
	for _, ply in ipairs(player.GetAll()) do
		if ply:Team() ~= TEAM_SPECTATOR and ply:IsPlayer() and ply:Alive() and ply ~= self:GetOwner() then
			local plyPos = ply:GetPos() + Vector(0, 0, 30) -- Raise the marker slightly above ground

			table.insert(self.PlayerLocations, {
				pos = plyPos,
				ply = ply
			})
		end
	end
end

-- Material for the sprite (can be replaced with any sprite)
local material = Material("sprites/grip")

hook.Add( "HUDPaint", "DrawPlayerSprites", function()
    local ply = LocalPlayer()
    if not ply:Alive() then return end

    local wep = ply:GetActiveWeapon()
    if not IsValid( wep ) then return end
    if wep:GetClass() ~= "weapon_radar" then return end
    if not wep.PlayerLocations then return end
    if #wep.PlayerLocations == 0 then return end

    local curTime = CurTime()
    cam.Start3D() -- Start 3D rendering context

    for _, data in ipairs( wep.PlayerLocations ) do
        local plyPos = data.pos
        local size = 64 -- Size of the sprite

		-- Decrement the alpha value over time
        data.alpha = data.alpha or 255 -- Initialize alpha if not present
		data.alpha = data.alpha - .12 -- Decrease alpha (adjust this value to control speed)
		
		-- Remove Entry when alpha is 0
		if data.alpha <= 0 then 
		table.remove(wep.PlayerLocations, i) 
			continue 
		end
		-- Set sprite material and draw it at the player's position
        render.SetMaterial( material )
        render.DrawSprite( plyPos, size, size, Color( 255, 0, 0, data.alpha ) ) -- Bright red sprite

        -- 3d lines in the direction of the player
        local wepPos = wep:GetBonePosition( 1 )
        local direction = ( plyPos - wepPos ):GetNormalized()
        local endPoint = wepPos + direction * 45
        render.DrawLine( wepPos, endPoint, Color( 255, 0, 0, data.alpha ) )

        -- arrowhead
        local arrowSize = 4
        local perpendicular = Vector( 0, 0, 1 ):Cross( direction ):GetNormalized()
        if perpendicular:LengthSqr() == 0 then
            perpendicular = Vector( 0, 1, 0 ):Cross( direction ):GetNormalized()
        end
        local arrowPoint1 = endPoint - direction * arrowSize + perpendicular * arrowSize * 0.5
        local arrowPoint2 = endPoint - direction * arrowSize - perpendicular * arrowSize * 0.5
        render.DrawLine( endPoint, arrowPoint1, Color( 255, 0, 0, data.alpha ) )
        render.DrawLine( endPoint, arrowPoint2, Color( 255, 0, 0, data.alpha ) )
    end
    cam.End3D()
end )

function SWEP:OnRemove()
	-- self.PlayerLocations = {}

	return
end

function SWEP:Deploy()
	self.LastUpdate = 0
end

function SWEP:Holster(wep)
	return true
end