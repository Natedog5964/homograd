SWEP.Base = "weapon_base"

if CLIENT then
	SWEP.PrintName = "Claymore"
	SWEP.Author = "Secret Society"
	SWEP.Instructions = "FACE THIS SIDE TOWARD ENEMY"
	SWEP.Category = language.GetPhrase("hg.category.traitors")
	SWEP.IconOverride = "materials/items_icons/propbombicon.png"
end

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/jmod/claymore.mdl"
SWEP.WorldModel = "models/jmod/claymore.mdl"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.dwsPos = Vector(20, 20, 20)
SWEP.dwsItemPos = Vector(0, 0, 0)


	function SWEP:PrimaryAttack()
			local owner = self:GetOwner()
			if self.Primary.ClipSize < 1 then return end

			local tr = {}
			tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos

			local dir = Vector(1, 0, 0)
			dir:Rotate(owner:EyeAngles())

			tr.endpos = tr.start + dir * 75
			tr.filter = owner
			local traceResult = util.TraceLine(tr)
			local ent = traceResult.Entity
			
			local ang = owner:EyeAngles()
			ang:Add(Angle(0,-90,0))
			
			self.Primary.ClipSize = self.Primary.ClipSize - 1
			
		if SERVER then 
			if not IsValid(ent) or ent:IsWorld() then
				ent = ents.Create("ent_jack_gmod_ezminimore")
				ent:SetColor(Color(81,87,61))
				ent:SetPos(traceResult.HitPos)
				ent:SetAngles(ang)
				ent:Spawn()
				ent:Arm()
			end
			ent:EmitSound("snd_jack_minearm.wav", 60, 50)
		end
	end

	function SWEP:SecondaryAttack() end
	
	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()
		if not IsValid(owner) then return self:DrawModel() end
		
		self.mdl = self.mdl or false
		
		local matrix = self:GetOwner():GetBoneMatrix(11)
		
		if not IsValid(self.mdl) then
			self.mdl = ClientsideModel("models/jmod/claymore.mdl")
			self.mdl:SetModelScale(0.5)
			self.mdl:SetAngles(Angle(180,0,90))
			self.mdl:SetRenderOrigin(matrix:GetTranslation() + matrix:GetAngles():Forward() * 3 + matrix:GetAngles():Right() * 3)
			self.mdl:SetRenderAngles(matrix:GetAngles())
		end

		self.mdl:SetNoDraw(true)

		local matrix = self:GetOwner():GetBoneMatrix(11)
		if not matrix then return end

		self.mdl:SetRenderOrigin(matrix:GetTranslation() + matrix:GetAngles():Forward() * 3 + matrix:GetAngles():Right() * 3)
		self.mdl:SetRenderAngles(matrix:GetAngles())
		self.mdl:DrawModel()
	end
